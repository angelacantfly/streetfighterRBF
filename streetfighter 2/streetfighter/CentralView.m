//
//  CentralView.m
//  streetfighter
//
//  Created by Sasha Heinen on 9/20/14.
//  Copyright (c) 2014 hackthenorth. All rights reserved.
//

#import "CentralView.h"

typedef NS_ENUM(NSInteger, Player) {
    user,
    opponent
};

@implementation CentralView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self _setUpBackground];
        [self _setUpImages];
        
        self.originalHealthHeight = self.userHealthBar.bounds.size.height;
    }
    
    return self;
}

-(void)beginGameWithLife:(int)life
{
    self.life = life;
}

-(void)_setUpBackground
{
    [self setBackgroundColor:[UIColor clearColor]];
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map"]];
    [background setContentMode:UIViewContentModeScaleAspectFill];
    [background setBounds:self.frame];
    [background setAlpha:.5];
    [self addSubview:background];
    [self sendSubviewToBack:background];
}

-(void)_setUpImages
{
    UIImageView *punchImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"punchIcon"]];
    UIImageView *magicImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"magicIcon"]];
    UIImageView *shieldImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shieldIcon"]];
    
    for (UIImageView *imageView in @[punchImage, magicImage, shieldImage]) {
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setAlpha:1.0f];
        [imageView setBounds:self.shieldBox.bounds];
    }
    
    [self.punchBox addSubview:punchImage];
    [self.punchBox bringSubviewToFront:punchImage];
    [self.magicBox addSubview:magicImage];
    [self.magicBox bringSubviewToFront:magicImage];
    [self.shieldBox addSubview:shieldImage];
    [self.shieldBox bringSubviewToFront:shieldImage];
}

-(int)_newHealthHeight:(int) damage
{
    return self.originalHealthHeight*( damage / self.life );
}

-(void)takeUserDamage:(int)damage
{
    self.userDamageTaken += damage;
    [self _reduceDamageToHeight:[self _newHealthHeight:damage] forUser:user];
}

-(void)takeOpponentDamage:(int)damage
{
    self.opponentDamageTaken += damage;
    [self _reduceDamageToHeight:[self _newHealthHeight:damage] forUser:opponent];
}

-(void)_reduceDamageToHeight:(int)newHeight forUser:(Player)player
{
    if (player == user) {
        [UIView animateWithDuration:.4 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.userHealthBar setBackgroundColor:[UIColor redColor]];
            [self.userHealthBarHeight setConstant:newHeight];
        } completion:^(BOOL finished) {
            if (((float)newHeight) / ((float)self.originalHealthHeight) > .2) {
                [self.userHealthBar setBackgroundColor:[UIColor greenColor]];
            }
        }];
    } else if (player == opponent) {
        [UIView animateWithDuration:.4 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.opponentHealthBar setBackgroundColor:[UIColor whiteColor]];
            [self.opponentHealthBarHeight setConstant:newHeight];
        } completion:^(BOOL finished) {
            if (((float)newHeight) / ((float)self.originalHealthHeight) > .2) {
                [self.opponentHealthBar setBackgroundColor:[UIColor greenColor]];
            } else {
                [self.opponentHealthBar setBackgroundColor:[UIColor redColor]];
            }
        }];
    }
        
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
