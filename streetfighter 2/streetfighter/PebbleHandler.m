//
//  PebbleHandler.m
//  streetfighter
//
//  Created by Sasha Heinen on 9/20/14.
//  Copyright (c) 2014 hackthenorth. All rights reserved.
//

#import "PebbleHandler.h"

@interface PebbleHandler()

@property (nonatomic, strong) PBWatch *watch;

@end

@implementation PebbleHandler

-(id)initWithLife:(NSNumber *)life
{
    self = [super init];
    if (self) {
        [[PBPebbleCentral defaultCentral] setDelegate:self];
        
    }
    
    return self;
}

-(void)takeDamage:(NSNumber *)damage
{
    
}

-(void)blockedMove
{
    
}

-(void)connectWithCompletion:(void (^)(void))callbackBlock
{
    callbackBlock();
}

#pragma mark PBPebbleCentral delegate methods

-(void)pebbleCentral:(PBPebbleCentral *)central watchDidConnect:(PBWatch *)watch isNew:(BOOL)isNew
{
    
    NSLog(@"Pebble %@ connected",watch.name);
    if (isNew) {
        
    }
}

@end
