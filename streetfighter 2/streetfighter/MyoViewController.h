//
//  MyoViewController.h
//  streetfighter
//
//  Created by Angela Zhou on 9/20/14.
//  Copyright (c) 2014 hackthenorth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyoActionHandler.h"
#import "FightMove.h"

@protocol MyoViewControllerDelegate <NSObject>


-(void) initiateFightMove:(ValidMyoGesture)move withDamage: (NSInteger) damage;
-(void) updateMyoStatus: (MyoStatus) newStatus;

@end

@interface MyoViewController : UIViewController

@property (nonatomic, weak) id<MyoViewControllerDelegate> delegate;

@end
