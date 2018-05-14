//
//  CCError.h
//  CCToolKit
//
//  Created by Harry_L on 2018/5/11.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCError : NSError

+(instancetype)errorWithDomain:(NSErrorDomain)domain;

+(instancetype)errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code;

@end
