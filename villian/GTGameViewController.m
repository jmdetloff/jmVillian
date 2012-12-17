//
//  GTGameViewController.m
//  villian
//
//  Created by John Detloff on 12/14/12.
//  Copyright (c) 2012 Groucho. All rights reserved.
//

#import "GTGameViewController.h"
#import "PersonView.h"
#import "TurretView.h"
#import "ToolPanel.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface GTGameViewController () <TimesUpDelegate, UIAlertViewDelegate>
@end

int const smokeRadius = 80;
int const smokeDuration = 6;

@implementation GTGameViewController {
    NSMutableArray *_people;
    NSMutableArray *_blockingRects;
    NSMutableArray *_smokePoints;
    NSMutableArray *_fearRects;
    NSMutableArray *_zombies;
    NSMutableArray *_infectedZombies;
    NSMutableArray *_turrets;
    BOOL _zedDrop;
    CGPoint _swipeStart;
    NSMutableArray *_swipingZoms;
    ToolPanel *_toolPanel;
    NSTimer *_timer;
    NSTimer *_bombTimer;
    BOOL _endTimes;
    NSInteger _goal;
    NSArray *_weapons;
    BOOL _win;
    NSMutableArray *_coins;
}


- (id)initWithPeople:(NSUInteger)people blockingRects:(NSMutableArray *)blockingRects turrets:(NSMutableArray *)turrets goal:(NSInteger)goal weapons:(NSArray *)weapons{
    self = [super init];
    if (self) {
        _people = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < people; i++) {
            PersonView *personDot = [[PersonView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
            personDot.backgroundColor = [UIColor blackColor];
            [_people addObject:personDot];
        }
    
        _turrets = [[NSMutableArray alloc] init];
        for (NSMutableArray *locs in turrets) {
            CGPoint turretLoc = [[locs objectAtIndex:0] CGPointValue];
            TurretView *turret = [[TurretView alloc] initWithFrame:CGRectMake(turretLoc.x, turretLoc.y, 200, 200)];
            turret.locations = locs;
            [_turrets addObject:turret];
        }
        
        _goal = goal;
        _weapons = weapons;
        
        _blockingRects = blockingRects;
        
        _fearRects = [[NSMutableArray alloc] init];
        _zombies = [[NSMutableArray alloc] init];
        _infectedZombies = [[NSMutableArray alloc] init];
        _swipingZoms = [[NSMutableArray alloc] init];
        _smokePoints = [[NSMutableArray alloc] init];
        _coins = [[NSMutableArray alloc] init];
        
        UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        [self.view addGestureRecognizer:gestureRecognizer];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (NSValue *val in _blockingRects) {
        UIView *building = [[UIView alloc] initWithFrame:[val CGRectValue]];
        building.backgroundColor = [UIColor whiteColor];
        building.layer.borderWidth = 5;
        building.layer.borderColor = [[UIColor blackColor] CGColor];
        [self.view addSubview:building];
    }
    
    for (UIView *person in _people) {
        [self.view addSubview:person];
        
        CGPoint origin = CGPointZero;
        BOOL valid = NO;
        
        while (!valid) {
            CGFloat xCoord = arc4random() % 1024;
            CGFloat yCoord = arc4random() % 768;
            origin = CGPointMake(xCoord, yCoord);
            
            valid = YES;
            for (NSValue *val in _blockingRects) {
                if (CGRectContainsPoint([val CGRectValue], origin)) {
                    valid = NO;
                }
            }
        }

        person.frame = CGRectMake(origin.x, origin.y, person.frame.size.width, person.frame.size.height);
    }
    
    
    for (TurretView *turret in _turrets) {
        [self.view addSubview:turret];
    }
    
    _toolPanel = [[ToolPanel alloc] initWithFrame:CGRectMake(944, 0, 80, 768)];
    _toolPanel.numberOfDistractionAttacks = [[_weapons objectAtIndex:2] intValue];
    _toolPanel.numberOfFearAttacks = [[_weapons objectAtIndex:1] intValue];
    _toolPanel.numberOfZomAttacks = [[_weapons objectAtIndex:0] intValue];
    _toolPanel.numberOfSpeedAttacks = [[_weapons objectAtIndex:3] intValue];
    _toolPanel.delegate = self;
    _toolPanel.goal = _goal;
    [self.view addSubview:_toolPanel];
    
    _timer = [NSTimer timerWithTimeInterval:(0.04) target:self selector:@selector(move) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}


#pragma mark -


- (void)addSpeedRectAtPoint:(CGPoint)speedPoint {
    CGSize size = CGSizeMake(100, 100);
    CGRect newFearRect = CGRectMake(speedPoint.x - size.width/2, speedPoint.y - size.height/2, size.width, size.height);
    
    UIView *test = [[UIView alloc] initWithFrame:newFearRect];
    test.layer.cornerRadius = size.width/2;
    test.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:test];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    test.alpha = 0;
    [UIView commitAnimations];
    
    for (PersonView *zombie in _zombies) {
        if ([self distanceBetween:speedPoint and:zombie.center] < size.width/2) {
            zombie.speedy = YES;
        }
    }
    
    int64_t delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [test removeFromSuperview];
    });
}


