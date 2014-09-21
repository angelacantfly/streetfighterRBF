//
//  MainViewControllerDelegate.h
//  streetfighter
//
//  Created by Sasha Heinen on 9/20/14.
//  Copyright (c) 2014 hackthenorth. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MainViewControllerDelegate <NSObject>

-(void)beginGameWithCompletion:(void (^)(void))callbackBlock;

@end
