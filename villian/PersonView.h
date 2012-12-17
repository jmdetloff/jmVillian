//
//  PersonView.h
//  villian
//
//  Created by John Detloff on 12/15/12.
//  Copyright (c) 2012 Groucho. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    Left,
    Right,
    Up,
    Down,
    Corner
} MoveDirection;


@interface PersonView : UIView


@property (nonatomic, assign) BOOL zombified;
@property (nonatomic, assign) NSUInteger chasingZoms;
@property (nonatomic, retain) PersonView *chasingPerson;
@property (nonatomic, assign, readonly) BOOL chasingPoint;
@property (nonatomic, assign) CGPoint chasingPointLoc;
@property (nonatomic, assign) BOOL speedy;

- (id)initWithZombified:(BOOL)zombified;
- (void)wanderWithFearDirection:(MoveDirection)fearDirection forbiddenDirection:(MoveDirection)forbiddenDirection;
- (void)chasePerson:(PersonView *)closestPerson forbiddenDirection:(MoveDirection)forbiddenDirection;
- (void)chasePoint:(CGPoint)point forTime:(NSTimeInterval)time;

@end