- (void)dropCoinAtPoint:(CGPoint)point {
    CGSize size = CGSizeMake(20, 20);
    CGRect newFearRect = CGRectMake(point.x - size.width/2, point.y - size.height/2, 0, 0);
    
    UIView *test = [[UIView alloc] initWithFrame:newFearRect];
    test.clipsToBounds = NO;
    test.layer.cornerRadius = size.width/2;
    test.backgroundColor = [UIColor yellowColor];
    test.layer.borderWidth = 2;
    test.layer.borderColor = [[UIColor blackColor] CGColor];
    [self.view addSubview:test];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    test.frame = CGRectMake(newFearRect.origin.x, newFearRect.origin.y, size.width, size.height);
    [UIView commitAnimations];
    
    [_coins addObject:test];
    
    int64_t delayInSeconds = 6.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if ([_coins containsObject:test]) {
            [_coins removeObject:test];
            [test removeFromSuperview];
        }
    });
}


- (void)addFearRectAtPoint:(CGPoint)fearPoint withSize:(CGSize)size {
    CGRect newFearRect = CGRectMake(fearPoint.x - size.width/2, fearPoint.y - size.height/2, size.width, size.height);
    
    UIView *test = [[UIView alloc] initWithFrame:newFearRect];
    test.layer.cornerRadius = 40;
    test.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.1];
    [self.view addSubview:test];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:3.0];
    test.alpha = 0;
    [UIView commitAnimations];
    
    NSValue *fearRect = [NSValue valueWithCGRect:newFearRect];
    [_fearRects addObject:fearRect];
    
    int64_t delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_fearRects removeObject:fearRect];
        [test removeFromSuperview];
    });
}


- (void)addSmokeAtPoint:(CGPoint)smokePoint {
    CGRect smokeRect = CGRectMake(smokePoint.x - smokeRadius, smokePoint.y - smokeRadius, smokeRadius*2, smokeRadius*2);
    
    UIView *test = [[UIView alloc] initWithFrame:smokeRect];
    test.layer.cornerRadius = smokeRadius-15;
    test.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    [self.view addSubview:test];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:smokeDuration];
    test.alpha = 0;
    [UIView commitAnimations];
    
    NSValue *smokeVal = [NSValue valueWithCGPoint:smokePoint];
    [_smokePoints addObject:smokeVal];
    
    int64_t delayInSeconds = smokeDuration;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_smokePoints removeObject:smokeVal];
        [test removeFromSuperview];
    });
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint fearPoint = [[touches anyObject] locationInView:self.view];

    UIView *collectedCoin = nil;
    for (UIView *coin in _coins) {
        if ([self distanceBetween:coin.center and:fearPoint] < 50) {
            collectedCoin = coin;
        }
    }
    
    if (collectedCoin) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.7];
        collectedCoin.frame = CGRectMake(1024, -20, collectedCoin.frame.size.width, collectedCoin.frame.size.height);
        [UIView commitAnimations];
        
        CGFloat delayInSeconds = 0.7;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [collectedCoin removeFromSuperview];
        });
        
        [_coins removeObject:collectedCoin];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSInteger coins = [defaults integerForKey:@"coins"];
        coins++;
        [defaults setInteger:coins forKey:@"coins"];
        [defaults synchronize];
        return;
    }
    
    switch (_toolPanel.selectedTool) {
            
        case ZombieTool: {
            if (_toolPanel.numberOfZomAttacks > 0) {
                PersonView *ZombieDot = [[PersonView alloc] initWithFrame:CGRectMake(fearPoint.x, fearPoint.y, 5, 5)];
                ZombieDot.zombified = YES;
                [_zombies addObject:ZombieDot];
                _toolPanel.zomCount++;
                
                [self.view addSubview:ZombieDot];
                
                _toolPanel.numberOfZomAttacks--;
            }

            break;
        }
            
        case DistractionTool: {
            if (_toolPanel.numberOfDistractionAttacks > 0) {
                [self addSmokeAtPoint:fearPoint];
                _toolPanel.numberOfDistractionAttacks--;
            }
            break;
        }
            
        case FearTool: {
            if (_toolPanel.numberOfFearAttacks > 0) {
                [self addFearRectAtPoint:fearPoint withSize:CGSizeMake(120, 120)];
                _toolPanel.numberOfFearAttacks--;
            }
            break;
        }
            
        case SpeedTool: {
            if (_toolPanel.numberOfSpeedAttacks > 0) {
                [self addSpeedRectAtPoint:fearPoint];
                _toolPanel.numberOfSpeedAttacks--;
            }
        }
            
        default:
            break;
    }
    
}


