//
//  ToolPanel.m
//  villian
//
//  Created by John Detloff on 12/15/12.
//  Copyright (c) 2012 Groucho. All rights reserved.
//

#import "ToolPanel.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation ToolPanel {
    NSTimer *_timer;
    UILabel *_timerLabel;
    UILabel *_killCountLabel;
    UILabel *_zomCountLabel;
    UIButton *_zomButton;
    UIButton *_fearButton;
    UIButton *_distractButton;
    UILabel *_goalLabel;
    UIButton *_speedButton;
    
    NSInteger _bonusZom;
    NSInteger _bonusFear;
    NSInteger _bonusDistract;
    NSInteger _bonusSpeed;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, frame.size.width-5, 50)];
        label.text = @"Time Remaining";
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 2;
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
        
        _timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 55, frame.size.width-5, 20)];
        _timerLabel.backgroundColor = [UIColor clearColor];
        _timerLabel.textAlignment = NSTextAlignmentCenter;
        _timerLabel.text = @"3:00";
        [self addSubview:_timerLabel];
        
        _timeRemaining = 180;
        
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        
        UILabel *killCount = [[UILabel alloc] initWithFrame:CGRectMake(5, 100, frame.size.width-5, 50)];
        killCount.text = @"Humans Infected";
        killCount.numberOfLines = 2;
        killCount.backgroundColor = [UIColor clearColor];
        killCount.textAlignment = NSTextAlignmentCenter;
        [self addSubview:killCount];
        
        _killCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 145, frame.size.width-5, 30)];
        _killCountLabel.backgroundColor = [UIColor clearColor];
        _killCountLabel.textAlignment = NSTextAlignmentCenter;
        _killCountLabel.text = @"0000";
        [self addSubview:_killCountLabel];
        
        UILabel *goal = [[UILabel alloc] initWithFrame:CGRectMake(5, 180, frame.size.width-5, 30)];
        goal.text = @"Goal";
        goal.backgroundColor = [UIColor clearColor];
        goal.textAlignment = NSTextAlignmentCenter;
        [self addSubview:goal];
        
        _goalLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 202, frame.size.width-5, 30)];
        _goalLabel.backgroundColor = [UIColor clearColor];
        _goalLabel.textAlignment = NSTextAlignmentCenter;
        _goalLabel.text = @"0000";
        [self addSubview:_goalLabel];
        
        UILabel *zomCount = [[UILabel alloc] initWithFrame:CGRectMake(5, 245, frame.size.width-5, 20)];
        zomCount.text = @"Zombies";
        zomCount.backgroundColor = [UIColor clearColor];
        zomCount.textAlignment = NSTextAlignmentCenter;
        [self addSubview:zomCount];
        
        _zomCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 260, frame.size.width-5, 30)];
        _zomCountLabel.backgroundColor = [UIColor clearColor];
        _zomCountLabel.textAlignment = NSTextAlignmentCenter;
        _zomCountLabel.text = @"0000";
        [self addSubview:_zomCountLabel];
        
        _zomButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 320, 55, 55)];
        [_zomButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _zomButton.backgroundColor = [UIColor greenColor];
        [_zomButton addTarget:self action:@selector(selectZom) forControlEvents:UIControlEventTouchUpInside];
        _zomButton.layer.borderColor = [[UIColor blackColor] CGColor];
        [self addSubview:_zomButton];

        _fearButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 400, 55, 55)];
        _fearButton.backgroundColor = [UIColor redColor];
        [_fearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_fearButton addTarget:self action:@selector(selectFear) forControlEvents:UIControlEventTouchUpInside];
        _fearButton.layer.borderColor = [[UIColor blackColor] CGColor];
        [self addSubview:_fearButton];
        
        _distractButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 480, 55, 55)];
        _distractButton.backgroundColor = [UIColor grayColor];
        [_distractButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_distractButton addTarget:self action:@selector(selectDistract) forControlEvents:UIControlEventTouchUpInside];
        _distractButton.layer.borderColor = [[UIColor blackColor] CGColor];
        [self addSubview:_distractButton];
        
        _speedButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 560, 55, 55)];
        _speedButton.backgroundColor = [UIColor blueColor];
        [_speedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_speedButton addTarget:self action:@selector(selectSpeed) forControlEvents:UIControlEventTouchUpInside];
        _speedButton.layer.borderColor = [[UIColor blackColor] CGColor];
        [self addSubview:_speedButton];
        
        UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 650, 55, 55)];
        menuButton.layer.borderWidth = 3.0;
        menuButton.layer.borderColor = [[UIColor blackColor] CGColor];
        [menuButton setTitle:@"Quit" forState:UIControlStateNormal];
        [menuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuButton];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _bonusZom = [defaults integerForKey:@"zom"];
        _bonusFear = [defaults integerForKey:@"fear"];
        _bonusDistract = [defaults integerForKey:@"distract"];
        _bonusSpeed = [defaults integerForKey:@"speed"];
        
        _numberOfZomAttacks = NSNotFound;
        _numberOfFearAttacks = NSNotFound;
        _numberOfSpeedAttacks = NSNotFound;
        _numberOfDistractionAttacks = NSNotFound;
        
        [self selectZom];
    }
    return self;
}


