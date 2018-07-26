//
//  CCKeyChain.h
//  CCToolKit
//
//  Created by 李劲成 on 2018/7/26.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCKeyChain : NSObject

+(void)save:(NSString *)service data:(id)data;

+(NSMutableDictionary *)getKeychainQuery:(NSString *)service;

+(id)load:(NSString *)service;

+(void)deletekeychain:(NSDictionary *)keychainQuery;
@end