#pragma mark -


- (void)move {
    
    if (_toolPanel.timeRemaining < 5) {
        [_bombTimer invalidate];
        _bombTimer = nil;
    }
    
    if (_toolPanel.timeRemaining < 150 && !_bombTimer) {
        int timeBeforeBomb;
        if (_toolPanel.timeRemaining < 5) {
            timeBeforeBomb = 0.005;
            _endTimes = YES;
        } else if (_toolPanel.timeRemaining < 30) {
            timeBeforeBomb = arc4random()%5;
        } else if (_toolPanel.timeRemaining < 60) {
            timeBeforeBomb = arc4random()%15;
        } else {
            timeBeforeBomb = arc4random()%20;
        }
        
        _bombTimer = [NSTimer timerWithTimeInterval:timeBeforeBomb target:self selector:@selector(startBomb) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:_bombTimer forMode:NSDefaultRunLoopMode];
    }
    
    for (TurretView *turret in _turrets) {
        
        BOOL inRange = NO;
        PersonView *deadZombie = nil;
        for (PersonView *zombie in _zombies) {
            
            BOOL hidden = NO;
            for (NSValue *smokeVal in _smokePoints) {
                CGPoint smokePoint = [smokeVal CGPointValue];
                if ([self distanceBetween:zombie.center and:smokePoint] < smokeRadius) {
                    hidden = YES;
                }
            }
            
            if (hidden) {
                continue;
            }
            
            if ([self distanceBetween:zombie.center and:turret.center] < turret.frame.size.width/2) {
                inRange = YES;
                BOOL attack = [turret fireOrLoad];
                if (attack) {
                    deadZombie = zombie;
                }
                break;
            }
        }
        if (!inRange) {
            [turret moveToLocation];
            [turret load];
        }
        if (deadZombie) {
            deadZombie.chasingPerson.chasingZoms--;
            [_zombies removeObject:deadZombie];
            _toolPanel.zomCount--;
            [deadZombie removeFromSuperview];
        }
    }
     
    for (PersonView *person in _people) {
        MoveDirection touchingDirection = [self determineForbiddenDirectionFor:person];
        MoveDirection fearDirection = [self determineFearDirectionFor:person forbiddenDirection:touchingDirection];
        [person wanderWithFearDirection:fearDirection forbiddenDirection:touchingDirection];
    }
    
    [_infectedZombies removeAllObjects];
    
    for (PersonView *zombie in _zombies) {
        [self zomMove:zombie];
        if (zombie.speedy) {
            [self zomMove:zombie];
        }
    }
    
    if ([_infectedZombies count] > 0) {
        _toolPanel.killCount += [_infectedZombies count];
        _toolPanel.zomCount += [_infectedZombies count];
    }
    [_zombies addObjectsFromArray:_infectedZombies];
}


- (void)zomMove:(PersonView *)zombie {
    CGFloat minDistance;
    PersonView *closestPerson = [self findClosestUntrackedHumanForZom:zombie minDistance:&minDistance];
    
    CGRect zombieFrame = zombie.frame;
    
    if (closestPerson) {
        
        if (minDistance < zombieFrame.size.width) {
            [_people removeObject:closestPerson];
            closestPerson.zombified = YES;
            if (zombie.chasingPoint) {
                [closestPerson chasePoint:zombie.chasingPointLoc forTime:5];
            }
            [self addFearRectAtPoint:closestPerson.center withSize:CGSizeMake(100, 100)];
            [_infectedZombies addObject:closestPerson];
            if (arc4random()%20 == 0) {
                [self dropCoinAtPoint:closestPerson.center];
            }
            zombie.chasingPerson = nil;
            
        } else {
            MoveDirection touchingDirection = [self determineForbiddenDirectionFor:zombie];
            [zombie chasePerson:closestPerson forbiddenDirection:touchingDirection];
        }
    } else {
        MoveDirection touchingDirection = [self determineForbiddenDirectionFor:zombie];
        [zombie wanderWithFearDirection:NSNotFound forbiddenDirection:touchingDirection];
    }
}


