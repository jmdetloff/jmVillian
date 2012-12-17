//
//  LevelGenerator.h
//  villian
//
//  Created by John Detloff on 12/17/12.
//  Copyright (c) 2012 Groucho. All rights reserved.
//

#import "GTGameViewController.h"
#import <Foundation/Foundation.h>

@interface LevelGenerator : NSObject


+ (NSInteger)numberOfLevels;
+ (GTGameViewController *)controllerForLevel:(NSInteger)levelNum;


@end
