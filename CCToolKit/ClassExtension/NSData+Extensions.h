//
//  NSData+Extensions.h
//  CCToolKit
//
//  Created by Harry_L on 2017/5/19.
//  Copyright © 2017年 Harry_L. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - enum
/*
    Block encryption Mode
 */
typedef enum : NSUInteger {
    CcCryptorNoneMode,
    CcCryptorECBMode = 1,// Electronic Code Book
    CcCryptorCBCMode = 2 // Cipher Block Chaining
}CcCryptorMode;

/*
 Padding Mode
  the length of the sequence of the bytes == (blockSize - (sourceSize's length % blockSize))
*/
typedef enum : NSUInteger {
    CcCryptorNoPadding = 0, //No Padding to source Data
    
    CcCryptorPKCS7Padding = 1, // PKCS_7 | Each byte fills in the length of the sequence of the bytes .  ***This Padding Mode  use the system method.***
    CcCryptorZeroPadding = 2,   // 0x00 Padding |  Each byte fills 0x00
    CcCryptorANSIX923,     // The last byte fills the length of the byte sequence, and the               remaining bytes are filled with 0x00.
    CcCryptorISO10126      // The last byte fills the length of the byte sequence and  the remaining bytes fill the random data.
}CcCryptorPadding;


typedef enum : NSUInteger {
    CcCryptoAlgorithmAES = 0, //Advanced Encryption Standard, 128-bit block.  key 16 24 32 Length
    CcCryptoAlgorithmDES,     //Data Encryption Standard.  Key 8 Length
    CcCryptoAlgorithm3DES,    //Triple-DES, three key 24 Length, EDE configuration
    CcCryptoAlgorithmCAST128,    //CAST, 16Length
    CcCryptoAlgorithmRC4,     //RC4 stream cipher [1,512]Length
    CcCryptoAlgorithmRC2,     // [1,128]Length
    CcCryptoAlgorithmBLOWFISH  // Blowfish block cipher [8,56Length]
}CcCryptoAlgorithm;


#pragma mark - Categoty_Encoding

@interface NSData (Encoding)


/**
   return an NSData With the 16 hexadecimal  String.
 */
- (instancetype)initWithHexEncodedString:(NSString *)string;

/**
   return the String With 16 hexadecimal.
 */
- (NSString *)cc_hexEncodedString;
/**
 return the String With UTF-8.
 */
- (NSString *)cc_utf8EncodedString;
/**
 return the vlaue With Json Convert.
 */
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
 
 @param padding CcCryptorPadding.
 @param mode    CcCryptorMode. CBC or ECB
 
 @return An NSData encrypted, or nil if an error occurs.
 */
-(NSData *)cc_encryptAESUsingkey:(id)key
            InitializationVector:(id)iv
                         Padding:(CcCryptorPadding)padding
                            Mode:(CcCryptorMode)mode
                           error:(NSError *__autoreleasing *)error;

/**
 Returns an decrypted NSData using AES.
 
 @param key A key length of 16, 24 or 32 (128, 192 or 256bits).
 NSString or NSData Object.
 
 @param iv An initialization vector length of 16(128bits).
           Pass nil when you don't want to use iv or mode is ECB.
           NSString or NSData Object.
 
 @param padding CcCryptorPadding.
 
 @param mode CcCryptorMode. CBC or ECB
 
 @return An NSData decrypted, or nil if an error occurs.
 */
-(NSData *)cc_decryptAESUsingkey:(id)key
            InitializationVector:(id)iv
                         Padding:(CcCryptorPadding)padding
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
 
 @param padding CcCryptorPadding.
 
 @param mode CcCryptorMode. CBC or ECB
 
 @return An NSData encrypted, or nil if an error occurs.
 */
-(NSData *)cc_encryptDESUsingkey:(id)key
            InitializationVector:(id)iv
                         Padding:(CcCryptorPadding)padding
                            Mode:(CcCryptorMode)mode
                           error:(NSError *__autoreleasing *)error;

/**
 Returns an decrypted NSData using DES.
 
 @param key A key length of 8 (64bits).
            NSString or NSData Object.
 
 @param iv An initialization vector length of 8(64bits) at least
           Pass nil when you don't want to use iv or mode is ECB.
           NSString or NSData Object.
 
 @param padding CcCryptorPadding.
 
 @param mode CcCryptorMode. CBC or ECB
 
 @return An NSData decrypted, or nil if an error occurs.
 */
-(NSData *)cc_decryptDESUsingkey:(id)key
            InitializationVector:(id)iv
                         Padding:(CcCryptorPadding)padding
                            Mode:(CcCryptorMode)mode
                           error:(NSError *__autoreleasing *)error;

#pragma mark - Symmetric encryption algorithm （3DES）
/**
 Returns an encrypted NSData using 3DES.
 
 @param key A key length of 24 (192bits).
            NSString or NSData Object.
 
 @param iv An initialization vector length of 8(64bits) at least.
           Pass nil when you don't want to use iv or mode is ECB.
           NSString or NSData Object.
 
 @param padding CcCryptorPadding.
 
 @param mode CcCryptorMode. CBC or ECB
 
 @return An NSData encrypted, or nil if an error occurs.
 */
-(NSData *)cc_encrypt3DESUsingkey:(id)key
            InitializationVector:(id)iv
                         Padding:(CcCryptorPadding)padding
                            Mode:(CcCryptorMode)mode
                           error:(NSError *__autoreleasing *)error;