- (MoveDirection)determineForbiddenDirectionFor:(PersonView *)person {
    
    CGRect personFrame = person.frame;
    MoveDirection fearDirection = NSNotFound;
    NSInteger inRects = 0;
    
    for (NSValue *val in _blockingRects) {
        CGRect fear = [val CGRectValue];
        if (CGRectContainsPoint(fear, personFrame.origin) || CGRectContainsPoint(fear, CGPointMake(CGRectGetMaxX(personFrame), CGRectGetMaxY(personFrame)))) {
            
            inRects++;
            
            CGFloat xEscapeDistance;
            MoveDirection xEscape;
            if (personFrame.origin.x < fear.origin.x + fear.size.width/2) {
                xEscape = Right;
                xEscapeDistance = personFrame.origin.x - fear.origin.x;
            } else {
                xEscape = Left;
                xEscapeDistance = CGRectGetMaxX(fear) - personFrame.origin.x;
            }
            
            CGFloat yEscapeDistance;
            MoveDirection yEscape;
            if (personFrame.origin.y < fear.origin.y + fear.size.height/2) {
                yEscape = Down;
                yEscapeDistance = personFrame.origin.y - fear.origin.y;
            } else {
                yEscape = Up;
                yEscapeDistance = CGRectGetMaxY(fear) - personFrame.origin.y;
            }
            
            if (xEscapeDistance < yEscapeDistance) {
                fearDirection = xEscape;
            } else {
                fearDirection = yEscape;
            }
        }
    }
    
    if (inRects > 1) {
        return Corner;
    }
    return fearDirection;
}


- (MoveDirection)determineFearDirectionFor:(PersonView *)person forbiddenDirection:(MoveDirection)touchingDirection {
    
    CGRect personFrame = person.frame;
    MoveDirection fearDirection = NSNotFound;
    
    for (NSValue *val in _fearRects) {
        CGRect fear = [val CGRectValue];
        if (CGRectContainsPoint(fear, personFrame.origin)) {
            
            CGFloat xEscapeDistance;
            MoveDirection xEscape;
            if (personFrame.origin.x < fear.origin.x + fear.size.width/2) {
                xEscape = Left;
                xEscapeDistance = personFrame.origin.x - fear.origin.x;
            } else {
                xEscape = Right;
                xEscapeDistance = CGRectGetMaxX(fear) - personFrame.origin.x;
            }
            
            CGFloat yEscapeDistance;
            MoveDirection yEscape;
            if (personFrame.origin.y < fear.origin.y + fear.size.height/2) {
                yEscape = Up;
                yEscapeDistance = personFrame.origin.y - fear.origin.y;
            } else {
                yEscape = Down;
                yEscapeDistance = CGRectGetMaxY(fear) - personFrame.origin.y;
            }
            
            if (xEscapeDistance < yEscapeDistance) {
                fearDirection = (touchingDirection == xEscape ? yEscape : xEscape);
            } else {
                fearDirection = (touchingDirection != yEscape ? yEscape : xEscape);
            }
        }
    }
    return fearDirection;
}


- (CGFloat) distanceBetween:(CGPoint)point1 and:(CGPoint)point2 {
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy);
};


- (PersonView *)findClosestUntrackedHumanForZom:(PersonView *)zombie minDistance:(CGFloat*)minDistanceOut {
    
    PersonView *closestPerson = nil;
    CGFloat minDistance = 50;
    
    if (zombie.chasingPerson) {

        if (!zombie.chasingPerson.zombified) {
            *minDistanceOut = [self distanceBetween:zombie.center and:zombie.chasingPerson.center];
            return zombie.chasingPerson;
        } else {
            zombie.chasingPerson = nil;
        }

    }
    
    for (PersonView *person in _people) {
        CGFloat distance = [self distanceBetween:zombie.center and:person.center];
        if (distance < minDistance && person.chasingZoms < 3) {
            closestPerson = person;
            minDistance = distance;
        }
    }
    
    if (closestPerson) {
        if (zombie.chasingPerson != closestPerson) {
            closestPerson.chasingZoms++;
            zombie.chasingPerson = closestPerson;
        }
        
        *minDistanceOut = minDistance;
    }
    
    return closestPerson;
}


- (void)swipe:(UIPanGestureRecognizer *)gestureRecognizer {

    CGPoint stopLocation = [gestureRecognizer locationInView:self.view];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        _swipeStart = [gestureRecognizer locationInView:self.view];
    
    } else {
        
        NSMutableArray *nearZombies = [[NSMutableArray alloc] init];
        for (PersonView *zombie in _zombies) {
            if ([self distanceBetween:stopLocation and:zombie.center] < 30) {
                [nearZombies addObject:zombie];
            }
        }
    
        [_swipingZoms addObjectsFromArray:nearZombies];
    }
    
    for (PersonView *zom in _swipingZoms) {
        [zom chasePoint:stopLocation forTime:5];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        [_swipingZoms removeAllObjects];
    }
}


