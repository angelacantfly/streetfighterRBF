//
//  ViewController.m
//  streetfighter
//
//  Created by Sasha Heinen on 9/20/14.
//  Copyright (c) 2014 hackthenorth. All rights reserved.
//

#import "MainViewController.h"
#import "IntroHUD.h"
#import "CentralView.h"

@interface MainViewController () <IntroHUDDelegate>
@property IntroHUD *iHud;
@property CentralView *main;
@end

@implementation MainViewController

-(id)init
{
    self = [super init];
    if (self) {
        self.main = [[[NSBundle mainBundle] loadNibNamed:@"CentralView" owner:self options:nil] objectAtIndex:0];
        [self.view addSubview:self.main];
        
        self.iHud = (IntroHUD *)[[[NSBundle mainBundle] loadNibNamed:@"IntroHUD" owner:self options:nil] objectAtIndex:0];
        self.iHud.delegate = self;
        int w = self.iHud.bounds.size.width;
        int h = self.iHud.bounds.size.height;
        int x = (self.view.bounds.size.width - w)/2;
        int y = (self.view.bounds.size.height - h)/2;
        self.introHudContainerView = [[UIView alloc] initWithFrame:CGRectMake(x, -4*y, w, h)];
        
        [self.view addSubview:self.introHudContainerView];
        
        [self animateIn];
    }
    
    return self;
}

-(void)animateIn
{
    [self.introHudContainerView addSubview:self.iHud];
    
    int newY = (self.view.bounds.size.height - self.introHudContainerView.bounds.size.height)/2 + 20;
    CGRect oldFrame = self.introHudContainerView.frame;
    
    [UIView animateWithDuration:.4 delay:.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.main setAlpha:.3f];
        self.introHudContainerView.frame = CGRectMake(oldFrame.origin.x, newY, oldFrame.size.width, oldFrame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1 delay:0 options:(UIViewAnimationOptionCurveEaseOut)animations:^{
            int newY = (self.view.bounds.size.height - self.introHudContainerView.bounds.size.height)/2 - 20;
            CGRect oldFrame = self.introHudContainerView.frame;
            self.introHudContainerView.frame = CGRectMake(oldFrame.origin.x, newY, oldFrame.size.width, oldFrame.size.height);
        } completion:^(BOOL finished) {
            [self.iHud runAnimations];
        }];
    }];
}

-(void)displayUserDamage:(int)damage
{
    [self.main takeUserDamage:damage];
}

-(void)displayOpponentDamage:(int)damage
{
    [self.main takeOpponentDamage:damage];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark Coordinator delegate method

-(void)broadcastError:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hardware Problems!" message:error delegate:self cancelButtonTitle:@"OK!" otherButtonTitles:nil];
    
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IntroHUD delegate method

-(void)startRunningGame
{
    [self.delegate beginGameWithCompletion:^{
        CGRect oldFrame = self.introHudContainerView.frame;
        [UIView animateWithDuration:.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.introHudContainerView.frame = CGRectMake(oldFrame.origin.x, -500, oldFrame.size.width, oldFrame.size.height);
            [self.main setAlpha:1.0f];
        } completion:^(BOOL finished) {
            [self.introHudContainerView removeFromSuperview];
        }];
    }];
}

@end
