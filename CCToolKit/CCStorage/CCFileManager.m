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

#pragma mark - shareInstance
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

#pragma mark - path

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

+ (NSString *)directoryAtPath:(NSString *)path {
    return [path stringByDeletingLastPathComponent];
}

+ (NSString *)suffixAtPath:(NSString *)path {
    return [path pathExtension];
}

#pragma mark - FileList
+ (NSArray *)cc_listFilesInHomeDirectoryByDeep:(BOOL)deep {
    return [self cc_listFilesInDirectoryAtPath:[CCFileManager shareManager].homePath deep:deep];
}

+ (NSArray *)cc_listFilesInLibraryDirectoryByDeep:(BOOL)deep {
    return [self cc_listFilesInDirectoryAtPath:[CCFileManager shareManager].libraryPath deep:deep];
}

+ (NSArray *)cc_listFilesInDocumentDirectoryByDeep:(BOOL)deep {
    return [self cc_listFilesInDirectoryAtPath:[CCFileManager shareManager].documentPath deep:deep];
}

+ (NSArray *)cc_listFilesInTmpDirectoryByDeep:(BOOL)deep {
    return [self cc_listFilesInDirectoryAtPath:[CCFileManager shareManager].tmpPath deep:deep];
}

+ (NSArray *)cc_listFilesInCachesDirectoryByDeep:(BOOL)deep {
    return [self cc_listFilesInDirectoryAtPath:[CCFileManager shareManager].cachePath deep:deep];
}

+ (NSArray *)cc_listFilesInDirectoryAtPath:(NSString *)path deep:(BOOL)deep {
    NSArray *listArr;
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    if (deep) {
        // 深遍历
        NSArray *deepArr = [manager subpathsOfDirectoryAtPath:path error:&error];
        if (!error) {
            listArr = deepArr;
        }else {
            listArr = nil;
        }
    }else {
        // 浅遍历
        NSArray *shallowArr = [manager contentsOfDirectoryAtPath:path error:&error];
        if (!error) {
            listArr = shallowArr;
        }else {
            listArr = nil;
        }
    }
    return listArr;
}

#pragma mark - 判断文件是否存在
+(BOOL)cc_fileExistsAtFullPath:(NSString *)fullPath{
    return [[NSFileManager defaultManager]fileExistsAtPath:fullPath];
}

+(BOOL)cc_fileExistsAtDocumentPath:(NSString *)fileName{
    return [[NSFileManager defaultManager]fileExistsAtPath:[self pathForFileName:fileName inDircetoryType:Document]];
}

#pragma mark - 判断文件(夹)是否为空
+ (BOOL)cc_isEmptyItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return ([self cc_isFileAtPath:path] &&
            [[self cc_sizeOfItemAtPath:path error:error] intValue] == 0) ||
    ([self cc_isDirectoryAtPath:path] &&
     [[self cc_listFilesInDirectoryAtPath:path deep:NO] count] == 0);
}



#pragma mark - create

+ (BOOL)cc_createFileAtDocumentDircetoryWithName:(NSString *)fileName{
     return [self cc_createFileAtPath:[self pathForFileName:fileName inDircetoryType:Document]];
}

+(BOOL)cc_createFileAtLibraryDircetoryWithName:(NSString *)fileName{
     return [self cc_createFileAtPath:[self pathForFileName:fileName inDircetoryType:Library]];
}


+ (BOOL)cc_createFileAtCacheDircetoryWithName:(NSString *)fileName{
    return [self cc_createFileAtPath:[self pathForFileName:fileName inDircetoryType:Caches]];
}

+ (BOOL)cc_createFileAtTmpDircetoryWithName:(NSString *)fileName{
    return [self cc_createFileAtPath:[self pathForFileName:fileName inDircetoryType:Tmp]];
}

+ (BOOL)cc_createDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    NSFileManager *manager = [NSFileManager defaultManager];
    /* createDirectoryAtPath:withIntermediateDirectories:attributes:error:
     * 参数1：创建的文件夹的路径
     * 参数2：是否创建媒介的布尔值，一般为YES
     * 参数3: 属性，没有就置为nil
     * 参数4: 错误信息
     */
    BOOL isSuccess = [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:error];
    return isSuccess;
}

+ (BOOL)cc_createFileAtPath:(NSString *)path {
    return [self cc_createFileAtPath:path content:nil overwrite:YES error:nil];
}

+ (BOOL)cc_createFileAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return [self cc_createFileAtPath:path content:nil overwrite:YES error:error];
}