- (void)tick {
    _timeRemaining--;
    
    int seconds = (int)_timeRemaining%60;
    int minutes = (int)_timeRemaining/60;
    
    _timerLabel.text = [NSString stringWithFormat:(seconds < 10 ? @"%i:0%i" : @"%i:%i"),minutes, seconds];
    
    if (_timeRemaining == 0) {
        [_timer invalidate];
        _timer = nil;
        
        [self.delegate timesUp];
    }
}


- (void)invalidate {
    [_timer invalidate];
}


- (void)setKillCount:(NSInteger)killCount {
    _killCount = killCount;
    
    _killCountLabel.text = [NSString stringWithFormat:@"%04i",killCount];
    
    if (_killCount == _goal) {
        [self.delegate win];
    }
}


- (void)setZomCount:(NSInteger)zomCount {
    _zomCount = zomCount;
    
    _zomCountLabel.text = [NSString stringWithFormat:@"%04i",zomCount];
    
    if (_zomCount == 0 && _numberOfZomAttacks == 0) {
        [self.delegate outOfZoms];
    }
}


- (void)selectZom {
    self.selectedTool = ZombieTool;
    _zomButton.layer.borderWidth = 3.0;
    _fearButton.layer.borderWidth = 0;
    _distractButton.layer.borderWidth = 0;
        _speedButton.layer.borderWidth = 0;
}


- (void)selectFear {
    self.selectedTool = FearTool;
    _zomButton.layer.borderWidth = 0;
    _fearButton.layer.borderWidth = 3.0;
    _distractButton.layer.borderWidth = 0;
        _speedButton.layer.borderWidth = 0;
}


- (void)selectDistract {
    self.selectedTool = DistractionTool;
    _zomButton.layer.borderWidth = 0;
    _fearButton.layer.borderWidth = 0;
    _distractButton.layer.borderWidth = 3.0;
    _speedButton.layer.borderWidth = 0;
}


- (void)selectSpeed {
    self.selectedTool = SpeedTool;
    _zomButton.layer.borderWidth = 0;
    _fearButton.layer.borderWidth = 0;
    _distractButton.layer.borderWidth = 0;
    _speedButton.layer.borderWidth = 3.0;
}


- (void)setNumberOfZomAttacks:(NSInteger)numberOfZomAttacks {
    if (_numberOfZomAttacks == NSNotFound) {
        numberOfZomAttacks += _bonusZom;
    }
    
    if (numberOfZomAttacks < _bonusZom) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:numberOfZomAttacks forKey:@"zom"];
        [defaults synchronize];
    }
    
    _numberOfZomAttacks = numberOfZomAttacks;
    [_zomButton setTitle:[NSString stringWithFormat:@"%i",numberOfZomAttacks] forState:UIControlStateNormal];
}


- (void)setNumberOfFearAttacks:(NSInteger)numberOfFearAttacks {
    if (_numberOfFearAttacks == NSNotFound) {
        numberOfFearAttacks += _bonusFear;
    }
    
    if (numberOfFearAttacks < _bonusFear) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:numberOfFearAttacks forKey:@"fear"];
        [defaults synchronize];
    }
    
    _numberOfFearAttacks = numberOfFearAttacks;
    [_fearButton setTitle:[NSString stringWithFormat:@"%i", numberOfFearAttacks] forState:UIControlStateNormal];
}


- (void)setNumberOfDistractionAttacks:(NSInteger)numberOfDistractionAttacks {
    if (_numberOfDistractionAttacks == NSNotFound) {
        numberOfDistractionAttacks += _bonusDistract;
    }
    
    if (numberOfDistractionAttacks < _bonusDistract) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:numberOfDistractionAttacks forKey:@"distract"];
        [defaults synchronize];
    }
    
    _numberOfDistractionAttacks = numberOfDistractionAttacks;
    [_distractButton setTitle:[NSString stringWithFormat:@"%i", numberOfDistractionAttacks] forState:UIControlStateNormal];
}


- (void)setNumberOfSpeedAttacks:(NSInteger)numberOfSpeedAttacks {
    if (_numberOfSpeedAttacks == NSNotFound) {
        numberOfSpeedAttacks += _bonusSpeed;
    }
    
    if (numberOfSpeedAttacks < _bonusSpeed) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:numberOfSpeedAttacks forKey:@"speed"];
        [defaults synchronize];
    }
    
    _numberOfSpeedAttacks = numberOfSpeedAttacks;
    [_speedButton setTitle:[NSString stringWithFormat:@"%i", numberOfSpeedAttacks] forState:UIControlStateNormal];
}


- (void)setGoal:(NSInteger)goal {
    _goal = goal;
    _goalLabel.text = [NSString stringWithFormat:@"%04i",goal];
}


- (void)quit {
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) displayMenu];
}


@end
