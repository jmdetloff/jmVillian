//
//  ToolPanel.h
//  villian
//
//  Created by John Detloff on 12/15/12.
//  Copyright (c) 2012 Groucho. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ZombieTool,
    FearTool,
    DistractionTool,
    SpeedTool
} ToolSelection;


@protocol TimesUpDelegate <NSObject>
- (void)timesUp;
- (void)win;
- (void)outOfZoms;
@end


@interface ToolPanel : UIView
@property (nonatomic, assign) ToolSelection selectedTool;
@property (nonatomic, weak) id <TimesUpDelegate> delegate;
@property (nonatomic, assign) NSInteger killCount;
@property (nonatomic, assign) NSInteger zomCount;
@property (nonatomic, assign) NSInteger numberOfZomAttacks;
@property (nonatomic, assign) NSInteger numberOfFearAttacks;
@property (nonatomic, assign) NSInteger numberOfDistractionAttacks;
@property (nonatomic, assign) NSInteger numberOfSpeedAttacks;
@property (nonatomic, assign) NSTimeInterval timeRemaining;
@property (nonatomic, assign) NSInteger goal;

- (void)invalidate;
@end