+ (BOOL)cc_createFileAtPath:(NSString *)path overwrite:(BOOL)overwrite {
    return [self cc_createFileAtPath:path content:nil overwrite:overwrite error:nil];
}

+ (BOOL)cc_createFileAtPath:(NSString *)path content:(id)content {
    return [self cc_createFileAtPath:path content:content overwrite:YES error:nil];
}

+ (BOOL)cc_createFileAtPath:(NSString *)path content:(id)content overwrite:(BOOL)overwrite {
    return [self cc_createFileAtPath:path content:content overwrite:overwrite error:nil];
}

+ (BOOL)cc_createFileAtPath:(NSString *)path content:(id)content overwrite:(BOOL)overwrite error:(NSError *__autoreleasing *)error {
    // 如果文件夹路径不存在，那么先创建文件夹
    NSString *directoryPath = [self directoryAtPath:path];
    if (![self cc_fileExistsAtFullPath:directoryPath]) {
        // 创建文件夹
        if (![self cc_createDirectoryAtPath:directoryPath error:error]) {
            return NO;
        }
    }
    // 如果文件存在，并不想覆盖，那么直接返回YES。
    if (!overwrite) {
        if ([self cc_fileExistsAtFullPath:path]) {
            return YES;
        }
    }
    /*创建文件
     *参数1：创建文件的路径
     *参数2：创建文件的内容（NSData类型）
     *参数3：文件相关属性
     */
    BOOL isSuccess = [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    if (content) {
        [self cc_writeFileAtPath:path content:content error:error];
    }
    return isSuccess;
}

#pragma mark - remove
+ (BOOL)cc_removeItemAtPath:(NSString *)path {
    return  [self cc_removeItemAtPath:path error:nil];
}

+ (BOOL)cc_removeItemAtPath:(NSString *)path error:(NSError * _Nullable *)error{
    return [[NSFileManager defaultManager] removeItemAtPath:path error:error];
}

#pragma mark - Write
+(BOOL)cc_writeFileAtPath:(NSString *)path content:(NSObject *)content
{
    return [self cc_writeFileAtPath:path content:content error:nil];
}

+(BOOL)cc_writeFileAtPath:(NSString *)path content:(id)content error:(NSError **)error
{
    if(content == nil)
    {
        [NSException raise:@"Invalid content" format:@"content can't be nil."];
    }
    
    [self cc_createFileAtPath:path overwrite:false];
    
    
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
        return [self cc_writeFileAtPath:path content:((UIImageView *)content).image error:error];
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

+ (BOOL)cc_appendData:(NSData *)data withPath:(NSString *)path
{
    BOOL result = [self cc_createFileAtPath:path];
    if (result) {
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
        [handle seekToEndOfFile];
        [handle writeData:data];
        [handle synchronizeFile];
        [handle closeFile];
        return YES;
    } else {
        NSLog(@"%s Failed",__FUNCTION__);
        return NO;
    }
}

#pragma mark - Read
+ (NSData *)cc_getFileData:(NSString *)filePath
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData *fileData = [handle readDataToEndOfFile];
    [handle closeFile];
    return fileData;
}




#pragma mark - File Info
#pragma mark -- file type
+ (BOOL)cc_isDirectoryAtPath:(NSString *)path {
    return ([self cc_attributeOfItemAtPath:path forKey:NSFileType error:nil] == NSFileTypeDirectory);
}

+ (BOOL)cc_isFileAtPath:(NSString *)path {
    return ([self cc_attributeOfItemAtPath:path forKey:NSFileType error:nil] == NSFileTypeRegular);
}

+ (BOOL)cc_isExecutableItemAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] isExecutableFileAtPath:path];
}

+ (BOOL)cc_isReadableItemAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] isReadableFileAtPath:path];
}

+ (BOOL)cc_isWritableItemAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] isWritableFileAtPath:path];
}


#pragma mark -- create Date

+ (NSDate *)cc_creationDateOfItemAtPath:(NSString *)path {
    return [self cc_creationDateOfItemAtPath:path error:nil];
}
//获取文件创建的时间
+ (NSDate *)cc_creationDateOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return (NSDate *)[self cc_attributeOfItemAtPath:path forKey:NSFileCreationDate error:error];
}

#pragma mark -- modification Date
+ (NSDate *)cc_modificationDateOfItemAtPath:(NSString *)path {
    return [self cc_modificationDateOfItemAtPath:path error:nil];
}
//获取文件修改的时间
+ (NSDate *)cc_modificationDateOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return (NSDate *)[self cc_attributeOfItemAtPath:path forKey:NSFileModificationDate error:error];
}

#pragma mark --directory size

