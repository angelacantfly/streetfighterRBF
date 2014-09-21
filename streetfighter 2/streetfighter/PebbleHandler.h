//
//  PebbleHandler.h
//  streetfighter
//
//  Created by Sasha Heinen on 9/20/14.
//  Copyright (c) 2014 hackthenorth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PebbleKit/PebbleKit.h>

@protocol PebbleHandlerDelegate <NSObject>

-(void)handlePebbleError:(NSString *)description;

@end

@interface PebbleHandler : NSObject <PBPebbleCentralDelegate>

-(id)initWithLife:(NSNumber *)life;

@property (nonatomic, weak) id<PebbleHandlerDelegate> delegate;

-(void)connectWithCompletion:(void (^)(void))callbackBlock;
-(void)takeDamage:(NSNumber *)damage;
-(void)blockedMove;

@end
