//
//  NSDictionary+Extensions.h
//  CCToolKit
//
//  Created by Harry_L on 2018/6/17.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

/**
 Provide some some common method for `NSDictionary`.
 */
@interface NSDictionary (Convertor)

#pragma mark - Dictionary Convertor

//+ (NSDictionary *)cc_dictionaryWithXML:(id)xml;
///=============================================================================
/// @name Dictionary Convertor
///=============================================================================

/**
 Creates and returns a dictionary from a specified property list data.
 
 @param plist   A property list data whose root object is a dictionary.
 @return A new dictionary created from the plist data, or nil if an error occurs.
 */
+ (nullable NSDictionary *)cc_dictionaryWithPlistData:(NSData *)plist;

/**
 Creates and returns a dictionary from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is a dictionary.
 @return A new dictionary created from the plist string, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
+ (nullable NSDictionary *)cc_dictionaryWithPlistString:(NSString *)plist;

/**
 Serialize the dictionary to a binary property list data.
 
 @return A bplist data, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
- (nullable NSData *)cc_plistData;

/**
 Serialize the dictionary to a xml property list string.
 
 @return A plist xml string, or nil if an error occurs.
 */
- (nullable NSString *)cc_plistString;

/**
 Convert dictionary to json string. return nil if an error occurs.
 */
- (nullable NSString *)cc_jsonStringEncoded;

/**
 Convert dictionary to json string formatted. return nil if an error occurs.
 */
- (nullable NSString *)cc_jsonPrettyStringEncoded;

@end

@interface NSDictionary (Utilities)

/**
 Returns a new array containing the dictionary's keys sorted.
 The keys should be NSString, and they will be sorted ascending.
 
 @return A new array containing the dictionary's keys,
 or an empty array if the dictionary has no entries.
 */
- (NSArray *)cc_allKeysSorted;

/**
 Returns a new array containing the dictionary's values sorted by keys.
 
 The order of the values in the array is defined by keys.
 The keys should be NSString, and they will be sorted ascending.
 
 @return A new array containing the dictionary's values sorted by keys,
 or an empty array if the dictionary has no entries.
 */
- (NSArray *)cc_allValuesSortedByKeys;

/**
 Returns a BOOL value tells if the dictionary has an object for key.
 
 @param key The key.
 */
- (BOOL)cc_containsObjectForKey:(id)key;

/**
 Returns a new dictionary containing the entries for keys.
 If the keys is empty or nil, it just returns an empty dictionary.
 
 @param keys The keys.
 @return The entries for the keys.
 */
- (NSDictionary *)cc_entriesForKeys:(NSArray *)keys;


#pragma mark - Dictionary Value Getter
///=============================================================================
/// @name Dictionary Value Getter
///=============================================================================

- (BOOL)cc_boolValueForKey:(NSString *)key default:(BOOL)def;

- (char)cc_charValueForKey:(NSString *)key default:(char)def;
- (unsigned char)cc_unsignedCharValueForKey:(NSString *)key default:(unsigned char)def;

- (short)cc_shortValueForKey:(NSString *)key default:(short)def;
- (unsigned short)cc_unsignedShortValueForKey:(NSString *)key default:(unsigned short)def;

- (int)cc_intValueForKey:(NSString *)key default:(int)def;
- (unsigned int)cc_unsignedIntValueForKey:(NSString *)key default:(unsigned int)def;

- (long)cc_longValueForKey:(NSString *)key default:(long)def;
- (unsigned long)cc_unsignedLongValueForKey:(NSString *)key default:(unsigned long)def;

- (long long)cc_longLongValueForKey:(NSString *)key default:(long long)def;
- (unsigned long long)cc_unsignedLongLongValueForKey:(NSString *)key default:(unsigned long long)def;

- (float)cc_floatValueForKey:(NSString *)key default:(float)def;
- (double)cc_doubleValueForKey:(NSString *)key default:(double)def;

- (NSInteger)cc_integerValueForKey:(NSString *)key default:(NSInteger)def;
- (NSUInteger)cc_unsignedIntegerValueForKey:(NSString *)key default:(NSUInteger)def;

- (nullable NSNumber *)cc_numberValueForKey:(NSString *)key default:(nullable NSNumber *)def;
- (nullable NSString *)cc_stringValueForKey:(NSString *)key default:(nullable NSString *)def;

@end



/**
 Provide some some common method for `NSMutableDictionary`.
 */
@interface NSMutableDictionary (Utilities)

/**
 Creates and returns a dictionary from a specified property list data.
 
 @param plist   A property list data whose root object is a dictionary.
 @return A new dictionary created from the plist data, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
+ (nullable NSMutableDictionary *)cc_dictionaryWithPlistData:(NSData *)plist;

/**
 Creates and returns a dictionary from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is a dictionary.
 @return A new dictionary created from the plist string, or nil if an error occurs.
 */
+ (nullable NSMutableDictionary *)cc_dictionaryWithPlistString:(NSString *)plist;


/**
 Removes and returns the value associated with a given key.
 
 @param aKey The key for which to return and remove the corresponding value.
 @return The value associated with aKey, or nil if no value is associated with aKey.
 */
- (nullable id)cc_popObjectForKey:(id)aKey;

/**
 Returns a new dictionary containing the entries for keys, and remove these
 entries from reciever. If the keys is empty or nil, it just returns an
 empty dictionary.
 
 @param keys The keys.
 @return The entries for the keys.
 */
- (NSDictionary *)cc_popEntriesForKeys:(NSArray *)keys;

@end

NS_ASSUME_NONNULL_END
