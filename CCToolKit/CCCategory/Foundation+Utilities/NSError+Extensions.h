//
//  NSError+Extensions.h
//  CCToolKit
//
//  Created by Harry_L on 2017/5/22.
//  Copyright © 2017年 Harry_L. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSError (Init)

+(instancetype)errorWithDomain:(NSErrorDomain)domain;

+(instancetype)errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code;

@end


