//
//  MenuViewController.m
//  villian
//
//  Created by John Detloff on 12/16/12.
//  Copyright (c) 2012 Groucho. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "StoreView.h"

@interface MenuViewController ()
@end

@implementation MenuViewController {
    UIView *_instructionsView;
    StoreView *_storeView;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 1024, 60)];
    titleLabel.text = @"Patient Zero";
    titleLabel.font = [UIFont systemFontOfSize:60];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UIButton *newGame = [[UIButton alloc] initWithFrame:CGRectMake(312, 210, 400, 90)];
    [newGame setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [newGame setTitle:@"New Game" forState:UIControlStateNormal];
    newGame.layer.borderColor = [[UIColor blackColor] CGColor];
    newGame.layer.borderWidth = 5.0;
    [newGame addTarget:self action:@selector(newGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newGame];
    
    UIButton *load = [[UIButton alloc] initWithFrame:CGRectMake(312, 330, 400, 90)];
    [load setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [load setTitle:@"Load" forState:UIControlStateNormal];
    load.layer.borderColor = [[UIColor blackColor] CGColor];
    load.layer.borderWidth = 5.0;
    [load addTarget:self action:@selector(load) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:load];
    
    UIButton *instructionsButton = [[UIButton alloc] initWithFrame:CGRectMake(312, 450, 400, 90)];
    [instructionsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [instructionsButton setTitle:@"Instructions" forState:UIControlStateNormal];
    instructionsButton.layer.borderColor = [[UIColor blackColor] CGColor];
    instructionsButton.layer.borderWidth = 5.0;
    [instructionsButton addTarget:self action:@selector(instructions) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:instructionsButton];
    
    UIButton *storeButton = [[UIButton alloc] initWithFrame:CGRectMake(312, 570, 400, 90)];
    [storeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [storeButton setTitle:@"Store" forState:UIControlStateNormal];
    storeButton.layer.borderColor = [[UIColor blackColor] CGColor];
    storeButton.layer.borderWidth = 5.0;
    [storeButton addTarget:self action:@selector(store) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:storeButton];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if (_instructionsView && _instructionsView.tag != 5) {
        if (!CGRectContainsPoint([_instructionsView bounds], [touch locationInView:_instructionsView])) {
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            _instructionsView.frame = CGRectMake(264, 768, 500, 530);
            _instructionsView.tag = 5;
            [UIView commitAnimations];
            
            int64_t delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [_instructionsView removeFromSuperview];
                _instructionsView = nil;
            });
        }
    }
    
    if (_storeView && _storeView.tag != 5) {
        if (!CGRectContainsPoint([_storeView bounds], [touch locationInView:_storeView])) {
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            _storeView.frame = CGRectMake(264, 768, 500, 530);
            _storeView.tag = 5;
            [UIView commitAnimations];
            
            int64_t delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [_storeView removeFromSuperview];
                _storeView = nil;
            });
        }
    }

}


- (void)newGame {
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) displayGameForLevel:1];
}


- (void)load {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int level = [defaults integerForKey:@"saved_level"];
    
    if (level == 0 || level == NSNotFound) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Saved Game" message:@"You don't have a save game!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) displayGameForLevel:level];
}


- (void)instructions {
    if (_instructionsView) return;
    
    CGRect startFrame = CGRectMake(264, 768, 500, 530);
    CGRect endFrame = CGRectMake(264, 100, 500, 530);
    
    _instructionsView = [[UIView alloc] initWithFrame:startFrame];
    _instructionsView.backgroundColor = [UIColor whiteColor];
    _instructionsView.layer.borderColor = [[UIColor blackColor] CGColor];
    _instructionsView.layer.borderWidth = 3.0;
    [self.view addSubview:_instructionsView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    _instructionsView.frame = endFrame;
    [UIView commitAnimations];
    
    UILabel *instructionsTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, endFrame.size.width, 20)];
    instructionsTitle.textAlignment = NSTextAlignmentCenter;
    instructionsTitle.font = [UIFont boldSystemFontOfSize:18];
    instructionsTitle.text = @"Instructions";
    [_instructionsView addSubview:instructionsTitle];
    
    UILabel *instructionsText = [[UILabel alloc] initWithFrame:CGRectMake(30, 70, endFrame.size.width-60, 360)];
    instructionsText.textAlignment = NSTextAlignmentCenter;
    instructionsText.text = @"You are Patient Zero! \n\n Select from your tools of destruction on the right panel. The green button allows you to drop an infectious zombie goat on tap. The red button creates a radius of pure fear that will make the citizens of town flee in terror. The gray button creates a smoke screen that prevents those pesky guards from targetting your zombie horde. Lastly, the blue button turns your zombies into terrifying speed demon running zombies. Control the direction your horde shambles by swiping over them, but beware zombies have a short attention span and will resume their hunting and wandering after a short period. \n\n The goal is to zombify or kill every single human in the town. Seriouly though, just reach the goal and you'll be fine, there's a bit of wiggle room here.";
    instructionsText.numberOfLines = 120;
    [_instructionsView addSubview:instructionsText];
}


- (void)store {
    if (_storeView) return;
    
    CGRect startFrame = CGRectMake(264, 768, 500, 370);
    CGRect endFrame = CGRectMake(264, 230, 500, 370);
    
    _storeView = [[StoreView alloc] initWithFrame:startFrame];
    _storeView.backgroundColor = [UIColor whiteColor];
    _storeView.layer.borderColor = [[UIColor blackColor] CGColor];
    _storeView.layer.borderWidth = 3.0;
    [self.view addSubview:_storeView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    _storeView.frame = endFrame;
    [UIView commitAnimations];
}


@end
