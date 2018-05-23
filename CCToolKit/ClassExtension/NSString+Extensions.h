//
//  NSString+Extensions.h
//  CCToolKit
//
//  Created by Harry_L on 2017/5/18.
//  Copyright © 2017年 Harry_L. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    CCEncrpytBase64StringEncoding,
    CCEncrpytHexStringEncoding
}CCEncrpytEncodingOptions;

typedef enum : NSUInteger {
    CCDecrpytBase64StringDecoding,
    CCDecrpytHexStringDecoding
}CCDecrpytEncodingOptions;


@interface NSString (decoding)

- (NSData *)cc_dataUsingHexEncoding;

@end


@interface NSString (Digest)

@end


@interface NSString (Symmetric_Encryption_AES)



@end
