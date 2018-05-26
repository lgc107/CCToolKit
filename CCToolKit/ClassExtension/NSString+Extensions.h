//
//  NSString+Extensions.h
//  CCToolKit
//
//  Created by Harry_L on 2017/5/18.
//  Copyright © 2017年 Harry_L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+Extensions.h"

typedef enum : NSUInteger {
    CCEncrpytBase64StringEncoding,
    CCEncrpytHexStringEncoding
}CCEncrpytEncodingOptions;

typedef enum : NSUInteger {
    CCDecrpytBase64StringDecoding,
    CCDecrpytHexStringDecoding
}CCDecrpytDecodingOptions;


@interface NSString (Utilities)

/**
 Returns a new UUID NSString
 e.g. "D1178E50-2A4D-4F1F-9BD3-F6AAB00E06B1"
 */
+ (NSString *)cc_uuidString;
#pragma mark - Encoding and Decoding
/**
 Returns an NSData With HexString.
 */
- (NSData *)cc_dataUsingHexEncoding;
/**
 Returns an NSData using UTF-8 encoding.
 */
- (NSData *)cc_dataUsingUTF8Encoding;
/**
 Returns an NSData for base64 encoding
 */
- (NSData *)cc_dataUsingBase64Encoding;

/**
 URL encode a string in utf-8.
 @return the encoded string.
 */
- (NSString *)cc_stringByURLEncode;

/**
 URL decode a string in utf-8.
 @return the decoded string.
 */
- (NSString *)cc_stringByURLDecode;

/**
 Escape commmon HTML to Entity.
 Example: "a>b" will be escape to "a&gt;b".
 */
- (NSString *)cc_stringByEscapingHTML;

#pragma mark - Utilities
/**
 nil, @"", @"  ", @"\n" will Returns NO; otherwise Returns YES.
 */
- (BOOL)cc_isNotBlank;
/**
 Returns NSMakeRange(0, self.length).
 */
- (NSRange)cc_rangeOfAll;

/**
 Returns YES if the target CharacterSet is contained within the receiver.
 @param set  A character set to test the the receiver.
 */
- (BOOL)cc_containsCharacterSet:(NSCharacterSet *)set;
/**
 Returns an NSDictionary/NSArray which is decoded from receiver.
 Returns nil if an error occurs.
 
 e.g. NSString: @"{"name":"a","count":2}"  => NSDictionary: @[@"name":@"a",@"count":@2]
 */
- (id)cc_jsonValueDecoded;
@end

#pragma mark - CommonDigest
@interface NSString (CommonDigest)

/**
 Returns a lowercase NSString for md2 hash.
 */
- (NSString *)cc_md2String;
/**
 Returns a lowercase NSString for md4 hash.
 */
- (NSString *)cc_md4String;
/**
 Returns a lowercase NSString for md5 hash.
 */
- (NSString *)cc_md5String;
/**
 Returns a lowercase NSString for sha1 hash.
 */
- (NSString *)cc_sha1String;
/**
 Returns a lowercase NSString for sha224 hash.
 */
- (NSString *)cc_sha224String;
/**
 Returns a lowercase NSString for sha256 hash.
 */
- (NSString *)cc_sha256String;
/**
 Returns a lowercase NSString for sha384 hash.
 */
- (NSString *)cc_sha384String;
/**
 Returns a lowercase NSString for sha512 hash.
 */
- (NSString *)cc_sha512String;
@end

#pragma mark - HMAC
@interface NSString (CommonHmac)
/**
 Returns a lowercase NSString for hmac using algorithm md5 with key.
 @param key  The hmac key must be NSString Or NSData Object.
 */
- (NSString *)cc_hmacMD5StringWith:(id)key;
/**
 Returns a lowercase NSString for hmac using algorithm sha1 with key.
 @param key  The hmac key must be NSString Or NSData Object.
 */
- (NSString *)cc_hmacSHA1StringWith:(id)key;
/**
 Returns a lowercase NSString for hmac using algorithm sha224 with key.
 @param key  The hmac key must be NSString Or NSData Object.
 */
- (NSString *)cc_hmacSHA224StringWith:(id)key;
/**
 Returns a lowercase NSString for hmac using algorithm sha256 with key.
 @param key  The hmac key must be NSString Or NSData Object.
 */
- (NSString *)cc_hmacSHA256StringWith:(id)key;
/**
 Returns a lowercase NSString for hmac using algorithm sha384 with key.
 @param key  The hmac key must be NSString Or NSData Object.
 */
