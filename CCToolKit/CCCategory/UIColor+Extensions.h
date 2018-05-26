//
//  UIColor+Extensions.h
//  CCToolKit
//
//  Created by Harry_L on 2017/5/14.
//  Copyright © 2017年 Harry_L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Init)


/**
   Create and return the specified color with a hexadecimal number
 */
+ (UIColor *)colorWithHexNumber:(int)hexNumber;
/**
 Create and return the specified color with a hexadecimal String.
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;
/**
  Create and return the specified color with a hexadecimal number and alpha.
 */
+ (UIColor *)colorWithHex:(int)hexNumber alpha:(CGFloat)alpha;
/**
 Create and return the specified color with a hexadecimal String and alpha.
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;



@end
