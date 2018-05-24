//
//  NSData+Extensions.h
//  CCToolKit
//
//  Created by Harry_L on 2017/5/19.
//  Copyright © 2017年 Harry_L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSError+Extensions.h"

#pragma mark - enum
typedef enum : NSUInteger {
    CcCryptorNoneMode,
    CcCryptorECBMode,
    CcCryptorCBCMode
}CcCryptorMode;

typedef enum : NSUInteger {
    CcCryptoAlgorithmAES = 0, //Advanced Encryption Standard, 128-bit block.
    CcCryptoAlgorithmDES,     //Data Encryption Standard.
    CcCryptoAlgorithm3DES,    //Triple-DES, three key, EDE configuration
    CcCryptoAlgorithmCAST,    //CAST
    CcCryptoAlgorithmRC4,     //RC4 stream cipher
    CcCryptoAlgorithmRC2,
    CcCryptoAlgorithmBLOWFISH  // Blowfish block cipher
}CcCryptoAlgorithm;


#pragma mark - Categoty_Encoding

@interface NSData (Encoding)

- (instancetype)initWithHexEncodedString:(NSString *)string;

- (NSString *)cc_hexEncodedString;

- (NSString *)cc_utf8EncodedString;

- (id)cc_jsonValueDecoded;

@end

#pragma mark - Categoty_CommonDigest
@interface NSData (CommonDigest)

#pragma mark - ReturnData  (Digest)

/**
 Returns an NSData for md2 hash.
 */
- (NSData *)cc_md2Data;
/**
 Returns an NSData for md4 hash.
 */
- (NSData *)cc_md4Data;
/**
 Returns an NSData for md5 hash.
 */
- (NSData *)cc_md5Data;
/**
 Returns an NSData for sha1 hash.
 */
- (NSData *)cc_sha1Data;
/**
 Returns an NSData for sha224 hash.
 */
- (NSData *)cc_sha224Data;
/**
 Returns an NSData for 256 hash.
 */
- (NSData *)cc_sha256Data;
/**
 Returns an NSData for 384 hash.
 */
- (NSData *)cc_sha384Data;
/**
 Returns an NSData for 512 hash.
 */
- (NSData *)cc_sha512Data;

#pragma mark - ReturnString  (Digest)

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

#pragma mark - Category_CommonHmac
@interface NSData (CommonHmac)

#pragma mark - ReturnData  (Hash-based Message Authentication Code)

/**
 Returns an NSData for hmac using algorithm md5 with key.
 @param key  The hmac key must be NSString Or NSData Object.
 */
- (NSData *)cc_hmacMD5DataWithKey:(id)key;
/**
 Returns an NSData for hmac using algorithm sha1 with key.
 @param key  The hmac key must be NSString Or NSData Object.
 */
- (NSData *)cc_hmacSHA1DataWithKey:(id)key;
/**
 Returns an NSData for hmac using algorithm sha224 with key.
 @param key  The hmac key must be NSString Or NSData Object.
 */
- (NSData *)cc_hmacSHA224DataWithKey:(id)key;
/**
 Returns an NSData for hmac using algorithm sha256 with key.
 @param key  The hmac key must be NSString Or NSData Object.
 */
- (NSData *)cc_hmacSHA256DataWithKey:(id)key;
/**
 Returns an NSData for hmac using algorithm sha384 with key.
 @param key  The hmac key must be NSString Or NSData Object.
 */
- (NSData *)cc_hmacSHA384DataWithKey:(id)key;
/**
 Returns an NSData for hmac using algorithm sha512 with key.
 @param key  The hmac key must be NSString Or NSData Object.
 */
- (NSData *)cc_hmacSHA512DataWithKey:(id)key;


#pragma mark - ReturnString  (Hash-based Message Authentication Code)
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

#pragma mark - Categoty_CommonCryptor
@interface NSData (CommonCryptor)

