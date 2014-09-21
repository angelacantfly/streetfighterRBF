//
//  FightMove.m
//  streetfighter
//
//  Created by Sasha Heinen on 9/20/14.
//  Copyright (c) 2014 hackthenorth. All rights reserved.
//

#import "FightMove.h"

@implementation FightMove



- (id) initWithGesture: (ValidMyoGesture) gesture andWithDamage: (NSInteger) damage
{
    self = [super init];
    self.damage = damage;
    self.movement = gesture;
    return self;
}

@end
