//
//  NSArray+Extensions.h
//  CCToolKit
//
//  Created by Harry_L on 2018/6/9.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Plist)
/**
 Creates and returns an array from a specified property list data.
 
 @param plist   A property list data whose root object is an array.
 @return A new array created from the plist data, or nil if an error occurs.
 */
+ (nullable NSArray *)cc_arrayWithPlistData:(NSData *)plist;

/**
 Creates and returns an array from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is an array.
 @return A new array created from the plist string, or nil if an error occurs.
 */
+ (nullable NSArray *)cc_arrayWithPlistString:(NSString *)plist;

/**
 Serialize the array to a binary property list data.
 
 @return A bplist data, or nil if an error occurs.
 */
- (nullable NSData *)cc_plistData;

/**
 Serialize the array to a xml property list string.
 
 @return A plist xml string, or nil if an error occurs.
 */
- (nullable NSString *)cc_plistString;



@end

@interface NSArray (Json)


/**
 Convert object to json string. return nil if an error occurs.
 NSString/NSNumber/NSDictionary/NSArray
 */
- (nullable NSString *)cc_jsonStringEncoded;

/**
 Convert object to json string formatted. return nil if an error occurs.
 */
- (nullable NSString *)cc_jsonPrettyStringEncoded;

@end

@interface NSArray (Sort)


/**
   return the sort array  with  ascii coding.
 */
- (nullable NSArray *)cc_sortWithASCIICoding;


@end

@interface NSArray (Utilities)

@property (nonatomic,assign) BOOL isControlLog;

/**
 Returns the object located at index, or return nil when out of bounds.
 It's similar to `objectAtIndex:`, but it never throw exception.
 
 @param index The object located at index.
 */
- (nullable id)cc_objectOrNilAtIndex:(NSUInteger)index;

/**
 Returns the object located at a random index.
 
 @return The object in the array with a random index value.
 If the array is empty, returns nil.
 */
- (nullable id)cc_randomObject;


@end



@interface NSMutableArray (Utilities)

/**
 Creates and returns an array from a specified property list data.
 
 @param plist   A property list data whose root object is an array.
 @return A new array created from the plist data, or nil if an error occurs.
 */
+ (nullable NSMutableArray *)cc_arrayWithPlistData:(NSData *)plist;

/**
 Creates and returns an array from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is an array.
 @return A new array created from the plist string, or nil if an error occurs.
 */
+ (nullable NSMutableArray *)cc_arrayWithPlistString:(NSString *)plist;
/**
 Adds the objects contained in another given array to the beginnin of the receiving
 array's content.
 
 @param objects An array of objects to add to the beginning of the receiving array's
 content. If the objects is empty or nil, this method has no effect.
 */
- (void)cc_prependObjects:(NSArray *)objects;

/**
 Adds the objects contained in another given array at the index of the receiving
 array's content.
 
 @param objects An array of objects to add to the receiving array's
 content. If the objects is empty or nil, this method has no effect.
 
 @param index The index in the array at which to insert objects. This value must
 not be greater than the count of elements in the array. Raises an
 NSRangeException if index is greater than the number of elements in the array.
 */
- (void)cc_insertObjects:(NSArray *)objects atIndex:(NSUInteger)index;

/**
 Reverse the index of object in this array.
 Example: Before @[ @1, @2, @3 ], After @[ @3, @2, @1 ].
 */
- (void)cc_reverse;

/**
 Sort the object in this array randomly.
 */
- (void)cc_shuffle;

@end