- (NSString *)cc_hmacSHA384StringWith:(id)key;
/**
 Returns a lowercase NSString for hmac using algorithm sha512 with key.
 @param key  The hmac key must be NSString Or NSData Object.
 */
- (NSString *)cc_hmacSHA512StringWith:(id)key;

@end

#pragma mark - CommonCryptor
@interface NSString (CommonCryptor)
#pragma mark - Symmetric encryption algorithm （AES）
/**
 Returns an encrypted NSString using AES.
 
 @param encoding return HexEncoding or Base64Encoding String
 
 @param key A key length of 16, 24 or 32 (128, 192 or 256bits).
            NSString or NSData Object.
 
 @param iv An initialization vector length of 16(128bits).
           Pass nil when you don't want to use iv or mode is ECB.
           NSString or NSData Object.
 
 @param mode CcCryptorMode. CBC or ECB
 
 @return An NSString encrypted, or nil if an error occurs.
 */
-(NSString *)cc_encryptAESUsingEncoding:(CCEncrpytEncodingOptions)encoding
                                    key:(id)key
                   InitializationVector:(id)iv
                                Padding:(CcCryptorPadding)padding
                                   Mode:(CcCryptorMode)mode
                                  error:(NSError *__autoreleasing *)error;

/**
 Returns an decrypted NSString using AES.
 
 
 @param decoding Using HexDecoding or Base64Decoding
 
 @param key A key length of 16, 24 or 32 (128, 192 or 256bits).
            NSString or NSData Object.
 
 @param iv An initialization vector length of 16(128bits).
           Pass nil when you don't want to use iv or mode is ECB.
           NSString or NSData Object.
 
 @param mode CcCryptorMode. CBC or ECB
 
 @return An NSString decrypted, or nil if an error occurs.
 */
-(NSString *)cc_decryptAESUsingEncoding:(CCDecrpytDecodingOptions)decoding
                                    key:(id)key
                   InitializationVector:(id)iv
                                Padding:(CcCryptorPadding)padding
                                   Mode:(CcCryptorMode)mode
                                  error:(NSError *__autoreleasing *)error;

#pragma mark - Symmetric encryption algorithm （DES）
/**
 Returns an encrypted NSString using DES.
 
 @param encoding return HexEncoding or Base64Encoding String
 
 @param key A key length of 8 (64bits).
            NSString or NSData Object.
 
 @param iv An initialization vector length of 8(64bits) at least.
           Pass nil when you don't want to use iv or mode is ECB.
           NSString or NSData Object.
 
 @param mode CcCryptorMode. CBC or ECB
 
 @return An NSData encrypted, or nil if an error occurs.
 */
-(NSString *)cc_encryptDESUsingEncoding:(CCEncrpytEncodingOptions)encoding
                                    key:(id)key
                   InitializationVector:(id)iv
                                Padding:(CcCryptorPadding)padding
                                   Mode:(CcCryptorMode)mode
                                  error:(NSError *__autoreleasing *)error;

/**
 Returns an decrypted NSString using DES.
 
 @param decoding Using HexDecoding or Base64Decoding
 
 @param key A key length of 8 (64bits).
            NSString or NSData Object.
 
 @param iv An initialization vector length of 8(64bits) at least
           Pass nil when you don't want to use iv or mode is ECB.
           NSString or NSData Object.
 
 @param mode CcCryptorMode. CBC or ECB
 
 @return An NSData decrypted, or nil if an error occurs.
 */
-(NSString *)cc_decryptDESUsingEncoding:(CCDecrpytDecodingOptions)decoding
                                    key:(id)key
                   InitializationVector:(id)iv
                                Padding:(CcCryptorPadding)padding
                                   Mode:(CcCryptorMode)mode
                                  error:(NSError *__autoreleasing *)error;
#pragma mark - 3DES Algorithm
/**
 Returns an encrypted NSString using 3DES.
 
 @param encoding return HexEncoding or Base64Encoding String
 
 @param key A key length of 24 (192bits).
 NSString or NSData Object.
 
 @param iv An initialization vector length of 8(64bits) at least.
 Pass nil when you don't want to use iv or mode is ECB.
 NSString or NSData Object.
 
 @param mode CcCryptorMode. CBC or ECB
 
 @return An NSData encrypted, or nil if an error occurs.
 */
-(NSString *)cc_encrypt3DESUsingEncoding:(CCEncrpytEncodingOptions)encoding
                                    key:(id)key
                   InitializationVector:(id)iv
                                Padding:(CcCryptorPadding)padding
                                   Mode:(CcCryptorMode)mode
                                  error:(NSError *__autoreleasing *)error;

