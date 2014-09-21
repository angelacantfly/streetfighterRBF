//
//  IntroHUD.m
//  streetfighter
//
//  Created by Sasha Heinen on 9/20/14.
//  Copyright (c) 2014 hackthenorth. All rights reserved.
//

#import "IntroHUD.h"
#import <CoreGraphics/CoreGraphics.h>
#import "UIColor+SFColors.h"

@implementation IntroHUD

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor SFyellow];
        [self setAlpha:.7];
        [self.opponentsButton setTitleColor:[UIColor SForangeRed] forState:UIControlStateNormal];
    }
    
    return self;
}

-(void)runAnimations
{
    [UIView animateWithDuration:.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.streetConstraint setConstant:50];
        [self setNeedsUpdateConstraints];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.fighterConstraint setConstant:92];
            [self setNeedsUpdateConstraints];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }];
}

-(void)opponentsButtonPressed:(id)sender
{
    UIActivityIndicatorView *spinningHUD = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    spinningHUD.center = self.opponentsButton.center;
    [spinningHUD startAnimating];
    [self addSubview:spinningHUD];
    
    self.opponentsButton.userInteractionEnabled = NO;
    self.opponentsButton.alpha = 0.0;
    [self layoutIfNeeded];
    [self.delegate startRunningGame];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
