//
//  TurretView.h
//  villian
//
//  Created by John Detloff on 12/15/12.
//  Copyright (c) 2012 Groucho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TurretView : UIView

@property (nonatomic, retain) NSArray *locations;

- (BOOL)fireOrLoad;
- (void)load;
- (void)moveToLocation;

@end
