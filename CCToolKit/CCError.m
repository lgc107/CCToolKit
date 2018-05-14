//
//  CCError.m
//  CCToolKit
//
//  Created by Harry_L on 2018/5/11.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import "CCError.h"

@implementation CCError

+(instancetype)errorWithDomain:(NSErrorDomain)domain{
   
    return [CCError errorWithDomain:domain code:0];
}

+(instancetype)errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code{
     NSLog(@"%@",domain);
   return [CCError errorWithDomain:domain code:code userInfo:nil];
}

@end
