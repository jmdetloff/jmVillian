//
//  GTGameViewController.h
//  villian
//
//  Created by John Detloff on 12/14/12.
//  Copyright (c) 2012 Groucho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTGameViewController : UIViewController

- (id)initWithPeople:(NSUInteger)people blockingRects:(NSMutableArray *)blockingRects turrets:(NSMutableArray *)turrets goal:(NSInteger)goal weapons:(NSArray*)weapons;
- (void)invalidate;

@end
