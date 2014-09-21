//
//  MyoActionHandler.h
//  streetfighter
//
//  Created by Sasha Heinen on 9/20/14.
//  Copyright (c) 2014 hackthenorth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FightMove.h"
#import "MyoViewController.h"

@protocol MyoActionHandlerDelegate <NSObject>

-(void)broadcastFightMove:(FightMove *)move;
-(void)myoDidConnect;
-(void)handleMyoError:(NSString *)description;

@end

@interface MyoActionHandler : NSObject

@property (nonatomic, weak) id<MyoActionHandlerDelegate> delegate;

-(void)simulateAttack;

@end
