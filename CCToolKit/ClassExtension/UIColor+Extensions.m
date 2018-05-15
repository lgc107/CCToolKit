//
//  UIColor+Extensions.m
//  CCToolKit
//
//  Created by Harry_L on 2018/5/14.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import "UIColor+Extensions.h"

@implementation UIColor (Init)

#pragma mark - Init

+ (UIColor *)colorWithHexString:(NSString *)hexString{
    return [self colorWithHexString:hexString alpha:1.0];
}

+ (UIColor *)colorWithHexNumber:(int)hexNumber{
    return [self colorWithHexNumber:hexNumber];
}

+ (UIColor *)colorWithHex:(int)hexNumber alpha:(CGFloat)alpha{
    
    if (hexNumber > 0xFFFFFF) return nil;
    
    CGFloat red = ((hexNumber & 0xFF0000) >> 16) / 255.0;
    
    CGFloat green = ((hexNumber & 0x00FF00) >> 8) / 255.0;
    CGFloat blue  = (hexNumber & 0x0000FF) / 255.0;
    
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
    return color;
    
}

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha{
    
    NSString *hexStringTemp = nil;
    
    hexStringTemp = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    UIColor *defaultColor = [UIColor clearColor];
    
    if (hexStringTemp.length < 6) return defaultColor;
    if ([hexStringTemp hasPrefix:@"#"]) hexStringTemp = [hexStringTemp substringFromIndex:1];
    if ([hexStringTemp hasPrefix:@"0X"]) hexStringTemp = [hexStringTemp substringFromIndex:2];
    if (hexStringTemp.length != 6) return defaultColor;
    
    //method1
    NSScanner *scanner = [NSScanner scannerWithString:hexStringTemp];
    unsigned int hexNumber;
    if (![scanner scanHexInt:&hexNumber]) return defaultColor;
    
    
    
    return [self colorWithHex:hexNumber alpha:alpha];
}




@end
