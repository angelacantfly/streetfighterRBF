//
//  FightMove.h
//  streetfighter
//
//  Created by Sasha Heinen on 9/20/14.
//  Copyright (c) 2014 hackthenorth. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, ValidMyoGesture) {
    FIST_GESTURE,
    PALM_GESTURE,
    BLOCK_GESTURE,
};

typedef NS_ENUM(NSInteger, MyoStatus) {
    CONNECT_STATE,
    DISCONNECT_STATE,
    SYNC_GESTURE,
    RECALIBRATE_REQUIRED_STATE,
    REST_GESTURE,
};


@interface FightMove : NSObject


- (id) init;
- (id) initWithGesture: (ValidMyoGesture) gesture andWithDamage: (NSInteger *) damage;

@property (nonatomic) ValidMyoGesture movement;
@property (nonatomic) NSInteger damage;

@end
