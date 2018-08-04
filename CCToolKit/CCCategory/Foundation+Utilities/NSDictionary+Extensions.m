//
//  NSDictionary+Extensions.m
//  CCToolKit
//
//  Created by Harry_L on 2018/6/17.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import "NSDictionary+Extensions.h"
#import "NSData+Extensions.h"
#import "NSString+Extensions.h"
#import "CCXMLDictionaryParser.h"
@implementation NSDictionary (Convertor)

+ (NSDictionary *)cc_dictionaryWithXML:(id)xml {
    CCXMLDictionaryParser *parser = nil;
    if ([xml isKindOfClass:[NSString class]]) {
        parser = [[CCXMLDictionaryParser alloc] initWithString:xml];
    } else if ([xml isKindOfClass:[NSData class]]) {
        parser = [[CCXMLDictionaryParser alloc] initWithData:xml];
    }
    return parser.root;
}


+ (NSDictionary *)cc_dictionaryWithPlistData:(NSData *)plist
{
    if (!plist) {return nil;}
    NSDictionary *dictionary =  [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListImmutable format:NULL error:NULL];
    if ([dictionary isKindOfClass:[NSDictionary class]]) return dictionary;
    return nil;
}

+ (NSDictionary *)cc_dictionaryWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData* data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self cc_dictionaryWithPlistData:data];
}

- (NSData *)cc_plistData {
    return [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:kNilOptions error:NULL];
}

- (NSString *)cc_plistString {
    NSData *xmlData = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListXMLFormat_v1_0 options:kNilOptions error:NULL];
    if (xmlData) return xmlData.cc_utf8EncodedString;
    return nil;
}

- (NSString *)cc_jsonStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}

- (NSString *)cc_jsonPrettyStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}


@end

@implementation NSDictionary (Utilities)

