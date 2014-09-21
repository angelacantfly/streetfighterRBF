//
//  GameState.h
//  streetfighter
//
//  Created by Sasha Heinen on 9/20/14.
//  Copyright (c) 2014 hackthenorth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameState : NSObject

-(id)initWithLife:(int)life;

@property int *life;
@property int *damageDealt;
@property int lastDamageDealt;
@property BOOL isBlocking;

+(GameState *)getInstance;

@end