#pragma mark - Symmetric encryption algorithm （AES）
/**
 Returns an encrypted NSData using AES.

 @param key A key length of 16, 24 or 32 (128, 192 or 256bits).
            NSString or NSData Object.
 
 @param iv An initialization vector length of 16(128bits).
           Pass nil when you don't want to use iv or mode is ECB.
           NSString or NSData Object.
 
 @param mode CcCryptorMode. CBC or ECB
 
 @return An NSData encrypted, or nil if an error occurs.
 */
-(NSData *)cc_encryptAESUsingkey:(id)key
            InitializationVector:(id)iv
                            Mode:(CcCryptorMode)mode
                           error:(NSError *__autoreleasing *)error;

/**
 Returns an decrypted NSData using AES.
 
 @param key A key length of 16, 24 or 32 (128, 192 or 256bits).
            NSString or NSData Object.
 
 @param iv An initialization vector length of 16(128bits).
           Pass nil when you don't want to use iv or mode is ECB.
           NSString or NSData Object.
 
 @param mode CcCryptorMode. CBC or ECB
 
 @return An NSData decrypted, or nil if an error occurs.
 */
-(NSData *)cc_decryptAESUsingkey:(id)key
            InitializationVector:(id)iv
                            Mode:(CcCryptorMode)mode
                           error:(NSError *__autoreleasing *)error;

#pragma mark - Symmetric encryption algorithm （DES）
/**
 Returns an encrypted NSData using DES.
 
 @param key A key length of 8 (64bits).
            NSString or NSData Object.
 
 @param iv An initialization vector length of 8(64bits) at least.
           Pass nil when you don't want to use iv or mode is ECB.
           NSString or NSData Object.
 
 @param mode CcCryptorMode. CBC or ECB
 
 @return An NSData encrypted, or nil if an error occurs.
 */
-(NSData *)cc_encryptDESUsingkey:(id)key
            InitializationVector:(id)iv
                            Mode:(CcCryptorMode)mode
                           error:(NSError *__autoreleasing *)error;

/**
 Returns an decrypted NSData using DES.
 
 @param key A key length of 8 (64bits).
            NSString or NSData Object.
 
 @param iv An initialization vector length of 8(64bits) at least
           Pass nil when you don't want to use iv or mode is ECB.
           NSString or NSData Object.
 
 @param mode CcCryptorMode. CBC or ECB
 
 @return An NSData decrypted, or nil if an error occurs.
 */
-(NSData *)cc_decryptDESUsingkey:(id)key
            InitializationVector:(id)iv
                            Mode:(CcCryptorMode)mode
                           error:(NSError *__autoreleasing *)error;


#pragma mark - Symmetric encryption algorithm （RC4）
/**
 return An  encrypted NSData Using RC4.
 */
- (NSData *)cc_encryptRC4;
/**
 return An  decrypted NSData Using RC4.
 */
- (NSData *)cc_decryptRC4;

#pragma mark - lowCommonCryptor

- (NSData *)cc_encryptUsingAlgorithm:(CcCryptoAlgorithm)algorithm
                                 key:(id)key
                InitializationVector:(id)iv
                                Mode:(CcCryptorMode)mode
                               error:(NSError**)error;

- (NSData *)cc_decryptUsingAlgorithm:(CcCryptoAlgorithm)algorithm
                                 key:(id)key
                InitializationVector:(id)iv
                                Mode:(CcCryptorMode)mode
                               error:(NSError**)error;
@end

@interface NSData (Zlib)

/**
 Comperss data to zlib in default compresssion level.
 @return Deflated data.
 */
- (NSData *)cc_zlibDeflate;
/**
Decompress data from zlib data.
 @return Deflated data.
 */
-(NSData *)cc_zlibInflate;
/**
 Comperss data to gzip in default compresssion level.
 @return Deflated data.
 */
- (NSData *)cc_gzipDeflate;
/**
 Decompress data from gzip data.
 @return Inflated data.
 */
- (NSData *)cc_gzipInflate;

@end
