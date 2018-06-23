//
//  NSNumber+Extensions.h
//  CCToolKit
//
//  Created by Harry_L on 2018/6/17.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Provide a method to parse `NSString` for `NSNumber`.
 */
@interface NSNumber (Extensions)

/**
 Creates and returns an NSNumber object from a string.
 Valid format: @"12", @"12.345", @" -0xFF", @" .23e99 "...
 
 @param string  The string described an number.
 
 @return an NSNumber when parse succeed, or nil if an error occurs.
 */
+ (nullable NSNumber *)cc_numberWithString:(NSString *)string;

- (NSString *)cc_StringValue;
@end
