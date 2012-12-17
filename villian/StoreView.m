//
//  StoreView.m
//  villian
//
//  Created by John Detloff on 12/17/12.
//  Copyright (c) 2012 Groucho. All rights reserved.
//

#import "StoreView.h"
#import <QuartzCore/QuartzCore.h>

@implementation StoreView {
    UIButton *_zomButton;
    UIButton *_fearButton;
    UIButton *_distractButton;
    UIButton *_speedButton;
    UILabel *_zomLabel;
    UILabel *_fearLabel;
    UILabel *_distractLabel;
    UILabel *_speedLabel;
    UILabel *_instructionsTitle;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _instructionsTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 17, self.frame.size.width, 20)];
        _instructionsTitle.textAlignment = NSTextAlignmentCenter;
        _instructionsTitle.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:_instructionsTitle];
        
        _zomButton = [[UIButton alloc] initWithFrame:CGRectMake(35, 50, 55, 55)];
        [_zomButton setTitle:@"1" forState:UIControlStateNormal];
        [_zomButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _zomButton.backgroundColor = [UIColor greenColor];
        [_zomButton addTarget:self action:@selector(selectZom) forControlEvents:UIControlEventTouchUpInside];
        _zomButton.layer.borderColor = [[UIColor blackColor] CGColor];
        [self addSubview:_zomButton];
        
        CGFloat labelWidth = self.frame.size.width - 115 - 20;
        
        _zomLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 55, labelWidth, 40)];
        _zomLabel.numberOfLines = 3;
        [self addSubview:_zomLabel];
        
        _fearButton = [[UIButton alloc] initWithFrame:CGRectMake(35, 130, 55, 55)];
        [_fearButton setTitle:@"5" forState:UIControlStateNormal];
        _fearButton.backgroundColor = [UIColor redColor];
        [_fearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_fearButton addTarget:self action:@selector(selectFear) forControlEvents:UIControlEventTouchUpInside];
        _fearButton.layer.borderColor = [[UIColor blackColor] CGColor];
        [self addSubview:_fearButton];
        
        _fearLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 135, labelWidth, 40)];
        _fearLabel.numberOfLines = 3;
        [self addSubview:_fearLabel];
        
        _distractButton = [[UIButton alloc] initWithFrame:CGRectMake(35, 210, 55, 55)];
        [_distractButton setTitle:@"1" forState:UIControlStateNormal];
        _distractButton.backgroundColor = [UIColor grayColor];
        [_distractButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_distractButton addTarget:self action:@selector(selectDistract) forControlEvents:UIControlEventTouchUpInside];
        _distractButton.layer.borderColor = [[UIColor blackColor] CGColor];
        [self addSubview:_distractButton];
        
        _distractLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 215, labelWidth, 40)];
        _distractLabel.numberOfLines = 3;
        [self addSubview:_distractLabel];
        
        _speedButton = [[UIButton alloc] initWithFrame:CGRectMake(35, 290, 55, 55)];
        [_speedButton setTitle:@"1" forState:UIControlStateNormal];
        _speedButton.backgroundColor = [UIColor blueColor];
        [_speedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_speedButton addTarget:self action:@selector(selectSpeed) forControlEvents:UIControlEventTouchUpInside];
        _speedButton.layer.borderColor = [[UIColor blackColor] CGColor];
        [self addSubview:_speedButton];
        
        _speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 295, labelWidth, 40)];
        _speedLabel.numberOfLines = 3;
        [self addSubview:_speedLabel];
        
        [self updateLabels];
    }
    return self;
}


- (void)updateLabels {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger zom = [defaults integerForKey:@"zom"];
    NSInteger coins = [defaults integerForKey:@"coins"];
    NSInteger fear = [defaults integerForKey:@"fear"];
    NSInteger distract = [defaults integerForKey:@"distract"];
    NSInteger speed = [defaults integerForKey:@"speed"];
    
    _instructionsTitle.text = [NSString stringWithFormat:@"Buy Tools of Destruction! Coins : %i", coins];
    
    _zomLabel.text = [NSString stringWithFormat:@"Place an extra zombie goat, to spread the virus even faster! Cost: 15 coins Currently have: %i",zom];
    _fearLabel.text = [NSString stringWithFormat:@"Strike fear into the hearts of the citizens of town! Cost: 3 Currently have: %i",fear];
    _distractLabel.text = [NSString stringWithFormat:@"Create a smoke screen to blind your enemies! Cost: 5 Currently have: %i", distract];
    _speedLabel.text = [NSString stringWithFormat:@"Amp up the horror with running zombies! Cost: 7 Currently have: %i", speed];
}


- (void)selectZom {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger coins = [defaults integerForKey:@"coins"];
    if (coins >= 15) {
        
        NSInteger zoms = [defaults integerForKey:@"zom"];
        zoms++;
        [defaults setInteger:zoms forKey:@"zom"];
        coins -= 15;
        [defaults setInteger:coins forKey:@"coins"];
        [defaults synchronize];
        
        [self updateLabels];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not enough coins!" message:@"You don't have enough coins to purchase that item." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}


- (void)selectFear {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger coins = [defaults integerForKey:@"coins"];
    if (coins >= 3) {
        
        NSInteger fear = [defaults integerForKey:@"fear"];
        fear += 5;
        [defaults setInteger:fear forKey:@"fear"];
        coins -= 3;
        [defaults setInteger:coins forKey:@"coins"];
        [defaults synchronize];
        
        [self updateLabels];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not enough coins!" message:@"You don't have enough coins to purchase that item." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}


- (void)selectDistract {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger coins = [defaults integerForKey:@"coins"];
    if (coins >= 5) {
        
        NSInteger distract = [defaults integerForKey:@"distract"];
        distract++;
        [defaults setInteger:distract forKey:@"distract"];
        coins -= 5;
        [defaults setInteger:coins forKey:@"coins"];
        [defaults synchronize];
        
        [self updateLabels];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not enough coins!" message:@"You don't have enough coins to purchase that item." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}


- (void)selectSpeed {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger coins = [defaults integerForKey:@"coins"];
    if (coins >= 7) {
        
        NSInteger speed = [defaults integerForKey:@"speed"];
        speed++;
        [defaults setInteger:speed forKey:@"speed"];
        coins -= 7;
        [defaults setInteger:coins forKey:@"coins"];
        [defaults synchronize];
        
        [self updateLabels];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not enough coins!" message:@"You don't have enough coins to purchase that item." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
