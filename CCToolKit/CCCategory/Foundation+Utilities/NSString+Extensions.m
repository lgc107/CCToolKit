//
//  NSString+Extensions.m
//  CCToolKit
//
//  Created by Harry_L on 2017/5/18.
//  Copyright © 2017年 Harry_L. All rights reserved.
//


#import "NSString+Extensions.h"
#import "NSNumber+Extensions.h"
#import "NSDate+Extensions.h"

@implementation NSString (Utilities)

+ (NSString *)cc_uuidString{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidString;
}

#pragma mark - Encoding & Decoding

- (const char *)cc_asciiValue{
   return  [self cStringUsingEncoding:NSASCIIStringEncoding];
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
- (NSString *)cc_convertToPinyinWithCombiningMarks:(BOOL)isCombiningMarks
{
    //将NSString装换成NSMutableString
    NSMutableString *pinyin = [self mutableCopy];
    //将汉字转换为拼音(带音标)
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    //去掉拼音的音标
    if (isCombiningMarks) {
            CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    }

    //返回最近结果
    return pinyin;
}

- (NSString *)cc_stringByReversed{
    uint64_t  i = 0;
    uint64_t  j = self.length - 1;
    //  unichar characters[self.length];
    unichar *characters = malloc(sizeof([self characterAtIndex:0]) * self.length);
    while (i < j) {
        characters[j] = [self characterAtIndex:(NSInteger)i];
        characters[i] = [self characterAtIndex:(NSInteger)j];
        i ++;
        j --;
    }
    if(i == j)
        characters[i] = [self characterAtIndex:(NSInteger)i];
    return [NSString stringWithCharacters:characters length:self.length];
}
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


@implementation NSString (Compare)

//添加两个字符串比较的方法
- (NSComparisonResult)compareAgainst:(NSString *)anString {
    return -[self compare:anString];
}

@end


@implementation NSString (Regular)

- (BOOL)cc_isMobilePhoneNumberRegex{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    return [self cc_checkWithRegularExpression:@"^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199|(147))\\d{8}$"];
}
//结构和形式
//1．号码的结构
//　  公民身份号码是特征组合码，由十七位数字本体码和一位校验码组成。排列顺序从左至右依次为：六位数字地址码，八位数字出生日期码，三位数字顺序码和一位数字校验码。
//2．地址码
//　  表示编码对象常住户口所在县（市、旗、区）的行政区划代码，按GB/T2260的规定执行。
//3．出生日期码
//　  表示编码对象出生的年、月、日，按GB/T7408的规定执行，年、月、日代码之间不用分隔符。
//4．顺序码
//　  表示在同一地址码所标识的区域范围内，对同年、同月、同日出生的人编定的顺序号，顺序码的奇数分配给男性，偶数分配给女性。
//5．校验码
//　 根据前面十七位数字码，按照ISO7064:1983.MOD11-2校验码计算出来的检验码。

- (BOOL)cc_isIdentityCardNumberRegex{
    //1.校验字符串长度
    NSString *identityCardNumber = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ( !identityCardNumber.cc_isNotBlank || identityCardNumber.length != 18) {
        return false;
    }
    //2.校验地址码（省份）
    NSArray *provinceIds = @[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    if (![provinceIds containsObject:[identityCardNumber substringToIndex:2]]) {
        return false;
    }
    //3.校验生日日期
    NSInteger identityCardYear = [identityCardNumber substringWithRange:NSMakeRange(6,4)].integerValue;
    if ([NSDate date].year <= identityCardYear || identityCardYear < 1800) {
        return false;
    }
    
    NSRegularExpression * regularExpression;
    if ((identityCardYear % 400 == 0) || ((identityCardYear % 100 != 0) && (identityCardYear % 4 == 0))) {
       
       regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                 options:NSRegularExpressionCaseInsensitive
                                                                   error:nil];//测试出生日期的合法性
    }else {
        regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                 options:NSRegularExpressionCaseInsensitive
                                                                   error:nil];//测试出生日期的合法性
    }
    NSInteger numberofMatch = [regularExpression numberOfMatchesInString:identityCardNumber
                                                       options:NSMatchingReportProgress
                                                         range:NSMakeRange(0, identityCardNumber.length)];
    
    if(numberofMatch >0) {
        int S = ([identityCardNumber substringWithRange:NSMakeRange(0,1)].intValue + [identityCardNumber substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([identityCardNumber substringWithRange:NSMakeRange(1,1)].intValue + [identityCardNumber substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([identityCardNumber substringWithRange:NSMakeRange(2,1)].intValue + [identityCardNumber substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([identityCardNumber substringWithRange:NSMakeRange(3,1)].intValue + [identityCardNumber substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([identityCardNumber substringWithRange:NSMakeRange(4,1)].intValue + [identityCardNumber substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([identityCardNumber substringWithRange:NSMakeRange(5,1)].intValue + [identityCardNumber substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([identityCardNumber substringWithRange:NSMakeRange(6,1)].intValue + [identityCardNumber substringWithRange:NSMakeRange(16,1)].intValue) *2 + [identityCardNumber substringWithRange:NSMakeRange(7,1)].intValue *1 + [identityCardNumber substringWithRange:NSMakeRange(8,1)].intValue *6 + [identityCardNumber substringWithRange:NSMakeRange(9,1)].intValue *3;
        int Y = S %11;
        NSString *M =@"F";
        NSString *JYM =@"10X98765432";
        M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
        if ([M isEqualToString:[identityCardNumber substringWithRange:NSMakeRange(17,1)]]) {
            return YES;// 检测ID的校验位
        }else {
            return NO;
        }
        
    }else {
        return NO;
    }
    return false;
    
}

- (BOOL)cc_isValidEmailAddress{
    return [self cc_checkWithRegularExpression:@"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\\\.[A-Za-z]{2,4}"];
}


- (BOOL)cc_isChinese{
    return [self cc_checkWithRegularExpression:@"^[\\u4e00-\\u9fa5]+$"];
}


- (BOOL)cc_isNumber{
    return [self cc_checkWithRegularExpression:@"[0-9]*"];
}

- (BOOL)cc_isEnglishLetter{
    return [self cc_checkWithRegularExpression:@"[a-zA-Z]*"];
}



/**
 @brief     是否符合最小长度、最长长度，是否包含中文,首字母是否可以为数字
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)cc_isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal
{
    //  [\\u4e00-\\u9fa5A-Za-z0-9_]{4,20}
    NSString *hanzi = containChinese ? @"\\u4e00-\\u9fa5" : @"";
    NSString *first = firstCannotBeDigtal ? @"^[a-zA-Z_]" : @"";
    
    NSString *regex = [NSString stringWithFormat:@"%@[%@A-Za-z0-9_]{%d,%d}", first, hanzi, (int)(minLenth-1), (int)(maxLenth-1)];
    return [self cc_checkWithRegularExpression:regex];

}
/**
 @brief     是否符合最小长度、最长长度，是否包含中文,数字，字母，其他字符，首字母是否可以为数字
 @param     minLenth 最小长度
 @param     maxLenth 最长长度
 @param     containChinese 是否包含中文
 @param     containDigtal   包含数字
 @param     containLetter   包含字母
 @param     containOtherCharacter   其他字符
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 
 */
- (BOOL)cc_isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
              containDigtal:(BOOL)containDigtal
              containLetter:(BOOL)containLetter
      containOtherCharacter:(NSString *)containOtherCharacter
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal
{
    NSString *hanzi = containChinese ? @"\\u4e00-\\u9fa5" : @"";
    NSString *first = firstCannotBeDigtal ? @"^[a-zA-Z_]" : @"";
    NSString *lengthRegex = [NSString stringWithFormat:@"(?=^.{%@,%@}$)", @(minLenth), @(maxLenth)];
    NSString *digtalRegex = containDigtal ? @"(?=(.*\\\\d.*){1})" : @"";
    NSString *letterRegex = containLetter ? @"(?=(.*[a-zA-Z].*){1})" : @"";
    NSString *characterRegex = [NSString stringWithFormat:@"(?:%@[%@A-Za-z0-9%@]+)", first, hanzi, containOtherCharacter ? containOtherCharacter : @""];
    NSString *regex = [NSString stringWithFormat:@"%@%@%@%@", lengthRegex, digtalRegex, letterRegex, characterRegex];
    return [self cc_checkWithRegularExpression:regex];
}


- (BOOL)cc_checkWithRegularExpression:(NSString *)expression{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:expression];
    return [predicate evaluateWithObject:self];
}



@end