- (void)timesUp {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Times Up!" message:@"You ran out of time! The military fire bombed town to prevent the deadly spread of the goat zombie virus." delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil];
    [alertView show];
}


- (void)outOfZoms {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Zombies Defeated!" message:@"All your zombies have been killed! The people of town live on in peace :(" delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil];
    [alertView show];
}


- (void)win {
    _win = YES;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Town Defeated!" message:@"The people of town have all gone zed! You're a winner, proceed to the next level." delegate:self cancelButtonTitle:@"Next Level" otherButtonTitles:nil, nil];
    [alertView show];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int level = [defaults integerForKey:@"saved_level"];
    
    if (_win)level++;
    
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) displayGameForLevel:level];
}


- (void)startBomb {
    
    _bombTimer = nil;
    
    CGSize explosionSize = CGSizeMake(150, 150);
    
    NSInteger xCoord = arc4random()%900;
    NSInteger yCoord = arc4random()%748;
    CGPoint explosionPoint = CGPointMake(xCoord, yCoord);
    CGRect bombRect = CGRectMake(xCoord - explosionSize.width/2, yCoord - explosionSize.height/2, explosionSize.width, explosionSize.height);
    
    static UIImage *warningImage;
    static dispatch_once_t onceToken2;
    dispatch_once(&onceToken2, ^{
        UIGraphicsBeginImageContext(explosionSize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetLineWidth(context, 2.0);
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        CGContextAddEllipseInRect(context, CGRectMake(0, 0, explosionSize.width, explosionSize.height));
        const CGFloat array[] = {8};
        CGContextSetLineDash(context, 0, array, 1);
        CGContextStrokePath(context);
        
        warningImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    
    UIImageView *test = [[UIImageView alloc] initWithImage:warningImage];
    test.frame = bombRect;
    [self.view addSubview:test];
    
    UILabel *warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, explosionSize.height/2-10, bombRect.size.width, 20)];
    warningLabel.backgroundColor = [UIColor clearColor];
    warningLabel.textColor = [UIColor redColor];
    warningLabel.textAlignment = NSTextAlignmentCenter;
    warningLabel.text = @"WARNING!!";
    [test addSubview:warningLabel];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:(_endTimes ? 2 : 5)];
    test.alpha = 0;
    [UIView commitAnimations];
    
    int64_t delayInSeconds = (_endTimes ? 1.4 : 7.0);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        test.alpha = 1.0;
        
        static UIImage *explosionImage;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            UIGraphicsBeginImageContext(explosionSize);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetLineWidth(context, 2.0);
            UIColor *boomColor = [UIColor colorWithRed:255/255.f green:153/255.f blue:0/255.f alpha:1.0];
            CGContextSetFillColorWithColor(context, boomColor.CGColor);
            CGContextAddEllipseInRect(context, CGRectMake(5, 5, explosionSize.width-10, explosionSize.height-10));
            CGContextFillPath(context);
            explosionImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        });
        

        
        test.image = explosionImage;
        [warningLabel removeFromSuperview];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        test.alpha = 0;
        [UIView commitAnimations];
        
        NSMutableArray *deadPeople = [[NSMutableArray alloc] init];
        NSMutableArray *deadZoms = [[NSMutableArray alloc] init];
        
        for (PersonView *person in _people) {
            if ([self distanceBetween:explosionPoint and:person.center] < explosionSize.width/2) {
                [deadPeople addObject:person];
                [person removeFromSuperview];
            }
        }
        
        for (PersonView *zom in _zombies) {
            if ([self distanceBetween:explosionPoint and:zom.center] < explosionSize.width/2) {
                [deadZoms addObject:zom];
                [zom removeFromSuperview];
            } else if (zom.chasingPerson) {
                
                for (PersonView *person in deadPeople) {
                    if (zom.chasingPerson == person) {
                        zom.chasingPerson = nil;
                    }
                }
                
            }
        }
        
        [_people removeObjectsInArray:deadPeople];
        [_zombies removeObjectsInArray:deadZoms];

        _toolPanel.zomCount -= [deadZoms count];
        
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [test removeFromSuperview];
        });
    });
}


- (void)invalidate {
    [_timer invalidate];
    _timer = nil;
    [_bombTimer invalidate];
    _bombTimer = nil;
}


- (void)dealloc {
    [_toolPanel invalidate];
}

@end
