//
//  IntroHUD.h
//  streetfighter
//
//  Created by Sasha Heinen on 9/20/14.
//  Copyright (c) 2014 hackthenorth. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IntroHUDDelegate

-(void)startRunningGame;

@end

@interface IntroHUD : UIView

@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UILabel *fighterLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *streetConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fighterConstraint;

@property (weak, nonatomic) id<IntroHUDDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *opponentsButton;

-(IBAction)opponentsButtonPressed:(id)sender;
-(void)runAnimations;

@end
