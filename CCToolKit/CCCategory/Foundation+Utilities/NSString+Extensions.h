//
//  NSString+Extensions.h
//  CCToolKit
//
//  Created by Harry_L on 2017/5/18.
//  Copyright © 2017年 Harry_L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+Extensions.h"
#import <UIKit/UIKit.h>
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

- (const char *)cc_asciiValue;
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
 convertToPingyinString

 @param isCombiningMarks Whether with Combining Marks

 */
- (NSString *)cc_convertToPinyinWithCombiningMarks:(BOOL)isCombiningMarks;

/**
 reversedString
 */
- (NSString *)cc_stringByReversed;
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
/**
 Trim blank characters (space and newline) in head and tail.
 @return the trimmed string.
 */
- (NSString *)cc_stringByTrim;

@end

#pragma mark - NSDate
@interface NSString (Date)
/**
 Returns an data With formatted string.
 see http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
 for format description.
 
 @param format   String representing the desired date format.
 e.g. @"yyyy-MM-dd HH:mm:ss"

 */
- (NSDate *)cc_dateUsingFormat:(NSString *)format;
/**
  Returns an data With formatted string.
 
 see http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
 for format description.
 
 @param format    String representing the desired date format.
 e.g. @"yyyy-MM-dd HH:mm:ss"
 
 @param timeZoneName  Desired time zone.
 
 @param locale    Desired locale.
 */
- (NSDate *)cc_dateUsingFormat:(NSString *)format TimeZone:(NSString *)timeZoneName locale:(NSLocale *)locale;

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


@interface NSString (Plist)
/**
 Creates and returns an array from a specified property list xml string.
 @return A new array created from the plist string, or nil if an error occurs.
 */
- (NSArray *)cc_plistArray;
/**
 Creates and returns an array from a specified property list xml string.
 @return A new array created from the plist string, or nil if an error occurs.
 */
- (NSMutableArray *)cc_plistMutableArray;

@end
#pragma  mark - Drawing

@interface NSString (Drawing)


///=============================================================================
/// @name Drawing
///=============================================================================

/**
 Returns the size of the string if it were rendered with the specified constraints.
 
 @param font          The font to use for computing the string size.default is 17.
 
 @param size          The maximum acceptable size for the string. This value is
 used to calculate where line breaks and wrapping would occur.
 
 @param lineBreakMode The line break options for computing the size of the string.
 For a list of possible values, see NSLineBreakMode.
 
 @return              The width and height of the resulting string's bounding box.
 These values may be rounded up to the nearest whole number.
 */
- (CGSize)cc_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

/**
 Returns the width of the string if it were to be rendered with the specified
 font on a single line.
 
 @param font  The font to use for computing the string width.
 
 @return      The width of the resulting string's bounding box. These values may be
 rounded up to the nearest whole number.
 */
- (CGFloat)cc_widthForFont:(UIFont *)font;

/**
 Returns the height of the string if it were rendered with the specified constraints.
 
 @param font   The font to use for computing the string size.
 
 @param width  The maximum acceptable width for the string. This value is used
 to calculate where line breaks and wrapping would occur.
 
 @return       The height of the resulting string's bounding box. These values
 may be rounded up to the nearest whole number.
 */
- (CGFloat)cc_heightForFont:(UIFont *)font width:(CGFloat)width;
@end


@interface NSString (NSNumber)
///=============================================================================
/// @name NSNumber Compatible
///=============================================================================

// Now you can use NSString as a NSNumber.
@property (readonly) char charValue;
@property (readonly) unsigned char unsignedCharValue;
@property (readonly) short shortValue;
@property (readonly) unsigned short unsignedShortValue;
@property (readonly) unsigned int unsignedIntValue;
@property (readonly) long longValue;
@property (readonly) unsigned long unsignedLongValue;
@property (readonly) unsigned long long unsignedLongLongValue;
@property (readonly) NSUInteger unsignedIntegerValue;
/**
 Try to parse this string and returns an `NSNumber`.
 @return Returns an `NSNumber` if parse succeed, or nil if an error occurs.
 */
- (NSNumber *)cc_numberValue;
@end


@interface NSString (Compare)
//添加两个字符串比较的方法 降序排序
- (NSComparisonResult)compareAgainst:(NSString *)anString;

@end


@interface NSString (Regular)

/**

 @return handle the json Text.
 */
- (NSString *)cc_jsonText;

/**
  Verify if instance is a mobile number
 */
- (BOOL)cc_isMobilePhoneNumberRegex;
/**
 Verify if instance is a Identity Card Number
 */
- (BOOL)cc_isIdentityCardNumberRegex;
/**
 Verify if instance is email address
 */
- (BOOL)cc_isValidEmailAddress;
/**
 Verify if instance is chinese
 */
- (BOOL)cc_isChinese;
/**
 Verify if instance is digtal
 */
- (BOOL)cc_isNumber;
/**
 Verify if instance is letter
 */
- (BOOL)cc_isEnglishLetter;
/**

 @param minLenth  Minimum length of string
 @param maxLenth  Maximum length of string
 @param containChinese whether to contain Chinese
 @param firstCannotBeDigtal whether the first character of string can be digtal
 @return true or false
 */
- (BOOL)cc_isValidWithMinLenth:(NSInteger)minLenth
                      maxLenth:(NSInteger)maxLenth
                containChinese:(BOOL)containChinese
           firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;
/**
 @param     minLenth Minimum length of string
 @param     maxLenth Maximum length of string
 @param     containChinese whether to contain Chinese
 @param     containDigtal   whether to contain Digtal
 @param     containLetter   whether to contain Letter
 @param     containOtherCharacter   whether to contain other character
 @param     firstCannotBeDigtal whether the first character of string can be digtal

 */
- (BOOL)cc_isValidWithMinLenth:(NSInteger)minLenth
                      maxLenth:(NSInteger)maxLenth
                containChinese:(BOOL)containChinese
                 containDigtal:(BOOL)containDigtal
                 containLetter:(BOOL)containLetter
         containOtherCharacter:(NSString *)containOtherCharacter
           firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;


- (BOOL)cc_checkWithRegularExpression:(NSString *)expression;
@end