/**
 Returns an decrypted NSString using 3DES.
 
 @param decoding Using HexDecoding or Base64Decoding
 
 @param key A key length of 24 (192bits).
 NSString or NSData Object.
 
 @param iv An initialization vector length of 8(64bits) at least
 Pass nil when you don't want to use iv or mode is ECB.
 NSString or NSData Object.
 
 @param mode CcCryptorMode. CBC or ECB
 
 @return An NSData decrypted, or nil if an error occurs.
 */
-(NSString *)cc_decrypt3DESUsingEncoding:(CCDecrpytDecodingOptions)decoding
                                    key:(id)key
                   InitializationVector:(id)iv
                                Padding:(CcCryptorPadding)padding
                                   Mode:(CcCryptorMode)mode
                                  error:(NSError *__autoreleasing *)error;
#pragma mark -   CAST-128 Algorithm
/**
 Returns an encrypted NSString using CAST-128.
 
 @param encoding return HexEncoding or Base64Encoding String
 
 @param key A key length of 16 (128bits).
            NSString or NSData Object.
 
 @param iv An initialization vector length of 8(64bits) at least.
           Pass nil when you don't want to use iv or mode is ECB.
           NSString or NSData Object.
 
 @param mode CcCryptorMode. CBC or ECB
 
 @return An NSData encrypted, or nil if an error occurs.
 */
-(NSString *)cc_encryptCAST128UsingEncoding:(CCEncrpytEncodingOptions)encoding
                                     key:(id)key
                    InitializationVector:(id)iv
                                 Padding:(CcCryptorPadding)padding
                                    Mode:(CcCryptorMode)mode
                                   error:(NSError *__autoreleasing *)error;

/**
 Returns an decrypted NSString using CAST-128.
 
 @param decoding Using HexDecoding or Base64Decoding
 
 @param key A key length of 16 (128bits).
           NSString or NSData Object.
 
 @param iv An initialization vector length of 8(64bits) at least
           Pass nil when you don't want to use iv or mode is ECB.
           NSString or NSData Object.
 
 @param mode CcCryptorMode. CBC or ECB
 
 @return An NSData decrypted, or nil if an error occurs.
 */
-(NSString *)cc_decryptCAST128UsingEncoding:(CCDecrpytDecodingOptions)decoding
                                     key:(id)key
                    InitializationVector:(id)iv
                                 Padding:(CcCryptorPadding)padding
                                    Mode:(CcCryptorMode)mode
                                   error:(NSError *__autoreleasing *)error;
#pragma mark - BLOWFISH Algorithm
/**
 Returns an encrypted NSString using BLOWFISH.
 
 @param encoding return HexEncoding or Base64Encoding String
 
 @param key A key length of [8,56].
 NSString or NSData Object.
 
 @param iv An initialization vector length of 8(64bits) at least.
 Pass nil when you don't want to use iv or mode is ECB.
 NSString or NSData Object.
 
 @param mode CcCryptorMode. CBC or ECB
 
 @return An NSData encrypted, or nil if an error occurs.
 */
-(NSString *)cc_encryptBLOWFISHUsingEncoding:(CCEncrpytEncodingOptions)encoding
                                     key:(id)key
                    InitializationVector:(id)iv
                                 Padding:(CcCryptorPadding)padding
                                    Mode:(CcCryptorMode)mode
                                   error:(NSError *__autoreleasing *)error;

/**
 Returns an decrypted NSString using BLOWFISH.
 
 @param decoding Using HexDecoding or Base64Decoding
 
 @param key A key length of [8,56].
 NSString or NSData Object.
 
 @param iv An initialization vector length of 8(64bits) at least
 Pass nil when you don't want to use iv or mode is ECB.
 NSString or NSData Object.
 
 @param mode CcCryptorMode. CBC or ECB
 
 @return An NSData decrypted, or nil if an error occurs.
 */
-(NSString *)cc_decryptBLOWFISHUsingEncoding:(CCDecrpytDecodingOptions)decoding
                                     key:(id)key
                    InitializationVector:(id)iv
                                 Padding:(CcCryptorPadding)padding
                                    Mode:(CcCryptorMode)mode
                                   error:(NSError *__autoreleasing *)error;
#pragma mark - RC4 algorithm
/**
 return An  encrypted NSString Using RC4.
 */
- (NSString *)cc_encryptRC4UsingEncoding:(CCEncrpytEncodingOptions)encoding;
/**
 return An  decrypted NSString Using RC4.
 */
- (NSString *)cc_decryptRC4UsingEncoding:(CCDecrpytDecodingOptions)decoding;



@end
