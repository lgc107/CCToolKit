//
//  NSString+Extensions.m
//  CCToolKit
//
//  Created by Harry_L on 2017/5/18.
//  Copyright © 2017年 Harry_L. All rights reserved.
//


#import "NSString+Extensions.h"
#import "NSNumber+Extensions.h"


@implementation NSString (Utilities)

+ (NSString *)cc_uuidString{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidString;
}

#pragma mark - Encoding & Decoding
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


- (NSString *)cc_stringByURLEncode {
    if ([self respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
        /**
         AFNetworking/AFURLRequestSerialization.m
         
         Returns a percent-escaped string following RFC 3986 for a query string key or value.
         RFC 3986 states that the following characters are "reserved" characters.
         - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
         - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
         In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
         query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
         should be percent-escaped in the query string.
         - parameter string: The string to be percent-escaped.
         - returns: The percent-escaped string.
         */
        static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
        
        NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
        static NSUInteger const batchSize = 50;
        
        NSUInteger index = 0;
        NSMutableString *escaped = @"".mutableCopy;
        
        while (index < self.length) {
            NSUInteger length = MIN(self.length - index, batchSize);
            NSRange range = NSMakeRange(index, length);
            // To avoid breaking up character sequences such as 👴🏻👮🏽
            range = [self rangeOfComposedCharacterSequencesForRange:range];
            NSString *substring = [self substringWithRange:range];
            NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
            [escaped appendString:encoded];
            
            index += range.length;
        }
        return escaped;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *encoded = (__bridge_transfer NSString *)
        CFURLCreateStringByAddingPercentEscapes(
                                                kCFAllocatorDefault,
                                                (__bridge CFStringRef)self,
                                                NULL,
                                                CFSTR("!#$&'()*+,/:;=?@[]"),
                                                cfEncoding);
        return encoded;
#pragma clang diagnostic pop
    }
}

- (NSString *)cc_stringByURLDecode {
    if ([self respondsToSelector:@selector(stringByRemovingPercentEncoding)]) {
        return [self stringByRemovingPercentEncoding];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding en = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *decoded = [self stringByReplacingOccurrencesOfString:@"+"
                                                            withString:@" "];
        decoded = (__bridge_transfer NSString *)
        CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                NULL,
                                                                (__bridge CFStringRef)decoded,
                                                                CFSTR(""),
                                                                en);
        return decoded;
#pragma clang diagnostic pop
    }
}

- (NSString *)cc_stringByEscapingHTML {
    NSUInteger len = self.length;
    if (!len) return self;
    
    unichar *buf = malloc(sizeof(unichar) * len);
    if (!buf) return self;
    [self getCharacters:buf range:NSMakeRange(0, len)];
    
    NSMutableString *result = [NSMutableString string];
    for (int i = 0; i < len; i++) {
        unichar c = buf[i];
        NSString *esc = nil;
        switch (c) {
            case 34: esc = @"&quot;"; break;
            case 38: esc = @"&amp;"; break;
            case 39: esc = @"&apos;"; break;
            case 60: esc = @"&lt;"; break;
            case 62: esc = @"&gt;"; break;
            default: break;
        }
        if (esc) {
            [result appendString:esc];
        } else {
            CFStringAppendCharacters((CFMutableStringRef)result, &c, 1);
        }
    }
    free(buf);
    return result;
}

#pragma mark - Utilties
- (BOOL)cc_isNotBlank {
    if (self == nil || self == NULL) {
        return false;
    }
    else if ([self isKindOfClass:[NSNull class]]) {
        return false;
    }
    else{
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    }
    return NO;
}


- (BOOL)cc_containsCharacterSet:(NSCharacterSet *)set {
    if (set == nil) return NO;
    return [self rangeOfCharacterFromSet:set].location != NSNotFound;
}

- (id)cc_jsonValueDecoded {
    return self.cc_dataUsingUTF8Encoding.cc_jsonValueDecoded;
}

- (NSRange)cc_rangeOfAll {
    return NSMakeRange(0, self.length);
}


- (NSString *)cc_stringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}



@end


#pragma mark - NSDate
@implementation NSString (NSDate)

- (NSDate *)cc_dateUsingFormat:(NSString *)format{
   return  [self cc_dateUsingFormat:format TimeZone:nil locale:nil] ;
}
- (NSDate *)cc_dateUsingFormat:(NSString *)format TimeZone:(NSString *)timeZoneName locale:(NSLocale *)locale{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    if (timeZoneName.cc_isNotBlank) {
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:timeZoneName]];
    }
    if(locale) {
        [dateFormatter setLocale:locale];
    }
    NSDate *time = [dateFormatter dateFromString:self];
    return time;
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

#pragma mark - AES
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

