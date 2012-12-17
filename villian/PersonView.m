//
//  PersonView.m
//  villian
//
//  Created by John Detloff on 12/15/12.
//  Copyright (c) 2012 Groucho. All rights reserved.
//

#import "PersonView.h"

@implementation PersonView {
    NSTimer *_chaseTimer;
    NSTimer *_speedyTimer;
}


- (id)initWithZombified:(BOOL)zombified {
    self = [super init];
    if (self) {
        self.zombified = zombified;
    }
    return self;
}


- (void)setZombified:(BOOL)zombified {
    _zombified = zombified;
    
    if (_zombified) {
        self.backgroundColor = [UIColor greenColor];
    } else {
        self.backgroundColor = [UIColor blackColor];
    }
}


- (void)wanderWithFearDirection:(MoveDirection)fearDirection forbiddenDirection:(MoveDirection)forbiddenDirection {
    
    if (_chasingPoint) {
        [self moveToChasePointForbiddenDirection:forbiddenDirection];
        return;
    }
    
    int move = fearDirection;
    
    BOOL cornered = (forbiddenDirection == Corner);
    if (cornered) {
        move = [self oppositeDirection:self.tag];
    } else {
        if (move == NSNotFound) {
            int turn = arc4random()%10;
            if (turn == 0) {
                move = arc4random()%4;
            } else {
                move = self.tag;
            }
        }
        
        if (move == forbiddenDirection) {
            move = (move + arc4random()%3 + 1)%4;
        }
    }
    
    CGRect frame = self.frame;
    
    switch (move) {
        case 0:
            frame.origin.x--;
            break;
        case 1:
            frame.origin.x++;
            break;
        case 2:
            frame.origin.y--;
            break;
        case 3:
            frame.origin.y++;
            break;
            
        default:
            break;
    }
    
    self.tag = move;
    
    self.frame = frame;
}


- (MoveDirection)oppositeDirection:(MoveDirection)move {
    switch (move) {
        case Left:
            return Right;
        case Right:
            return Left;
        case Up:
            return Down;
        case Down:
            return Up;
        default:
            break;
    }
    return NSNotFound;
}


- (void)chasePerson:(PersonView *)closestPerson forbiddenDirection:(MoveDirection)forbiddenDirection {
    
    if (_chasingPoint) {
        [self moveToChasePointForbiddenDirection:forbiddenDirection];
        return;
    }
    
    CGRect zombieFrame = self.frame;

    CGFloat xDif = closestPerson.center.x - self.center.x;
    CGFloat yDif = closestPerson.center.y - self.center.y;
    int totalDiff = abs(xDif) + abs(yDif);
    if (totalDiff == 0) return;
    
    BOOL vertMove = arc4random()%((int)(abs(xDif)+abs(yDif))) < abs(yDif);
    if (vertMove) {
        if (yDif < 0) {
            zombieFrame.origin.y--;
        } else {
            zombieFrame.origin.y++;
        }
    } else {
        if (xDif < 0) {
            zombieFrame.origin.x--;
        } else {
            zombieFrame.origin.x++;
        }
    }
    
    self.frame = zombieFrame;
}


- (void)chasePoint:(CGPoint)point forTime:(NSTimeInterval)time {
    
    point = CGPointMake((int)point.x, (int)point.y);
    
    _chasingPoint = YES;
    _chasingPointLoc = point;
    
    [_chaseTimer invalidate];
    _chaseTimer = [NSTimer timerWithTimeInterval:time target:self selector:@selector(chaseUp) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_chaseTimer forMode:NSDefaultRunLoopMode];
}

- (void)chaseUp {
    self.chasingPerson.chasingZoms--;
    self.chasingPerson = nil;
    
    [_chaseTimer invalidate];
    _chaseTimer = nil;
    _chasingPoint = NO;
}


- (void)moveToChasePointForbiddenDirection:(MoveDirection)blockedDirection {
    CGRect zombieFrame = self.frame;
    
    MoveDirection move = NSNotFound;

    BOOL cornered = (blockedDirection == Corner);
    if (cornered) {
        _chasingPoint = NO;
        
    } else {
        int xDif = _chasingPointLoc.x - self.center.x;
        int yDif = _chasingPointLoc.y - self.center.y;
        int totalDiff = abs(xDif) + abs(yDif);
        if (totalDiff == 0) {
            _chasingPoint = NO;
            return;
        };
        
        BOOL vertMove = arc4random()%((int)(abs(xDif)+abs(yDif))) < abs(yDif);
        BOOL canMoveVert = (blockedDirection != Up || yDif > 0) && (blockedDirection != Down || yDif < 0);
        BOOL canMoveHor = ((blockedDirection != Left || xDif > 0) && (blockedDirection != Right || xDif < 0));
        
        if (canMoveVert && (vertMove || !canMoveHor)) {
            if (yDif < 0) {
                move = Up;
            } else if (yDif > 0){
                move = Down;
            }
        } else if (canMoveHor){
            if (xDif < 0) {
                move = Left;
            } else if (xDif > 0) {
                move = Right;
            }
        }
    }
    
    switch (move) {
        case 0:
            zombieFrame.origin.x--;
            break;
        case 1:
            zombieFrame.origin.x++;
            break;
        case 2:
            zombieFrame.origin.y--;
            break;
        case 3:
            zombieFrame.origin.y++;
            break;
            
        default:
            _chasingPoint = NO;
            break;
    }
    
    self.frame = zombieFrame;
}

- (void)setSpeedy:(BOOL)speedy {
    _speedy = speedy;
    
    if (_speedy) {
        [_speedyTimer invalidate];
        _speedyTimer = [NSTimer timerWithTimeInterval:4 target:self selector:@selector(despeed) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:_speedyTimer forMode:NSDefaultRunLoopMode];
    }
}


- (void)despeed {
    self.speedy = NO;
    [_speedyTimer invalidate];
    _speedyTimer = nil;
}

@end