- (NSArray *)cc_allKeysSorted {
    return [[self allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (NSArray *)cc_allValuesSortedByKeys {
    NSArray *sortedKeys = [self cc_allKeysSorted];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (id key in sortedKeys) {
        [arr addObject:self[key]];
    }
    return arr;
}

- (BOOL)cc_containsObjectForKey:(id)key {
    if (!key) return NO;
    if (![self.allKeys containsObject:key])  return false;
    return self[key] != nil;
}

- (NSDictionary *)cc_entriesForKeys:(NSArray *)keys {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    for (id key in keys) {
        id value = self[key];
        if (value) dic[key] = value;
    }
    return dic;
}

/// Get a number value from 'id'.
static NSNumber *NSNumberFromID(id value) {
    static NSCharacterSet *dot;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dot = [NSCharacterSet characterSetWithRange:NSMakeRange('.', 1)];
    });
    if (!value || value == [NSNull null]) return nil;
    if ([value isKindOfClass:[NSNumber class]]) return value;
    if ([value isKindOfClass:[NSString class]]) {
        NSString *lower = ((NSString *)value).lowercaseString;
        if ([lower isEqualToString:@"true"] || [lower isEqualToString:@"yes"]) return @(YES);
        if ([lower isEqualToString:@"false"] || [lower isEqualToString:@"no"]) return @(NO);
        if ([lower isEqualToString:@"nil"] || [lower isEqualToString:@"null"]) return nil;
        if ([(NSString *)value rangeOfCharacterFromSet:dot].location != NSNotFound) {
            return @(((NSString *)value).doubleValue);
        } else {
            return @(((NSString *)value).longLongValue);
        }
    }
    return nil;
}

#define RETURN_VALUE(_type_)                                                     \
if (!key) return def;                                                            \
if (![self cc_containsObjectForKey:key]) return def;                              \
id value = self[key];                                                            \
if (!value || value == [NSNull null]) return def;                                \
if ([value isKindOfClass:[NSNumber class]]) return ((NSNumber *)value)._type_;   \
if ([value isKindOfClass:[NSString class]]) return NSNumberFromID(value)._type_; \
return def;


- (BOOL)cc_boolValueForKey:(NSString *)key default:(BOOL)def {

    RETURN_VALUE(boolValue);
}

- (char)cc_charValueForKey:(NSString *)key default:(char)def {
    RETURN_VALUE(charValue);
}

- (unsigned char)cc_unsignedCharValueForKey:(NSString *)key default:(unsigned char)def {
    RETURN_VALUE(unsignedCharValue);
}

- (short)cc_shortValueForKey:(NSString *)key default:(short)def {
    RETURN_VALUE(shortValue);
}

- (unsigned short)cc_unsignedShortValueForKey:(NSString *)key default:(unsigned short)def {
    RETURN_VALUE(unsignedShortValue);
}

- (int)cc_intValueForKey:(NSString *)key default:(int)def {
    RETURN_VALUE(intValue);
}

- (unsigned int)cc_unsignedIntValueForKey:(NSString *)key default:(unsigned int)def {
    RETURN_VALUE(unsignedIntValue);
}

- (long)cc_longValueForKey:(NSString *)key default:(long)def {
    RETURN_VALUE(longValue);
}

- (unsigned long)cc_unsignedLongValueForKey:(NSString *)key default:(unsigned long)def {
    RETURN_VALUE(unsignedLongValue);
}

- (long long)cc_longLongValueForKey:(NSString *)key default:(long long)def {
    RETURN_VALUE(longLongValue);
}

- (unsigned long long)cc_unsignedLongLongValueForKey:(NSString *)key default:(unsigned long long)def {
    RETURN_VALUE(unsignedLongLongValue);
}

- (float)cc_floatValueForKey:(NSString *)key default:(float)def {
    RETURN_VALUE(floatValue);
}

- (double)cc_doubleValueForKey:(NSString *)key default:(double)def {
    RETURN_VALUE(doubleValue);
}

- (NSInteger)cc_integerValueForKey:(NSString *)key default:(NSInteger)def {
    RETURN_VALUE(integerValue);
}

- (NSUInteger)cc_unsignedIntegerValueForKey:(NSString *)key default:(NSUInteger)def {
    RETURN_VALUE(unsignedIntegerValue);
}

- (NSNumber *)cc_numberValueForKey:(NSString *)key default:(NSNumber *)def {
    if (!key) return def;
    if (![self cc_containsObjectForKey:key]) return def;
    id value = self[key];
    if (!value || value == [NSNull null]) return def;
    if ([value isKindOfClass:[NSNumber class]]) return value;
    if ([value isKindOfClass:[NSString class]]) return NSNumberFromID(value);
    return def;
}

- (NSString *)cc_stringValueForKey:(NSString *)key default:(NSString *)def {
    if (!key) return def;
    if (![self cc_containsObjectForKey:key]) return def;
    id value = self[key];
    if (!value || value == [NSNull null]) return def;
    if ([value isKindOfClass:[NSString class]]) return value;
    if ([value isKindOfClass:[NSNumber class]]) return ((NSNumber *)value).description;
    return def;
}

- (NSArray *)cc_arrayValueForKey:(NSString *)key default:(NSArray *)def{
    if (!key) return def;
    if (![self cc_containsObjectForKey:key]) return def;
    id value = self[key];
    if (!value || value == [NSNull null]) return def;
    if ([value isKindOfClass:[NSArray class]]) return value;
    if ([value isKindOfClass:[NSString class]]){
        id json = [[value cc_jsonText] cc_jsonValueDecoded];
        if (json && [json isKindOfClass:[NSArray class]]) {
            return json;
        }
    }
    return def;
}

@end

@implementation NSMutableDictionary (Utilities)

+ (NSMutableDictionary *)cc_dictionaryWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSMutableDictionary *dictionary = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    if ([dictionary isKindOfClass:[NSMutableDictionary class]]) return dictionary;
    return nil;
}

+ (NSMutableDictionary *)cc_dictionaryWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData* data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self cc_dictionaryWithPlistData:data];
}

- (id)cc_popObjectForKey:(id)aKey {
    if (!aKey) return nil;
    id value = self[aKey];
    [self removeObjectForKey:aKey];
    return value;
}

- (NSDictionary *)cc_popEntriesForKeys:(NSArray *)keys {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    for (id key in keys) {
        id value = self[key];
        if (value) {
            [self removeObjectForKey:key];
            dic[key] = value;
        }
    }
    return dic;
}

@end