#pragma mark - DES
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
#pragma mark - 3DES
- (NSString *)cc_encrypt3DESUsingEncoding:(CCEncrpytEncodingOptions)encoding
                                     key:(id)key
                    InitializationVector:(id)iv
                                 Padding:(CcCryptorPadding)padding
                                    Mode:(CcCryptorMode)mode
                                   error:(NSError *__autoreleasing *)error
{
    NSData * aesEncryptData = [self.cc_dataUsingUTF8Encoding cc_encrypt3DESUsingkey:key InitializationVector:iv Padding:padding Mode:mode error:error];
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

- (NSString *)cc_decrypt3DESUsingEncoding:(CCDecrpytDecodingOptions)decoding
                                     key:(id)key
                    InitializationVector:(id)iv
                                 Padding:(CcCryptorPadding)padding
                                    Mode:(CcCryptorMode)mode
                                   error:(NSError *__autoreleasing *)error
{
    NSData *aesDecryptData = (decoding == CCDecrpytHexStringDecoding) ? self.cc_dataUsingHexEncoding : self.cc_dataUsingBase64Encoding;
    return  [aesDecryptData cc_decrypt3DESUsingkey:key InitializationVector:iv Padding:padding Mode:mode error:error].cc_utf8EncodedString;
}

#pragma mark - CAST
- (NSString *)cc_encryptCAST128UsingEncoding:(CCEncrpytEncodingOptions)encoding
                                      key:(id)key
                     InitializationVector:(id)iv
                                  Padding:(CcCryptorPadding)padding
                                     Mode:(CcCryptorMode)mode
                                    error:(NSError *__autoreleasing *)error
{
    NSData * aesEncryptData = [self.cc_dataUsingUTF8Encoding cc_encryptCAST128Usingkey:key InitializationVector:iv Padding:padding Mode:mode error:error];
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

- (NSString *)cc_decryptCAST128UsingEncoding:(CCDecrpytDecodingOptions)decoding
                                      key:(id)key
                     InitializationVector:(id)iv
                                  Padding:(CcCryptorPadding)padding
                                     Mode:(CcCryptorMode)mode
                                    error:(NSError *__autoreleasing *)error
{
    NSData *aesDecryptData = (decoding == CCDecrpytHexStringDecoding) ? self.cc_dataUsingHexEncoding : self.cc_dataUsingBase64Encoding;
    return  [aesDecryptData cc_decryptCAST128Usingkey:key InitializationVector:iv Padding:padding Mode:mode error:error].cc_utf8EncodedString;
}
#pragma mark - BLOWFISH
- (NSString *)cc_encryptBLOWFISHUsingEncoding:(CCEncrpytEncodingOptions)encoding
                                      key:(id)key
                     InitializationVector:(id)iv
                                  Padding:(CcCryptorPadding)padding
                                     Mode:(CcCryptorMode)mode
                                    error:(NSError *__autoreleasing *)error
{
    NSData * aesEncryptData = [self.cc_dataUsingUTF8Encoding cc_encryptBLOWFISHUsingkey:key InitializationVector:iv Padding:padding Mode:mode error:error];
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

- (NSString *)cc_decryptBLOWFISHUsingEncoding:(CCDecrpytDecodingOptions)decoding
                                      key:(id)key
                     InitializationVector:(id)iv
                                  Padding:(CcCryptorPadding)padding
                                     Mode:(CcCryptorMode)mode
                                    error:(NSError *__autoreleasing *)error
{
    NSData *aesDecryptData = (decoding == CCDecrpytHexStringDecoding) ? self.cc_dataUsingHexEncoding : self.cc_dataUsingBase64Encoding;
    return  [aesDecryptData cc_decryptBLOWFISHUsingkey:key InitializationVector:iv Padding:padding Mode:mode error:error].cc_utf8EncodedString;
}

#pragma mark - RC4
- (NSString *)cc_encryptRC4UsingEncoding:(CCEncrpytEncodingOptions)encoding{
    NSData *rc4Data = self.cc_dataUsingUTF8Encoding.cc_encryptRC4;
    return (encoding == CCEncrpytHexStringEncoding) ? rc4Data.cc_hexEncodedString : [rc4Data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (NSString *)cc_decryptRC4UsingEncoding:(CCDecrpytDecodingOptions)decoding{
    NSData *cr4DecryptData = (decoding == CCDecrpytHexStringDecoding) ? self.cc_dataUsingHexEncoding : self.cc_dataUsingBase64Encoding;
    return cr4DecryptData.cc_decryptRC4.cc_utf8EncodedString;
}


@end

@implementation NSString (Plist)
- (NSArray *)cc_plistArray{
    if (!self) return nil;
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *array = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    if ([array isKindOfClass:[NSMutableArray class]]) return array;
    return nil;
}

- (NSMutableArray *)cc_plistMutableArray{
    if (!self) return nil;
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *array = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    if ([array isKindOfClass:[NSMutableArray class]]) return array;
    return nil;
}


@end

#pragma mark - NSString Drawing Size
@implementation NSString (Drawing)

- (CGSize)cc_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode{
    CGSize result;
    if (!font) {
        font = [UIFont systemFontOfSize:17];
    }
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr  = [NSMutableDictionary dictionary];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
            style.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = style;
        }
            CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attr context:nil];
            
            result = rect.size;
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
        }
    
    return result;
}

- (CGFloat)cc_widthForFont:(UIFont *)font {
    CGSize size = [self cc_sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
    return size.width;
}

- (CGFloat)cc_heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self cc_sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
    return size.height;
}

@end

@implementation NSString (NSNumber)
- (char)charValue {
    return self.cc_numberValue.charValue;
}

- (unsigned char) unsignedCharValue {
    return self.cc_numberValue.unsignedCharValue;
}

- (short) shortValue {
    return self.cc_numberValue.shortValue;
}

- (unsigned short) unsignedShortValue {
    return self.cc_numberValue.unsignedShortValue;
}

- (unsigned int) unsignedIntValue {
    return self.cc_numberValue.unsignedIntValue;
}

- (long) longValue {
    return self.cc_numberValue.longValue;
}

- (unsigned long) unsignedLongValue {
    return self.cc_numberValue.unsignedLongValue;
}

- (unsigned long long) unsignedLongLongValue {
    return self.cc_numberValue.unsignedLongLongValue;
}

- (NSUInteger) unsignedIntegerValue {
    return self.cc_numberValue.unsignedIntegerValue;
}

- (NSNumber *)cc_numberValue {
    return [NSNumber cc_numberWithString:self];
}
@end
