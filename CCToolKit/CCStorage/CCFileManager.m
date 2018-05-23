//
//  CCFileManager.m
//  Test
//
//  Created by Harry_L on 2018/5/16.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import "CCFileManager.h"

#import <UIKit/UIKit.h>
@implementation CCFileManager
{
    NSString *_homePath;
    NSString *_documentPath;
    NSString *_libraryPath;
    NSString *_cachePath;
    NSString *_tmpPath;
}

+(instancetype)shareManager{
    
    static CCFileManager *fileManager = nil;
    static dispatch_once_t fileOnceToken;
    if (!fileManager) {
        dispatch_once(&fileOnceToken, ^{//线程安全
            fileManager = [[CCFileManager alloc] init];
        });
    }
    return fileManager;
}

-(NSString *)homePath{
    if (!_homePath) {
        _homePath = NSHomeDirectory();
    }
    return _homePath;
}

-(NSString *)documentPath{
    if (!_documentPath) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _documentPath = paths.firstObject;
    }
    return _documentPath;
}

-(NSString *)libraryPath{
    if (!_libraryPath) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        _libraryPath = paths.firstObject;
    }
    return _libraryPath;
}

- (NSString *)cachePath{
    if (!_cachePath) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _cachePath = paths.firstObject;
    }
    return _cachePath;
}

-(NSString *)tmpPath{
    if (!_tmpPath) {
        _tmpPath = NSTemporaryDirectory();
    }
    return _tmpPath;
}

+(NSString *)pathForFileName:(NSString *)name inDircetoryType:(DircetoryType)type{
    
    NSAssert(name != nil, @"Invalid path. Path cannot be nil.");
    //    NSAssert(![name isEqualToString:@""], @"Invalid path. Path cannot be empty string.");
    
    switch (type) {
        case Home:
            return [[CCFileManager shareManager].homePath stringByAppendingPathComponent:name];
            break;
        case Document:
            return [[CCFileManager shareManager].documentPath stringByAppendingPathComponent:name];
            break;
        case Library:
            return [[CCFileManager shareManager].libraryPath stringByAppendingPathComponent:name];
            break;
        case Caches:
            return [[CCFileManager shareManager].cachePath stringByAppendingPathComponent:name];
            break;
        case Tmp:
            return [[CCFileManager shareManager].tmpPath stringByAppendingPathComponent:name];
            break;
        default:
            break;
    }
}

+(BOOL)createFileAtPath:(NSString *)fullPath{
    return  [self createFileAtPath:fullPath withIntermediateDirectories:true OverWrite:false attributes:nil Contents:nil error:nil];
}

+(BOOL)createFileAtPath:(NSString *)fullPath OverWrite:(BOOL)overwrite {
    return  [self createFileAtPath:fullPath withIntermediateDirectories:true OverWrite:overwrite attributes:nil Contents:nil error:nil];
}

+(BOOL)createFileAtPath:(NSString *)fullPath OverWrite:(BOOL)overwrite Contents:(id)contents error:(NSError **)error{
    return  [self createFileAtPath:fullPath withIntermediateDirectories:true OverWrite:overwrite attributes:nil Contents:contents error:error];
}

+(BOOL)createFileAtPath:(NSString *)fullPath IntermediateDirectories:(BOOL)intermediateDirectories attributes:(NSDictionary<NSFileAttributeKey, id> *)attributes error:(NSError * _Nullable *)error{
    return  [self createFileAtPath:fullPath withIntermediateDirectories:intermediateDirectories OverWrite:false attributes:attributes Contents:nil error:error];
}

+(BOOL)createFileAtPath:(NSString *)fullPath withIntermediateDirectories:(BOOL)intermediateDirectories OverWrite:(BOOL)overwrite attributes:(NSDictionary<NSFileAttributeKey, id> *)attributes Contents:(id)contents error:(NSError * _Nullable *)error{
    if (![self fileExistsAtFullPath:fullPath]) {
        BOOL created = [[NSFileManager defaultManager]createDirectoryAtPath:fullPath withIntermediateDirectories:true attributes:attributes error:error];
        if (created && contents != nil) {
            [self writeFileAtPath:fullPath content:contents error:error];
        }
        return (created && [self isNotError:error]);
    }
    else if (overwrite && [self removeItemAtPath:fullPath error:error] && [self isNotError:error]){
        BOOL created = [[NSFileManager defaultManager]createDirectoryAtPath:fullPath withIntermediateDirectories:true attributes:attributes error:error];
        if (created && contents != nil) {
            [self writeFileAtPath:fullPath content:contents error:error];
        }
        return (created && [self isNotError:error]);
    }
    return  false;
}

