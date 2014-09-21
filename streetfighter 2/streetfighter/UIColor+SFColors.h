//
//  UIColor+SFColors.h
//  streetfighter
//
//  Created by Sasha Heinen on 9/20/14.
//  Copyright (c) 2014 hackthenorth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SFColors)

+(UIColor *)SForangeRed;
+(UIColor *)SFyellow;

@end

@implementation UIColor (SFColors)

+(UIColor *)SForangeRed { return [UIColor colorWithRed:(252.0/355.0) green:(15.0/355.0) blue:(21.0/355.0) alpha:1.0f]; }
+(UIColor *)SFyellow { return [UIColor colorWithRed:(255.0/355.0) green:(157.0/355.0) blue:(3.0/355.0) alpha:1.0f]; }

@end