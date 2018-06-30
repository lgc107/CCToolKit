//
//  NSHTTPCookie+Extensions.m
//  CCToolKit
//
//  Created by Harry_L on 2018/6/17.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import "NSHTTPCookie+Extensions.h"

@implementation NSHTTPCookie (Extensions)



- (NSString *)cc_javascriptString{
    NSString *string = [NSString stringWithFormat:@"%@=%@;domain=%@;path=%@",
                        self.name,
                        self.value,
                        self.domain,
                        self.path ?: @"/"];
    if (self.secure) {
        string = [string stringByAppendingString:@";secure=true"];
    }
    return string;
}

@end
