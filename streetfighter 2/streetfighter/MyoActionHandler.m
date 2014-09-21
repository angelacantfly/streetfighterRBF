//
//  MyoActionHandler.m
//  streetfighter
//
//  Created by Sasha Heinen on 9/20/14.
//  Copyright (c) 2014 hackthenorth. All rights reserved.
//
#import "FightMove.h"
#import "MyoActionHandler.h"
#import <MyoKit/MyoKit.h>


@interface MyoActionHandler () <MyoViewControllerDelegate>

    @property (strong, atomic) MyoViewController* myoSignalFlow;

@end

@implementation MyoActionHandler

-(id)init
{
    self = [super init];
    if (self) {
        self.myoSignalFlow = [[MyoViewController alloc] init];
        self.myoSignalFlow.delegate = self;

    }
    
    return self;
}

-(void)_instantiateNotificationListeners
{
    
}

-(void) initiateFightMove:(ValidMyoGesture)move withDamage: (NSInteger) damage
{
    FightMove *punch;
    FightMove *magic;
    FightMove *block;
    switch (move)
    {
        case FIST_GESTURE:
            NSLog(@"In MyoActionHandler, handling fist gesture.");
            punch = [[FightMove alloc] initWithGesture:FIST_GESTURE andWithDamage:(NSInteger)1];
            break;
        case PALM_GESTURE:
            NSLog(@"In MyoActionHandler, handling palm gesture.");
            magic = [[FightMove alloc] initWithGesture:PALM_GESTURE andWithDamage:(NSInteger) 1];
            break;
        case BLOCK_GESTURE:
            NSLog(@"In MyoActionHandler, handling palm gesture.");
            block = [[FightMove alloc] initWithGesture:BLOCK_GESTURE andWithDamage:(NSInteger) 0];
            break;
            
        default:
            break;
    }
}

-(void)simulateAttack
{
    FightMove *punchMove = [[FightMove alloc] initWithGesture:FIST_GESTURE andWithDamage:2];
    
    [self.delegate broadcastFightMove:punchMove];
}

-(void) updateMyoStatus: (MyoStatus) newStatus
{
    switch (newStatus) {
        case CONNECT_STATE:
            NSLog(@"Myo is connected!");
            [self.delegate myoDidConnect];
            break;
            
        case DISCONNECT_STATE:
            NSLog(@"Myo has disconnected!");
            break;
            
        case SYNC_GESTURE:
            NSLog(@"Myo is synchronized!");
            break;
            
        case RECALIBRATE_REQUIRED_STATE:
            NSLog(@"Myo recalibration is required!");
            break;
            
            
        default:
            break;
    }

}


@end
