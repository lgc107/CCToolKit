//
//  NSString+Extensions.m
//  CCToolKit
//
//  Created by Harry_L on 2017/5/18.
//  Copyright © 2017年 Harry_L. All rights reserved.
//


#import "NSString+Extensions.h"



@implementation NSString (Utilities)

+ (NSString *)cc_uuidString{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidString;
}

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

- (NSData *)cc_dataUsingUTF8Encoding{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *)cc_dataUsingBase64Encoding{
    return [[NSData alloc]initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
}



- (NSRange)cc_rangeOfAll {
    return NSMakeRange(0, self.length);
}

@end


@implementation NSString (Digest)

- (NSString *)cc_md2String{
    return self.cc_dataUsingUTF8Encoding.cc_md2String;
}

- (NSString *)cc_md4String{
    return self.cc_dataUsingUTF8Encoding.cc_md4String;
}

- (NSString *)cc_md5String{
    return self.cc_dataUsingUTF8Encoding.cc_md5String;
}

- (NSString *)cc_sha1String{
    return self.cc_dataUsingUTF8Encoding.cc_sha1String;
}

- (NSString *)cc_sha224String{
    return self.cc_dataUsingUTF8Encoding.cc_sha224String;
}

- (NSString *)cc_sha256String{
    return self.cc_dataUsingUTF8Encoding.cc_sha256String;
}

- (NSString *)cc_sha384String{
    return self.cc_dataUsingUTF8Encoding.cc_sha384String;
}

- (NSString *)cc_sha512String{
    return self.cc_dataUsingUTF8Encoding.cc_sha512String;
}
@end


@implementation NSString (CommonHmac)

- (NSString *)cc_hmacMD5StringWith:(id)key{
    return [self.cc_dataUsingUTF8Encoding cc_hmacMD5StringWith:key];
}
- (NSString *)cc_hmacSHA1StringWith:(id)key{
    return [self.cc_dataUsingUTF8Encoding cc_hmacSHA1StringWith:key];
}
- (NSString *)cc_hmacSHA224StringWith:(id)key{
    return [self.cc_dataUsingUTF8Encoding cc_hmacSHA224StringWith:key];
}
- (NSString *)cc_hmacSHA256StringWith:(id)key{
    return [self.cc_dataUsingUTF8Encoding cc_hmacSHA256StringWith:key];
}
- (NSString *)cc_hmacSHA384StringWith:(id)key{
    return [self.cc_dataUsingUTF8Encoding cc_hmacSHA384StringWith:key];
}
- (NSString *)cc_hmacSHA512StringWith:(id)key{
    return [self.cc_dataUsingUTF8Encoding cc_hmacSHA512StringWith:key];
}

@end

@implementation NSString (CommonCryptor)

- (NSString *)cc_encryptAESUsingEncoding:(CCEncrpytEncodingOptions)encoding
                                     key:(id)key
                    InitializationVector:(id)iv
                                 Padding:(CcCryptorPadding)padding
                                    Mode:(CcCryptorMode)mode
                                   error:(NSError *__autoreleasing *)error
{
    NSData * aesEncryptData = [self.cc_dataUsingUTF8Encoding cc_encryptAESUsingkey:key InitializationVector:iv Padding:padding Mode:mode error:error];

    switch (encoding) {
        case CCEncrpytHexStringEncoding:
            return aesEncryptData.cc_hexEncodedString;
            break;
        case CCEncrpytBase64StringEncoding:
            return [aesEncryptData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        default:
            return aesEncryptData.cc_utf8EncodedString;
            break;
    }
}

- (NSString *)cc_decryptAESUsingEncoding:(CCDecrpytDecodingOptions)decoding
                                     key:(id)key
                    InitializationVector:(id)iv
                                 Padding:(CcCryptorPadding)padding
                                    Mode:(CcCryptorMode)mode
                                   error:(NSError *__autoreleasing *)error
{
    NSData *aesDecryptData = (decoding == CCDecrpytHexStringDecoding) ? self.cc_dataUsingHexEncoding : self.cc_dataUsingBase64Encoding;
    return  [aesDecryptData cc_decryptAESUsingkey:key InitializationVector:iv Padding:padding Mode:mode error:error].cc_utf8EncodedString;
}

- (NSString *)cc_encryptDESUsingEncoding:(CCEncrpytEncodingOptions)encoding
                                     key:(id)key
                    InitializationVector:(id)iv
                                 Padding:(CcCryptorPadding)padding
                                    Mode:(CcCryptorMode)mode
                                   error:(NSError *__autoreleasing *)error
{
    NSData * aesEncryptData = [self.cc_dataUsingUTF8Encoding cc_encryptDESUsingkey:key InitializationVector:iv Padding:padding Mode:mode error:error];
    switch (encoding) {
        case CCEncrpytHexStringEncoding:
            return aesEncryptData.cc_hexEncodedString;
            break;
        case CCEncrpytBase64StringEncoding:
            return [aesEncryptData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            
        default:
            return aesEncryptData.cc_utf8EncodedString;
            break;
    }
}

- (NSString *)cc_decryptDESUsingEncoding:(CCDecrpytDecodingOptions)decoding
                                     key:(id)key
                    InitializationVector:(id)iv
                                 Padding:(CcCryptorPadding)padding
                                    Mode:(CcCryptorMode)mode
                                   error:(NSError *__autoreleasing *)error
{
    NSData *aesDecryptData = (decoding == CCDecrpytHexStringDecoding) ? self.cc_dataUsingHexEncoding : self.cc_dataUsingBase64Encoding;
    return  [aesDecryptData cc_decryptDESUsingkey:key InitializationVector:iv Padding:padding Mode:mode error:error].cc_utf8EncodedString;
}


- (NSString *)cc_encryptRC4UsingEncoding:(CCEncrpytEncodingOptions)encoding{
    NSData *rc4Data = self.cc_dataUsingUTF8Encoding.cc_encryptRC4;
    return (encoding == CCEncrpytHexStringEncoding) ? rc4Data.cc_hexEncodedString : [rc4Data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (NSString *)cc_decryptRC4UsingEncoding:(CCDecrpytDecodingOptions)decoding{
    NSData *cr4DecryptData = (decoding == CCDecrpytHexStringDecoding) ? self.cc_dataUsingHexEncoding : self.cc_dataUsingBase64Encoding;
    return cr4DecryptData.cc_decryptRC4.cc_utf8EncodedString;
}


@end

