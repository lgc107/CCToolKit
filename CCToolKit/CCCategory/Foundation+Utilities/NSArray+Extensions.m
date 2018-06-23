//
//  NSArray+Extensions.m
//  CCToolKit
//
//  Created by Harry_L on 2018/6/9.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import "NSArray+Extensions.h"
#import <objc/runtime.h>
#import "NSData+Extensions.h"
@implementation NSArray (Plist)

+ (NSArray *)cc_arrayWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListImmutable format:NULL error:NULL];
    if ([array isKindOfClass:[NSArray class]]) return array;
    return nil;
}

+ (NSArray *)cc_arrayWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData* data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self cc_arrayWithPlistData:data];
}

- (NSData *)cc_plistData {
    return [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:kNilOptions error:NULL];
}

- (NSString *)cc_plistString{
    NSData *xmlData = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListXMLFormat_v1_0 options:kNilOptions error:NULL];
    if (xmlData) return xmlData.cc_utf8EncodedString;
    return nil;
}
@end

@implementation NSArray (Json)


- (NSString *)cc_jsonStringEncoded{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}

- (NSString *)cc_jsonPrettyStringEncoded{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}

@end

@implementation NSArray (Sort)

- (NSArray *)cc_sortWithASCIICoding{
    NSStringCompareOptions comparisonOptions =NSCaseInsensitiveSearch|NSNumericSearch|
    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        NSRange range =NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    NSArray *sortResult = [self sortedArrayUsingComparator:sort];
    return sortResult;
}

@end


static  NSString * const kIsControllLog = @"isControllLog";
static  BOOL _isControlLog;

@implementation NSArray (Utilities)

+ (NSMutableArray *)arrayWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSMutableArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    if ([array isKindOfClass:[NSMutableArray class]]) return array;
    return nil;
}

+ (NSMutableArray *)arrayWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData* data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self arrayWithPlistData:data];
}


- (void)setIsControlLog:(BOOL)isControlLog{
    [self willChangeValueForKey:kIsControllLog];
    _isControlLog = isControlLog;
    objc_setAssociatedObject(self, @selector(isControlLog),
                             @(isControlLog),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kIsControllLog];
}

-(BOOL)isControlLog
{
    NSNumber *number = objc_getAssociatedObject(self, &kIsControllLog);
    return  [number boolValue];
}




- (NSString*)descriptionWithLocale:(id)locale {
    
    if (_isControlLog) {
        NSMutableString *str = [NSMutableString stringWithString:@"(\n"];
        
        [self enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL*stop) {
            
            [str appendFormat:@"\t%@,\n", obj];
            
        }];
        
        [str appendString:@")"];
        
        return str;
    }
   return  [super description];
    
}

- (id)cc_randomObject {
    if (self.count) {
        return self[arc4random_uniform((u_int32_t)self.count)];
    }
    return nil;
}

- (id)cc_objectOrNilAtIndex:(NSUInteger)index {
    return index < self.count ? self[index] : nil;
}

@end


@implementation NSMutableArray (Utilities)
+ (NSMutableArray *)cc_arrayWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSMutableArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    if ([array isKindOfClass:[NSMutableArray class]]) return array;
    return nil;
}

+ (NSMutableArray *)cc_arrayWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData* data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self arrayWithPlistData:data];
}

- (void)cc_prependObjects:(NSArray *)objects {
    if (!objects) return;
    NSUInteger i = 0;
    for (id obj in objects) {
        [self insertObject:obj atIndex:i++];
    }
}

- (void)cc_insertObjects:(NSArray *)objects atIndex:(NSUInteger)index {
    NSUInteger i = index;
    for (id obj in objects) {
        [self insertObject:obj atIndex:i++];
    }
}

- (void)cc_reverse {
    NSUInteger count = self.count;
    int mid = floor(count / 2.0);
    for (NSUInteger i = 0; i < mid; i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:(count - (i + 1))];
    }
}

- (void)cc_shuffle {
    for (NSUInteger i = self.count; i > 1; i--) {
        [self exchangeObjectAtIndex:(i - 1)
                  withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
}

@end
