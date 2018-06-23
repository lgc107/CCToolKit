//
//  NSError+Extensions.m
//  CCToolKit
//
//  Created by Harry_L on 2017/5/22.
//  Copyright © 2017年 Harry_L. All rights reserved.
//

#import "NSError+Extensions.h"



@implementation NSError (Init)

+(instancetype)errorWithDomain:(NSErrorDomain)domain{
    
    return [NSError errorWithDomain:domain code:0];
}

+(instancetype)errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code{

    return [NSError errorWithDomain:domain code:code userInfo:nil];
}

-(NSString *)description{
    return [@"CCError_Reason:" stringByAppendingString:self.domain];
}

@end



