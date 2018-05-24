//
//  NSData+Extensions.m
//  CCToolKit
//
//  Created by Harry_L on 2017/5/19.
//  Copyright © 2017年 Harry_L. All rights reserved.
//

#import "NSData+Extensions.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <zlib.h>

#pragma mark - Encoding
@implementation NSData (Encoding)

- (instancetype)initWithHexEncodedString:(NSString *)string{
    
    
    if (!string || [string length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [NSMutableData data];
    NSRange range;
    if ([string length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [string length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [string substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    self = [NSData dataWithData:hexData];
    
    return self;
}

- (NSString *)cc_utf8EncodedString {
    if (self.length > 0) {
        return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    }
    return @"";
}

- (NSString *)cc_hexEncodedString {
    if (self.length > 0) {
        NSUInteger length = self.length;
        NSMutableString *result = [NSMutableString stringWithCapacity:length * 2];
        const unsigned char *byte = self.bytes;
        for (int i = 0; i < length; i++, byte++) {
            [result appendFormat:@"%02x", *byte];
        }
        return result;
    }
    return @"";
}

- (id)cc_jsonValueDecoded {
    NSError *error = nil;
    id value = [NSJSONSerialization JSONObjectWithData:self options:kNilOptions error:&error];
    if (error) {
        NSLog(@"jsonValueDecoded error:%@", error);
    }
    return value;
}

@end

#pragma mark - CommonDigest
@implementation NSData (CommonDigest)

#pragma mark - returnData  (Message Digest)
- (NSData *)cc_md2Data
{
    unsigned char hash[CC_MD2_DIGEST_LENGTH];
    (void) CC_MD2( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_MD2_DIGEST_LENGTH] );
}

- (NSData *)cc_md4Data
{
    unsigned char hash[CC_MD4_DIGEST_LENGTH];
    (void) CC_MD4( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_MD4_DIGEST_LENGTH] );
}

- (NSData *)cc_md5Data
{
    unsigned char hash[CC_MD5_DIGEST_LENGTH];
    (void) CC_MD5( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_MD5_DIGEST_LENGTH] );
}

#pragma mark - returnString  (Message Digest)
- (NSString *)cc_md2String {
    unsigned char result[CC_MD2_DIGEST_LENGTH];
    CC_MD2(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_MD2_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD2_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

- (NSString *)cc_md4String {
    unsigned char result[CC_MD4_DIGEST_LENGTH];
    CC_MD4(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_MD4_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD4_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

- (NSString *)cc_md5String {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}


#pragma mark - returnData (-Hash_SHA)
- (NSData *)cc_sha1Data
{
    unsigned char hash[CC_SHA1_DIGEST_LENGTH];
    (void) CC_SHA1( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_SHA1_DIGEST_LENGTH] );
}


- (NSData *)cc_sha224Data
{
    unsigned char hash[CC_SHA224_DIGEST_LENGTH];
    (void) CC_SHA224( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_SHA224_DIGEST_LENGTH] );
}


- (NSData *)cc_sha256Data
{
    unsigned char hash[CC_SHA256_DIGEST_LENGTH];
    (void) CC_SHA256( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_SHA256_DIGEST_LENGTH] );
}

- (NSData *)cc_sha384Data
{
    unsigned char hash[CC_SHA384_DIGEST_LENGTH];
    (void) CC_SHA384( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_SHA384_DIGEST_LENGTH] );
}


- (NSData *)cc_sha512Data
{
    unsigned char hash[CC_SHA512_DIGEST_LENGTH];
    (void) CC_SHA512( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_SHA512_DIGEST_LENGTH] );
}

#pragma mark - returnString (-Hash_SHA)
- (NSString *)cc_sha1String {
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}
- (NSString *)cc_sha224String {
    unsigned char result[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA224_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA224_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

- (NSString *)cc_sha256String {
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

- (NSString *)cc_sha384String {
    unsigned char result[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA384_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA384_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

- (NSString *)cc_sha512String {
    unsigned char result[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}


@end

#pragma mark - CommonHmac
@implementation NSData(CommonHmac)

#pragma mark - returnData  (Hash-based Message Authentication Code)

- (NSData *)cc_hmacMD5DataWithKey:(id)key{
    return [self cc_hmacDataUsingAlg:kCCHmacAlgMD5 withKey:key];
}

- (NSData *)cc_hmacSHA1DataWithKey:(id)key{
    return [self cc_hmacDataUsingAlg:kCCHmacAlgSHA1 withKey:key];
}

- (NSData *)cc_hmacSHA224DataWithKey:(id)key{
    return [self cc_hmacDataUsingAlg:kCCHmacAlgSHA224 withKey:key];
}

- (NSData *)cc_hmacSHA256DataWithKey:(id)key{
    return [self cc_hmacDataUsingAlg:kCCHmacAlgSHA256 withKey:key];
}

- (NSData *)cc_hmacSHA384DataWithKey:(id)key{
    return [self cc_hmacDataUsingAlg:kCCHmacAlgSHA384 withKey:key];
}

- (NSData *)cc_hmacSHA512DataWithKey:(id)key{
    return [self cc_hmacDataUsingAlg:kCCHmacAlgSHA512 withKey:key];
}


#pragma mark - returnString  (Hash-based Message Authentication Code)
- (NSString *)cc_hmacMD5StringWith:(id)key{
    return [self cc_hmacStringUsingAlg:kCCHmacAlgMD5 withKey:key];
}

- (NSString *)cc_hmacSHA1StringWith:(id)key{
    return [self cc_hmacStringUsingAlg:kCCHmacAlgSHA1 withKey:key];
}

- (NSString *)cc_hmacSHA224StringWith:(id)key{
    return [self cc_hmacStringUsingAlg:kCCHmacAlgSHA224 withKey:key];
}

- (NSString *)cc_hmacSHA256StringWith:(id)key{
    return [self cc_hmacStringUsingAlg:kCCHmacAlgSHA256 withKey:key];
}


- (NSString *)cc_hmacSHA384StringWith:(id)key{
    return [self cc_hmacStringUsingAlg:kCCHmacAlgSHA384 withKey:key];
}

- (NSString *)cc_hmacSHA512StringWith:(id)key{
    return [self cc_hmacStringUsingAlg:kCCHmacAlgSHA512 withKey:key];
}

#pragma mark - hmac_root
- (NSData *)cc_hmacDataUsingAlg:(CCHmacAlgorithm)alg withKey:(id)key {
    NSParameterAssert([key isKindOfClass: [NSData class]] || [key isKindOfClass: [NSString class]]);
    size_t size;
    switch (alg) {
        case kCCHmacAlgMD5: size = CC_MD5_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA1: size = CC_SHA1_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA224: size = CC_SHA224_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA256: size = CC_SHA256_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA384: size = CC_SHA384_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA512: size = CC_SHA512_DIGEST_LENGTH; break;
        default: return nil;
    }
    NSMutableData * keyData;
    if ( [key isKindOfClass: [NSData class]] )
        keyData = (NSMutableData *) [key mutableCopy];
    else
        keyData = [[key dataUsingEncoding: NSUTF8StringEncoding] mutableCopy];
    
    unsigned char result[size];
    CCHmac(alg, [keyData bytes], keyData.length, self.bytes, self.length, result);
    return [NSData dataWithBytes:result length:size];
}

- (NSString *)cc_hmacStringUsingAlg:(CCHmacAlgorithm)alg withKey:(id)key {
    NSParameterAssert([key isKindOfClass: [NSData class]] || [key isKindOfClass: [NSString class]]);
    size_t size;
    switch (alg) {
        case kCCHmacAlgMD5: size = CC_MD5_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA1: size = CC_SHA1_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA224: size = CC_SHA224_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA256: size = CC_SHA256_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA384: size = CC_SHA384_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA512: size = CC_SHA512_DIGEST_LENGTH; break;
        default: return nil;
    }
    unsigned char result[size];
    NSMutableData * keyData;
    if ( [key isKindOfClass: [NSData class]] )
        keyData = (NSMutableData *) [key mutableCopy];
    else
        keyData = [[key dataUsingEncoding: NSUTF8StringEncoding] mutableCopy];
    
    CCHmac(alg, keyData.bytes, strlen(keyData.bytes), self.bytes, self.length, result);
    NSMutableString *hash = [NSMutableString stringWithCapacity:size * 2];
    for (int i = 0; i < size; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

@end


#pragma mark - CommonCryptor
@implementation NSData (CommonCryptor)

#pragma mark - AES
-(NSData *)cc_encryptAESUsingkey:(id)key
            InitializationVector:(id)iv
                            Mode:(CcCryptorMode)mode
                           error:(NSError *__autoreleasing *)error
{
    NSAssert(mode == CcCryptorCBCMode && [iv length] >= 16, @"With CBC Mode, InitializationVector  must be greater than 16 bits");
    if (mode == CcCryptorCBCMode && [iv length] < 16) {
        return nil;
    }
    return [self cc_encryptUsingAlgorithm:CcCryptoAlgorithmAES
                                      key:key
                     InitializationVector:iv ? iv :NULL
                                     Mode:mode
                                    error:error];
}

-(NSData *)cc_decryptAESUsingkey:(id)key
            InitializationVector:(id)iv
                            Mode:(CcCryptorMode)mode
                           error:(NSError *__autoreleasing *)error
{
    NSAssert(mode == CcCryptorCBCMode && [iv length] >= 16, @"With CBC Mode, InitializationVector  must be greater than 16 bits");
    if (mode == CcCryptorCBCMode && [iv length] < 16) {
        return nil;
    }
    
    return [self cc_decryptUsingAlgorithm:CcCryptoAlgorithmAES
                                      key:key
                     InitializationVector:iv ? iv :NULL
                                     Mode:mode
                                    error:error];
    
}

#pragma mark - DES
-(NSData *)cc_encryptDESUsingkey:(id)key
            InitializationVector:(id)iv
                            Mode:(CcCryptorMode)mode
                           error:(NSError *__autoreleasing *)error
{
    
    return [self cc_encryptUsingAlgorithm:CcCryptoAlgorithmDES
                                      key:key
                     InitializationVector:iv ? iv :NULL
                                     Mode:mode
                                    error:error];
}

-(NSData *)cc_decryptDESUsingkey:(id)key
            InitializationVector:(id)iv
                            Mode:(CcCryptorMode)mode
                           error:(NSError *__autoreleasing *)error
{
 
    return [self cc_decryptUsingAlgorithm:CcCryptoAlgorithmDES
                                      key:key
                     InitializationVector:iv ? iv :NULL
                                     Mode:mode
                                    error:error];
    
}

- (NSData *)cc_encryptRC4{
    return [self cc_encryptUsingAlgorithm:CcCryptoAlgorithmRC4 key:nil InitializationVector:NULL Mode:CcCryptorNoneMode error:nil];
}

- (NSData *)cc_decryptRC4{
    return [self cc_decryptUsingAlgorithm:CcCryptoAlgorithmRC4 key:nil InitializationVector:NULL Mode:CcCryptorNoneMode error:nil];
}

#pragma mark - lowCommonCrypto
- (NSData *)cc_encryptUsingAlgorithm:(CcCryptoAlgorithm)algorithm
                                 key:(id)key
                InitializationVector:(id)iv
                                Mode:(CcCryptorMode)mode
                               error:(NSError**)error
{
    NSAssert(mode == CcCryptorCBCMode && iv != nil && iv != NULL, @"With CBC Mode , InitializationVector  must have value");
    NSAssert(mode == CcCryptorCBCMode && [iv length] >= 8, @"With CBC Mode, InitializationVector  must be greater than 8 bits");
    if (mode == CcCryptorCBCMode && [iv length] < 8) {
        return nil;
    }
    
    CCCryptorStatus status = kCCSuccess;
    CCOptions options = 0;
    switch (mode) {
        case CcCryptorCBCMode:
            options = kCCOptionPKCS7Padding;
            break;
        case CcCryptorECBMode:
            options = kCCOptionPKCS7Padding | kCCOptionECBMode;
            iv = NULL;
            break;
        case CcCryptorNoneMode:
            iv = NULL;
        default:
            break;
    }
    
    NSData *result = [self cc_cryptologyUsingOperation:kCCEncrypt
                                             Algorithm:algorithm
                                                   key:key
                                  initializationVector:iv
                                               options:options
                                                 error:&status];
    
    if ( result != nil )
        return ( result );
    
    if ( error != NULL )
        *error = [NSError errorWithCCCryptorStatus: status];
    return ( nil );
}

- (NSData *)cc_decryptUsingAlgorithm:(CcCryptoAlgorithm)algorithm
                                 key:(id)key
                InitializationVector:(id)iv
                                Mode:(CcCryptorMode)mode
                               error:(NSError**)error
{
    
    NSAssert(mode == CcCryptorCBCMode && iv != nil && iv != NULL, @"With CBC Mode , InitializationVector  must have value");
    NSAssert(mode == CcCryptorCBCMode && [iv length] >= 8, @"With CBC Mode, InitializationVector  must be greater than 8 bits");
    if (mode == CcCryptorCBCMode && [iv length] < 8) {
        return nil;
    }

    CCCryptorStatus status = kCCSuccess;
    CCOptions options = 0;
    switch (mode) {
        case CcCryptorCBCMode:
            options = kCCOptionPKCS7Padding;
            break;
        case CcCryptorECBMode:
            options = kCCOptionPKCS7Padding | kCCOptionECBMode;
            break;
        case CcCryptorNoneMode:
            iv = NULL;
        default:
            break;
    }
    
    NSData *result = [self cc_cryptologyUsingOperation:kCCDecrypt
                                             Algorithm:algorithm
                                                   key:key
                                  initializationVector:iv
                                               options:options
                                                 error:&status];
    
    if ( result != nil )
        return ( result );
    
    if ( error != NULL )
        *error = [NSError errorWithCCCryptorStatus: status];
    return ( nil );
}


#pragma mark - RootCrypto
- (NSData *)cc_cryptologyUsingOperation:(CCOperation)operation
                              Algorithm: (CCAlgorithm) algorithm
                                    key: (id) key
                   initializationVector: (id) iv
                                options: (CCOptions) options
                                  error: (CCCryptorStatus *) error
{
    
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = kCCSuccess;
    
    NSParameterAssert([key isKindOfClass: [NSData class]] || [key isKindOfClass: [NSString class]]);
    NSParameterAssert(iv == nil || [iv isKindOfClass: [NSData class]] || [iv isKindOfClass: [NSString class]]);
    
    NSMutableData * keyData, * ivData;
    if ( [key isKindOfClass: [NSData class]] )
        keyData = (NSMutableData *) [key mutableCopy];
    else
        keyData = [[key dataUsingEncoding: NSUTF8StringEncoding] mutableCopy];
    
    if ( [iv isKindOfClass: [NSString class]] )
        ivData = [[iv dataUsingEncoding: NSUTF8StringEncoding] mutableCopy];
    else
        ivData = (NSMutableData *) [iv mutableCopy];    // data or nil
    
#if !__has_feature(objc_arc)
    [keyData autorelease];
    [ivData autorelease];
#endif
    // ensure correct lengths for key and iv data, based on algorithms
    SettingKeyLengths( algorithm, keyData, ivData );
    
    status = CCCryptorCreate( operation, algorithm, options,
                             [keyData bytes], [keyData length], [ivData bytes],
                             &cryptor );
    
    
    if ( status != kCCSuccess )
    {
        if ( error != NULL )
            *error = status;
        return ( nil );
    }
    
    NSData * result = [self cc_runCryptor: cryptor result: &status];
    if ( (result == nil) && (error != NULL) )
        *error = status;
    
    CCCryptorRelease( cryptor );
    
    return ( result );
}


- (NSData *)cc_runCryptor: (CCCryptorRef) cryptor result: (CCCryptorStatus *) status
{
    size_t bufsize = CCCryptorGetOutputLength( cryptor, (size_t)[self length], true );
    void * buf = malloc( bufsize );
    size_t bufused = 0;
    size_t bytesTotal = 0;
    *status = CCCryptorUpdate( cryptor, [self bytes], (size_t)[self length],
                              buf, bufsize, &bufused );
    if ( *status != kCCSuccess )
    {
        free( buf );
        return ( nil );
    }
    
    bytesTotal += bufused;
    
    // From Brent Royal-Gordon (Twitter: architechies):
    //  Need to update buf ptr past used bytes when calling CCCryptorFinal()
    *status = CCCryptorFinal( cryptor, buf + bufused, bufsize - bufused, &bufused );
    if ( *status != kCCSuccess )
    {
        free( buf );
        return ( nil );
    }
    
    bytesTotal += bufused;
    
    return ( [NSData dataWithBytesNoCopy: buf length: bytesTotal] );
}

static void SettingKeyLengths( CCAlgorithm algorithm, NSMutableData * keyData, NSMutableData * ivData)
{
    NSUInteger keyLength = [keyData length];
    switch ( algorithm )
    {
        case kCCAlgorithmAES128:
        {
            // 16
            if ( keyLength <= kCCKeySizeAES128 )
            {
                [keyData setLength: kCCKeySizeAES128];
            }
            // 24
            else if ( keyLength <= kCCKeySizeAES192 )
            {
                [keyData setLength: kCCKeySizeAES192];
            }
            // 32
            else
            {
                [keyData setLength: kCCKeySizeAES256];
            }
            
            break;
        }
            
        case kCCAlgorithmDES:
        {
            // 8
            [keyData setLength: kCCKeySizeDES];
            break;
        }
            
        case kCCAlgorithm3DES:
        {
            //24
            [keyData setLength: kCCKeySize3DES];
            break;
        }
            
        case kCCAlgorithmCAST:
        {
            //[5,16]
            if ( keyLength < kCCKeySizeMinCAST )
            {
                [keyData setLength: kCCKeySizeMinCAST];
            }
            else if ( keyLength > kCCKeySizeMaxCAST )
            {
                [keyData setLength: kCCKeySizeMaxCAST];
            }
            
            break;
        }
            
        case kCCAlgorithmRC4:
        {
            // [1,512]
            if ( keyLength >= kCCKeySizeMaxRC4 )
                [keyData setLength: kCCKeySizeMaxRC4 ];
            break;
        }
        case kCCAlgorithmRC2:
        {
            // [1,128]
            if ( keyLength >= kCCKeySizeMaxRC2 )
                [keyData setLength: kCCKeySizeMaxRC2 ];
        }
        case kCCAlgorithmBlowfish:
        {
            // [8,56]
            if (keyLength <= kCCKeySizeMinBlowfish) {
                [keyData setLength:kCCKeySizeMinBlowfish];
            }
            else if ( keyLength >= kCCKeySizeMaxBlowfish ){
                 [keyData setLength: kCCKeySizeMaxBlowfish ];
            }
            
        }
            
        default:
            break;
    }
    
    
    [ivData setLength: [keyData length]];
}
@end

#pragma mark - Zlib
@implementation NSData (Zlib)

- (NSData *)cc_zlibInflate
{
    
    if ([self length] == 0) return self;
    
    NSUInteger full_length = [self length];
    NSUInteger half_length = [self length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[self bytes];
    strm.avail_in = (unsigned)[self length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit (&strm) != Z_OK) return nil;
    
    while (!done)
    {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length])
            [decompressed increaseLengthBy: half_length];
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = (uint)([decompressed length] - strm.total_out);
        
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) done = YES;
        else if (status != Z_OK) break;
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    
    // Set real length.
    if (done)
    {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    }
    else return nil;
}

- (NSData *)cc_zlibDeflate
{
    if ([self length] == 0) return self;
    
    z_stream strm;
    
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in=(Bytef *)[self bytes];
    strm.avail_in = (uint)[self length];
    
    // Compresssion Levels:
    //   Z_NO_COMPRESSION
    //   Z_BEST_SPEED
    //   Z_BEST_COMPRESSION
    //   Z_DEFAULT_COMPRESSION
    
    if (deflateInit(&strm, Z_DEFAULT_COMPRESSION) != Z_OK) return nil;
    
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];  // 16K chuncks for expansion
    
    do {
        
        if (strm.total_out >= [compressed length])
            [compressed increaseLengthBy: 16384];
        
        strm.next_out = [compressed mutableBytes] + strm.total_out;
        strm.avail_out = (uint)([compressed length] - strm.total_out);
        
        deflate(&strm, Z_FINISH);
        
    } while (strm.avail_out == 0);
    
    deflateEnd(&strm);
    
    [compressed setLength: strm.total_out];
    return [NSData dataWithData: compressed];
}

- (NSData *)cc_gzipInflate
{
    if ([self length] == 0) return self;
    
    NSInteger full_length = [self length];
    NSInteger half_length = [self length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[self bytes];
    strm.avail_in = (uint)[self length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    while (!done)
    {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length])
            [decompressed increaseLengthBy: half_length];
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = (uint)([decompressed length] - strm.total_out);
        
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) done = YES;
        else if (status != Z_OK) break;
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    
    // Set real length.
    if (done)
    {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    }
    else return nil;
}

- (NSData *)cc_gzipDeflate
{
    if ([self length] == 0) return self;
    
    z_stream strm;
    
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in=(Bytef *)[self bytes];
    strm.avail_in = (uint)[self length];
    
    // Compresssion Levels:
    //   Z_NO_COMPRESSION
    //   Z_BEST_SPEED
    //   Z_BEST_COMPRESSION
    //   Z_DEFAULT_COMPRESSION
    
    if (deflateInit2(&strm, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY) != Z_OK) return nil;
    
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];  // 16K chunks for expansion
    
    do {
        
        if (strm.total_out >= [compressed length])
            [compressed increaseLengthBy: 16384];
        
        strm.next_out = [compressed mutableBytes] + strm.total_out;
        strm.avail_out = (uint)([compressed length] - strm.total_out);
        
        deflate(&strm, Z_FINISH);
        
    } while (strm.avail_out == 0);
    
    deflateEnd(&strm);
    
    [compressed setLength: strm.total_out];
    return [NSData dataWithData:compressed];
}


@end




