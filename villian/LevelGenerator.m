//
//  LevelGenerator.m
//  villian
//
//  Created by John Detloff on 12/17/12.
//  Copyright (c) 2012 Groucho. All rights reserved.
//

#import "LevelGenerator.h"

@implementation LevelGenerator

+ (GTGameViewController *)controllerForLevel:(NSInteger)levelNum {
    
    GTGameViewController *controller;
    
    NSArray *walls = @[ [NSValue valueWithCGRect:CGRectMake(-10, 0, 10, 758)],
                        [NSValue valueWithCGRect:CGRectMake(944, 0, 200, 748)],
                        [NSValue valueWithCGRect:CGRectMake(0, -10, 1024, 10)],
                        [NSValue valueWithCGRect:CGRectMake(0, 768, 1024, 10)]];
    
    switch (levelNum) {
        case 1: {
            
            NSMutableArray *blockingRects = [[
                                              @[[NSValue valueWithCGRect:CGRectMake(78, 114, 106, 240)],
                                              [NSValue valueWithCGRect:CGRectMake(78, 408, 106, 270)],
                                              [NSValue valueWithCGRect:CGRectMake(180, 598, 260, 80)],
                                              [NSValue valueWithCGRect:CGRectMake(495, 598, 260, 80)],
                                              [NSValue valueWithCGRect:CGRectMake(752, 114, 106, 240)],
                                              [NSValue valueWithCGRect:CGRectMake(752, 408, 106, 270)],
                                              [NSValue valueWithCGRect:CGRectMake(180, 114, 260, 80)],
                                              [NSValue valueWithCGRect:CGRectMake(495, 114, 260, 80)],
                                              [NSValue valueWithCGRect:CGRectMake(321, 290, 310, 220)]
                                             ] arrayByAddingObjectsFromArray:walls] mutableCopy];
            
            
            NSMutableArray *turretLocs = [@[
                                          @[[NSValue valueWithCGPoint:CGPointMake(238, 200)]],
                                          @[[NSValue valueWithCGPoint:CGPointMake(517, 198)]],
                                          @[[NSValue valueWithCGPoint:CGPointMake(238, 392)]],
                                          @[[NSValue valueWithCGPoint:CGPointMake(517, 392)]]
                                          ] mutableCopy];
            
            
            NSArray *weapons = @[@1,@30,@5,@2];
            
            controller = [[GTGameViewController alloc] initWithPeople:400 blockingRects:blockingRects turrets:turretLocs goal:300 weapons:weapons];
            break;
            
        }
            
        case 2: {
            
            NSMutableArray *blockingRects = [[
                                                @[[NSValue valueWithCGRect:CGRectMake(0, 0, 250, 250)],
                                                [NSValue valueWithCGRect:CGRectMake(0, 518, 250, 250)],
                                                [NSValue valueWithCGRect:CGRectMake(694, 0, 250, 250)],
                                                [NSValue valueWithCGRect:CGRectMake(694, 518, 250, 250)],
                                                [NSValue valueWithCGRect:CGRectMake(402, 75, 140, 618)]
                                              ] arrayByAddingObjectsFromArray:walls] mutableCopy];
            
            
            NSMutableArray *turretLocs = [@[
                                          
                                          @[[NSValue valueWithCGPoint:CGPointMake(140, 140)]],
                                          @[[NSValue valueWithCGPoint:CGPointMake(140, 428)]],
                                          @[[NSValue valueWithCGPoint:CGPointMake(604, 140)]],
                                          @[[NSValue valueWithCGPoint:CGPointMake(604, 428)]],
                                          @[
                                            [NSValue valueWithCGPoint:CGPointMake(312, -15)],
                                            [NSValue valueWithCGPoint:CGPointMake(312, 583)]
                                          ],
                                          @[
                                          [NSValue valueWithCGPoint:CGPointMake(432, 583)],
                                          [NSValue valueWithCGPoint:CGPointMake(432, -15)]
                                          ],
                                          
                                          ] mutableCopy];
            
            NSArray *weapons = @[@1,@30,@5,@2];
            
            controller = [[GTGameViewController alloc] initWithPeople:400 blockingRects:blockingRects turrets:turretLocs goal:250 weapons:weapons];
            
            break;
        }
            
        case 3: {
            
            NSMutableArray *blockingRects = [[
                                                @[[NSValue valueWithCGRect:CGRectMake(412, 168, 120, 600)],
                                                [NSValue valueWithCGRect:CGRectMake(146, 0, 120, 600)],
                                                [NSValue valueWithCGRect:CGRectMake(678, 0, 120, 600)],
                                              ] arrayByAddingObjectsFromArray:walls] mutableCopy];
            
            
            NSMutableArray *turretLocs = [@[
                                          
                                          @[
                                          [NSValue valueWithCGPoint:CGPointMake(322, 78)],
                                          [NSValue valueWithCGPoint:CGPointMake(322, 648)]
                                          ],
                                          @[
                                          [NSValue valueWithCGPoint:CGPointMake(422, 648)],
                                          [NSValue valueWithCGPoint:CGPointMake(422, 78)]
                                          ],
                                          @[
                                          [NSValue valueWithCGPoint:CGPointMake(156, -90)],
                                          [NSValue valueWithCGPoint:CGPointMake(156, 490)]
                                          ],
                                          @[
                                          [NSValue valueWithCGPoint:CGPointMake(56, 490)],
                                          [NSValue valueWithCGPoint:CGPointMake(56, -90)]
                                          ],
                                          @[
                                          [NSValue valueWithCGPoint:CGPointMake(588, 490)],
                                          [NSValue valueWithCGPoint:CGPointMake(588, -90)]
                                          ],
                                          @[
                                          [NSValue valueWithCGPoint:CGPointMake(688, -90)],
                                          [NSValue valueWithCGPoint:CGPointMake(688, 490)]
                                          ],
                                          
                                          ] mutableCopy];
            
            NSArray *weapons = @[@1,@30,@3,@5];
            
            controller = [[GTGameViewController alloc] initWithPeople:200 blockingRects:blockingRects turrets:turretLocs goal:170 weapons:weapons];
            
            break;
        }
            
        default:
            break;
    }
    
    return controller;
}


+ (NSInteger)numberOfLevels {
    return 3;
}

@end
