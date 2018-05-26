//
//  CCVersion.m
//  CCToolKit
//
//  Created by Harry_L on 2018/5/11.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import "CCVersion.h"

static NSString *const kBundleShortVersionIdentifier = @"CFBundleShortVersionString"; // 获取版本号时所使用的关键字
static NSString *const kBundleVerionIdentifier = @"CFBundleVersion";



@implementation CCVersion
{
    NSString *versionString;
}
@synthesize versionComponents;


#pragma mark - Init
+(instancetype)currentClientVersion{
    static CCVersion *currentClientVersion = nil;
    static dispatch_once_t clientOnceToken;
    if (!currentClientVersion) {
        NSString *clientVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:kBundleShortVersionIdentifier];
        dispatch_once(&clientOnceToken, ^{//线程安全
            currentClientVersion = [[CCVersion alloc] initWithString:clientVersion];
        });
    }
    return currentClientVersion;
}



+(instancetype)versionWithString:(NSString *)aString{
    return  [[self alloc]initWithString:aString];
}

- (instancetype)initWithString:(NSString *)aString{
    self = [super init];
    if (self) {
        NSArray <NSString *>*intComponents = [aString componentsSeparatedByString:@"."];
        NSMutableString *tmpString = [NSMutableString string];
        [intComponents enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger intValue = obj.intValue;
            [tmpString appendFormat:@"%ld.",(long)intValue];
        }];
        if ([tmpString isEqualToString:@""]) {versionString = @"0.0";}
        else{
            while ([tmpString hasSuffix:@".0."]) {
                 [tmpString deleteCharactersInRange:NSMakeRange(tmpString.length-@"0.".length, @"0.".length)];
            }
            if ([tmpString hasSuffix:@"."]) {
                // 应该是所有的都回进入这个if
                versionString = [tmpString substringToIndex:tmpString.length-1];
            }
            versionComponents = [versionString componentsSeparatedByString:@"."];
        }
    }
    return self;
}

#pragma mark -- property Get Method
-(NSString *)stringValue{
    return [versionString copy];
}

#pragma mark -- Compare
-(NSComparisonResult)compare:(CCVersion *)aVersion{
    NSArray *againstComponents = aVersion.versionComponents;
    
    for (NSInteger i = 0; i < versionComponents.count; i++) {
        if ( againstComponents.count > i ) {
            if ( [versionComponents[i] integerValue] > [againstComponents[i] integerValue] ) {
                return NSOrderedDescending;
            }else if ( [versionComponents[i] integerValue] < [againstComponents[i] integerValue] ){
                return NSOrderedAscending;
            }
        }else{
            return NSOrderedDescending;
        }
    }
    if ( againstComponents.count > versionComponents.count ) {
        return NSOrderedAscending;
    }else{
        return NSOrderedSame;
    }
}

-(NSString *)description{
    return [NSString stringWithFormat:@"CCVersion -> address:%p,versionString:%@",self,self.stringValue];
}


@end



