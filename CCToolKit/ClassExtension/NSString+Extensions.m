//
//  NSString+Extensions.m
//  CCToolKit
//
//  Created by Harry_L on 2017/5/18.
//  Copyright © 2017年 Harry_L. All rights reserved.
//


#import "NSString+Extensions.h"
#import "NSData+Extensions.h"


@implementation NSString (decoding)

- (NSData *)cc_dataUsingHexEncoding
{
    if (!self || [self length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [NSMutableData data];
    NSRange range;
    if ([self length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [self length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [self substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}


@end


@implementation NSString (Digest)

+ (NSString *)UUID{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidString;
}




@end



@implementation NSString (Symmetric_Encryption_AES)
#pragma mark --AES_CBC_Padding7


@end