/**
 Returns an decrypted NSData using 3DES.
 
 @param key A key length of 24 (192bits).
            NSString or NSData Object.
 
 @param iv An initialization vector length of 8(64bits) at least
           Pass nil when you don't want to use iv or mode is ECB.
            NSString or NSData Object.
 
 @param padding CcCryptorPadding.
 
 @param mode CcCryptorMode. CBC or ECB
 
 @return An NSData decrypted, or nil if an error occurs.
 */
-(NSData *)cc_decrypt3DESUsingkey:(id)key
            InitializationVector:(id)iv
                         Padding:(CcCryptorPadding)padding
                            Mode:(CcCryptorMode)mode
                           error:(NSError *__autoreleasing *)error;

#pragma mark - CAST Algorithm
/**
 Returns an encrypted NSData using CAST.
 
 @param key A key length  16 (128bits).
            NSString or NSData Object.
 
 @param iv An initialization vector length of 8(64bits) at least.
           Pass nil when you don't want to use iv or mode is ECB.
            NSString or NSData Object.
 
 @param padding CcCryptorPadding.
 
 @param mode CcCryptorMode. CBC or ECB
 
 @return An NSData encrypted, or nil if an error occurs.
 */
-(NSData *)cc_encryptCAST128Usingkey:(id)key
             InitializationVector:(id)iv
                          Padding:(CcCryptorPadding)padding
                             Mode:(CcCryptorMode)mode
                            error:(NSError *__autoreleasing *)error;
/**
 Returns an decrypted NSData using CAST.
 
 @param key A key length  16 (128bits).
            NSString or NSData Object.
 
 @param iv An initialization vector length of 8(64bits) at least
           Pass nil when you don't want to use iv or mode is ECB.
           NSString or NSData Object.
 
 @param padding CcCryptorPadding.
 
 @param mode CcCryptorMode. CBC or ECB
 
 @return An NSData decrypted, or nil if an error occurs.
 */
-(NSData *)cc_decryptCAST128Usingkey:(id)key
             InitializationVector:(id)iv
                          Padding:(CcCryptorPadding)padding
                             Mode:(CcCryptorMode)mode
                            error:(NSError *__autoreleasing *)error;

#pragma mark - BLOWFISH Algorithm
/**
 Returns an encrypted NSData using BLOWFISH.
 
 @param key A key length  [8,56]
 NSString or NSData Object.
 
 @param iv An initialization vector length of 8(64bits) at least.
 Pass nil when you don't want to use iv or mode is ECB.
 NSString or NSData Object.
 
 @param padding CcCryptorPadding.
 
 @param mode CcCryptorMode. CBC or ECB
 
 @return An NSData encrypted, or nil if an error occurs.
 */
-(NSData *)cc_encryptBLOWFISHUsingkey:(id)key
             InitializationVector:(id)iv
                          Padding:(CcCryptorPadding)padding
                             Mode:(CcCryptorMode)mode
                            error:(NSError *__autoreleasing *)error;
/**
 Returns an decrypted NSData using BLOWFISH.
 
 @param key A key length  [8,56]
 NSString or NSData Object.
 
 @param iv An initialization vector length of 8(64bits) at least
 Pass nil when you don't want to use iv or mode is ECB.
 NSString or NSData Object.
 
 @param padding CcCryptorPadding.
 
 @param mode CcCryptorMode. CBC or ECB
 
 @return An NSData decrypted, or nil if an error occurs.
 */
-(NSData *)cc_decryptBLOWFISHUsingkey:(id)key
             InitializationVector:(id)iv
                          Padding:(CcCryptorPadding)padding
                             Mode:(CcCryptorMode)mode
                            error:(NSError *__autoreleasing *)error;

#pragma mark - RC4 Algoritm
/**
 return An  encrypted NSData Using RC4.
 */
- (NSData *)cc_encryptRC4;
/**
 return An  decrypted NSData Using RC4.
 */
- (NSData *)cc_decryptRC4;

#pragma mark - lowCommonCryptor

/**

 return An  encrypted NSData.
 
 @param algorithm CcCryptoAlgorithm
 
 @param key The Key Size must be consist With  selected algorithm.
 
 @param iv  The Iv Size must be consist With  selected algorithm.
 
 @param mode CcCryptorMode
 
 @param padding CcCryptorPadding

 */
- (NSData *)cc_encryptUsingAlgorithm:(CcCryptoAlgorithm)algorithm
                                 key:(id)key
                InitializationVector:(id)iv
                                Mode:(CcCryptorMode)mode
                             Padding:(CcCryptorPadding)padding
                               error:(NSError**)error;
/**
 
 return An  decrypted NSData.
 
 @param algorithm CcCryptoAlgorithm
 
 @param key The Key Size must be consist With  selected algorithm.
 
 @param iv  The Iv Size must be consist With  selected algorithm.
 
 @param mode CcCryptorMode
 
 @param padding CcCryptorPadding
 
 */
- (NSData *)cc_decryptUsingAlgorithm:(CcCryptoAlgorithm)algorithm
                                 key:(id)key
                InitializationVector:(id)iv
                                Mode:(CcCryptorMode)mode
                             Padding:(CcCryptorPadding)padding
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