+ (NSNumber *)cc_sizeOfDirectoryAtPath:(NSString *)path {
    return [self cc_sizeOfDirectoryAtPath:path error:nil];
}

+ (NSNumber *)cc_sizeOfDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    if ([self cc_isDirectoryAtPath:path]) {
        //深遍历文件夹
        NSArray *subPaths = [self cc_listFilesInDirectoryAtPath:path deep:YES];
        NSEnumerator *contentsEnumurator = [subPaths objectEnumerator];
        
        NSString *file;
        unsigned long long int folderSize = 0;
        
        while (file = [contentsEnumurator nextObject]) {
            NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[path stringByAppendingPathComponent:file] error:nil];
            folderSize += [[fileAttributes objectForKey:NSFileSize] intValue];
        }
        return [NSNumber numberWithUnsignedLongLong:folderSize];
    }
    return nil;
}

+ (NSString *)cc_sizeFormattedOfDirectoryAtPath:(NSString *)path {
    return [self cc_sizeFormattedOfDirectoryAtPath:path error:nil];
}

+ (NSString *)cc_sizeFormattedOfDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    NSNumber *size = [self cc_sizeOfDirectoryAtPath:path error:error];
    if (size) {
        return [self cc_sizeFormatted:size];
    }
    return nil;
}


#pragma mark --item size
+ (NSNumber *)cc_sizeOfItemAtPath:(NSString *)path {
    return [self cc_sizeOfItemAtPath:path error:nil];
}

+ (NSNumber *)cc_sizeOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return (NSNumber *)[self cc_attributeOfItemAtPath:path forKey:NSFileSize error:error];
}

+ (NSString *)cc_sizeFormattedOfItemAtPath:(NSString *)path {
    return [self cc_sizeFormattedOfItemAtPath:path error:nil];
}

+ (NSString *)cc_sizeFormattedOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    NSNumber *size = [self cc_sizeOfItemAtPath:path error:error];
    if (size) {
        return [self cc_sizeFormatted:size];
    }
    return nil;
}


#pragma mark --file size
+ (NSNumber *)cc_sizeOfFileAtPath:(NSString *)path {
    return [self cc_sizeOfFileAtPath:path error:nil];
}

+ (NSNumber *)cc_sizeOfFileAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    if ([self cc_isFileAtPath:path]) {
        return [self cc_sizeOfItemAtPath:path error:error];
    }
    return nil;
}

+ (NSString *)cc_sizeFormattedOfFileAtPath:(NSString *)path {
    return [self cc_sizeFormattedOfFileAtPath:path error:nil];
}

+ (NSString *)cc_sizeFormattedOfFileAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    NSNumber *size = [self cc_sizeOfFileAtPath:path error:error];
    if (size) {
        return [self cc_sizeFormatted:size];
    }
    return nil;
}

#pragma mark - file attributes
+ (id)cc_attributeOfItemAtPath:(NSString *)path forKey:(NSString *)key {
    return [[self cc_attributesOfItemAtPath:path] objectForKey:key];
}

+ (id)cc_attributeOfItemAtPath:(NSString *)path forKey:(NSString *)key error:(NSError *__autoreleasing *)error {
    return [[self cc_attributesOfItemAtPath:path error:error] objectForKey:key];
}

+ (NSDictionary *)cc_attributesOfItemAtPath:(NSString *)path {
    return [self cc_attributesOfItemAtPath:path error:nil];
}

+ (NSDictionary *)cc_attributesOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return [[NSFileManager defaultManager] attributesOfItemAtPath:path error:error];
}



#pragma mark 将文件大小格式化为字节
+(NSString *)cc_sizeFormatted:(NSNumber *)size {
    /*NSByteCountFormatterCountStyle枚举
     *NSByteCountFormatterCountStyleFile 字节为单位，采用十进制的1000bytes = 1KB
     *NSByteCountFormatterCountStyleMemory 字节为单位，采用二进制的1024bytes = 1KB
     *NSByteCountFormatterCountStyleDecimal KB为单位，采用十进制的1000bytes = 1KB
     *NSByteCountFormatterCountStyleBinary KB为单位，采用二进制的1024bytes = 1KB
     */
    return [NSByteCountFormatter stringFromByteCount:[size unsignedLongLongValue] countStyle:NSByteCountFormatterCountStyleFile];
}

+(BOOL)isNotError:(NSError **)error
{
    //the first check prevents EXC_BAD_ACCESS error in case methods are called passing nil to error argument
    //the second check prevents that the methods returns always NO just because the error pointer exists (so the first condition returns YES)
    return ((error == nil) || ((*error) == nil));
}



@end
