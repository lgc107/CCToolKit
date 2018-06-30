//
//  NSHTTPCookieStorage+Extensions.m
//  CCToolKit
//
//  Created by Harry_L on 2018/6/30.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import "NSHTTPCookieStorage+Extensions.h"
#import "NSHTTPCookie+Extensions.h"
@implementation NSHTTPCookieStorage (Extensions)
+ (NSString *)cc_cookieJavascriptString{
    NSMutableString *script = [NSMutableString string];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        // Skip cookies that will break our script
        if ([cookie.value rangeOfString:@"'"].location != NSNotFound) {
            continue;
        }
        // Create a line that appends this cookie to the web view's document's cookies
        [script appendFormat:@"document.cookie='%@'; \n", cookie.cc_javascriptString];
    }
    return script;
}
@end
