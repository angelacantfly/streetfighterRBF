//
//  CentralView.h
//  streetfighter
//
//  Created by Sasha Heinen on 9/20/14.
//  Copyright (c) 2014 hackthenorth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CentralView : UIView

@property (weak, nonatomic) IBOutlet UIView *userHealthBar;
@property (weak, nonatomic) IBOutlet UIView *opponentHealthBar;
@property (weak, nonatomic) IBOutlet UIView *punchBox;
@property (weak, nonatomic) IBOutlet UIView *magicBox;
@property (weak, nonatomic) IBOutlet UIView *shieldBox;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userHealthBarHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *opponentHealthBarHeight;

@property (nonatomic) int originalHealthHeight;
@property (nonatomic) int life;
@property (nonatomic) int userDamageTaken;
@property (nonatomic) int opponentDamageTaken;

-(void)beginGameWithLife:(int)life;
-(void)takeUserDamage:(int)damage;
-(void)takeOpponentDamage:(int)damage;

@end