+(BOOL)fileExistsAtFullPath:(NSString *)fullPath{
    return [[NSFileManager defaultManager]fileExistsAtPath:fullPath];
}

+(BOOL)fileExistsAtDocumentPath:(NSString *)fileName{
    return [[NSFileManager defaultManager]fileExistsAtPath:[self pathForFileName:fileName inDircetoryType:Document]];
}

+ (BOOL)removeItemAtPath:(NSString *)path {
    return  [self removeItemAtPath:path error:nil];
}

+ (BOOL)removeItemAtPath:(NSString *)path error:(NSError * _Nullable *)error{
    return [[NSFileManager defaultManager] removeItemAtPath:path error:error];
}

+(BOOL)writeFileAtPath:(NSString *)path content:(NSObject *)content
{
    return [self writeFileAtPath:path content:content error:nil];
}


+(BOOL)writeFileAtPath:(NSString *)path content:(id)content error:(NSError **)error
{
    if(content == nil)
    {
        [NSException raise:@"Invalid content" format:@"content can't be nil."];
    }
    
    
    [self createFileAtPath:path withIntermediateDirectories:true OverWrite:false attributes:nil Contents:nil error:error];
    
    
    if([content isKindOfClass:[NSMutableArray class]])
    {
        [((NSMutableArray *)content) writeToFile:path atomically:YES];
    }
    else if([content isKindOfClass:[NSArray class]])
    {
        [((NSArray *)content) writeToFile:path atomically:YES];
    }
    else if([content isKindOfClass:[NSMutableData class]])
    {
        [((NSMutableData *)content) writeToFile:path atomically:YES];
    }
    else if([content isKindOfClass:[NSData class]])
    {
        [((NSData *)content) writeToFile:path atomically:YES];
    }
    else if([content isKindOfClass:[NSMutableDictionary class]])
    {
        [((NSMutableDictionary *)content) writeToFile:path atomically:YES];
    }
    else if([content isKindOfClass:[NSDictionary class]])
    {
        [((NSDictionary *)content) writeToFile:path atomically:YES];
    }
    else if([content isKindOfClass:[NSJSONSerialization class]])
    {
        [((NSDictionary *)content) writeToFile:path atomically:YES];
    }
    else if([content isKindOfClass:[NSMutableString class]])
    {
        [[((NSString *)content) dataUsingEncoding:NSUTF8StringEncoding] writeToFile:path atomically:YES];
    }
    else if([content isKindOfClass:[NSString class]])
    {
        [[((NSString *)content) dataUsingEncoding:NSUTF8StringEncoding] writeToFile:path atomically:YES];
    }
    else if([content isKindOfClass:[UIImage class]])
    {
        [UIImagePNGRepresentation((UIImage *)content) writeToFile:path atomically:YES];
    }
    else if([content isKindOfClass:[UIImageView class]])
    {
        return [self writeFileAtPath:path content:((UIImageView *)content).image error:error];
    }
    else if([content conformsToProtocol:@protocol(NSCoding)])
    {
        [NSKeyedArchiver archiveRootObject:content toFile:path];
    }
    else {
        [NSException raise:@"Invalid content type" format:@"content of type %@ is not handled.", NSStringFromClass([content class])];
        
        return NO;
    }
    
    return YES;
}


+(BOOL)isNotError:(NSError **)error
{
    //the first check prevents EXC_BAD_ACCESS error in case methods are called passing nil to error argument
    //the second check prevents that the methods returns always NO just because the error pointer exists (so the first condition returns YES)
    return ((error == nil) || ((*error) == nil));
}



@end
