//
//  GameState.m
//  streetfighter
//
//  Created by Sasha Heinen on 9/20/14.
//  Copyright (c) 2014 hackthenorth. All rights reserved.
//

#import "GameState.h"

@implementation GameState

static GameState *instance = nil;

-(id)initWithLife:(int)life
{
    self = [super init];
    if (self) {
        self.life = life;
        self.damageDealt = 0;
    }
    
    return self;
}

+(GameState *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [GameState new];
        }
    }
    return instance;
}

@end
