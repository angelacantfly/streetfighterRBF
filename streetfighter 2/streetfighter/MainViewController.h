//
//  ViewController.h
//  streetfighter
//
//  Created by Sasha Heinen on 9/20/14.
//  Copyright (c) 2014 hackthenorth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewControllerDelegate.h"

@interface MainViewController : UIViewController

@property (nonatomic, weak) id<MainViewControllerDelegate> delegate;
@property (nonatomic, strong) UIView *introHudContainerView;

-(void)broadcastError:(NSString *)error;
-(void)displayUserDamage:(int)damage;
-(void)displayOpponentDamage:(int)damage;

@end
