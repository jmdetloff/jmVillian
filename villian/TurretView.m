//
//  TurretView.m
//  villian
//
//  Created by John Detloff on 12/15/12.
//  Copyright (c) 2012 Groucho. All rights reserved.
//

#import "TurretView.h"
#import <QuartzCore/QuartzCore.h>

const int kReloadTime = 15;

@implementation TurretView {
    int _loadCount;
    BOOL _firing;
    UIView *_center;
    NSInteger _destinationIndex;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = frame.size.width/2;
        self.layer.borderColor = [[UIColor grayColor] CGColor];
        self.layer.borderWidth = 2.0;
        
        _center = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/2-5, frame.size.height/2-5, 10, 10)];
        _center.backgroundColor = [UIColor blueColor];
        _center.layer.cornerRadius = 5;
        [self addSubview:_center];
    }
    return self;
}


- (void)load {
    _center.backgroundColor = [UIColor blueColor];
    if (_loadCount%kReloadTime != 0) {
        _loadCount++;
    }
}


- (BOOL)fireOrLoad {
    _loadCount++;
    
    if (_loadCount%kReloadTime == 0) {
        _firing = YES;
    } else {
        _firing = NO;
    }
    
    if (_firing) {
        _center.backgroundColor = [UIColor redColor];
    } else {
        _center.backgroundColor = [UIColor blueColor];
    }
    
    return _firing;
}


- (void)moveToLocation {
    if ([_locations count] <= 1) return;
    
    CGPoint currentDestination = [[_locations objectAtIndex:_destinationIndex] CGPointValue];
    
    CGRect frame = self.frame;
    
    if (currentDestination.x < frame.origin.x) {
        frame.origin.x--;
    } else if (currentDestination.x > frame.origin.x) {
        frame.origin.x++;
    }
    
    if (currentDestination.y < frame.origin.y) {
        frame.origin.y--;
    } else if (currentDestination.y > frame.origin.y) {
        frame.origin.y++;
    }
    
    self.frame = frame;
    
    if (CGPointEqualToPoint(frame.origin, currentDestination)) {
        _destinationIndex = (_destinationIndex + 1)%[_locations count];
    }
}


@end
