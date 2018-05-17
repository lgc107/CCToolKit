//
//  CCVersion.h
//  CCToolKit
//
//  Created by Harry_L on 2018/5/11.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CCVersion : NSObject


/**
  Returns the shared  object With Current Client Version.
 */
+(instancetype)currentClientVersion;
/**
  Returns the Version object With version String
 */
+ (instancetype)versionWithString:(NSString*)aString;

- (instancetype)initWithString:(NSString*)aString;


/**
 The object's localString Value.
 */
@property (nonatomic,copy,readonly) NSString *stringValue;

/**
   The object's localString Components.
 */
@property (nonatomic,copy,readonly) NSArray *versionComponents;



/**
 
 Returns a comparison result value that indicates the sort order of two objects.
 
 */
- (NSComparisonResult)compare:(CCVersion *)aVersion;

@end




