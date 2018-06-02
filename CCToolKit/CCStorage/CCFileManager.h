//
//  CCFileManager.h
//  Test
//
//  Created by Harry_L on 2018/5/16.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    Home,
    Document,
    Library,
    Caches,
    Tmp
} DircetoryType;

@interface CCFileManager : NSObject
NS_ASSUME_NONNULL_BEGIN
+(instancetype)shareManager;

@property (nonatomic,readonly) NSString *homePath;

@property (nonatomic,readonly) NSString *documentPath;

@property (nonatomic,readonly) NSString *libraryPath;

@property (nonatomic,readonly) NSString *cachePath;

@property (nonatomic,readonly) NSString *tmpPath;


+(NSString *)pathForFileName:(NSString *)name inDircetoryType:(DircetoryType)type;



+(BOOL)createFileAtPath:(NSString *)fullPath;

+(BOOL)createFileAtPath:(NSString *)fullPath OverWrite:(BOOL)overwrite;

+(BOOL)createFileAtPath:(NSString *)fullPath OverWrite:(BOOL)overwrite Contents:(id)contents error:(NSError * _Nullable *_Nullable)error;

+(BOOL)createFileAtPath:(NSString *)fullPath IntermediateDirectories:(BOOL)intermediateDirectories attributes:(NSDictionary<NSFileAttributeKey, id> *_Nonnull)attributes error:(NSError * _Nullable *_Nullable)error;

+(BOOL)createFileAtPath:(NSString *)fullPath withIntermediateDirectories:(BOOL)intermediateDirectories OverWrite:(BOOL)overwrite attributes:(NSDictionary<NSFileAttributeKey, id> *_Nullable)attributes Contents:(id _Nullable )contents error:(NSError * _Nullable *_Nullable)error;

+(BOOL)fileExistsAtFullPath:(NSString *)fullPath;

+(BOOL)fileExistsAtDocumentPath:(NSString *)fileName;

+(BOOL)removeItemAtPath:(NSString *)path;

+(BOOL)removeItemAtPath:(NSString *)path error:(NSError * _Nullable *_Nullable)error;

+(BOOL)writeFileAtPath:(NSString *)path content:(id)content;

+(BOOL)writeFileAtPath:(NSString *)path content:(id)content error:(NSError **)error;


NS_ASSUME_NONNULL_END
@end

