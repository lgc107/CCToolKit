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

+(instancetype)shareManager;


#pragma mark - path

/**
  沙盒的主目录路径
 */
@property (nonatomic,readonly) NSString *homePath;

/**
 沙盒中Documents的目录路径
 */
@property (nonatomic,readonly) NSString *documentPath;
/**
 沙盒中library的目录路径
 */
@property (nonatomic,readonly) NSString *libraryPath;
/**
 沙盒中cache的目录路径
 */
@property (nonatomic,readonly) NSString *cachePath;
/**
 沙盒中tmp的目录路径
 */
@property (nonatomic,readonly) NSString *tmpPath;


/**
 获取文件完整路径

 @param name 文件相对路径 eg: @"xxx.plist", @"xxx/xxx.plist"
 @param type 沙盒指定的文件夹
 @return 文件完整路径
 */
+(NSString *)pathForFileName:(NSString *)name inDircetoryType:(DircetoryType)type;


/**
 根据文件完整路径获取上一级文件夹名称

 @param path 文件完整路径
 @return DirectoryName
 */
+ (NSString *)directoryAtPath:(NSString *)path;

/**
  根据文件路径获取文件扩展类型
 */
+ (NSString *)suffixAtPath:(NSString *)path;

#pragma mark - list Array
/**
 遍历根目录
 */
+ (NSArray *)cc_listFilesInHomeDirectoryByDeep:(BOOL)deep;
/**
 遍历Library目录
 */
+ (NSArray *)cc_listFilesInLibraryDirectoryByDeep:(BOOL)deep;
/**
 遍历Document目录
 */
+ (NSArray *)cc_listFilesInDocumentDirectoryByDeep:(BOOL)deep;
/**
 遍历Tmp目录
 */
+ (NSArray *)cc_listFilesInTmpDirectoryByDeep:(BOOL)deep;

/**
  遍历Caches目录
 */
+ (NSArray *)cc_listFilesInCachesDirectoryByDeep:(BOOL)deep;
/**
 文件遍历
 
 @param path 目录的绝对路径
 @param deep 是否深遍历 (1. 浅遍历：返回当前目录下的所有文件和文件夹；
 2. 深遍历：返回当前目录下及子目录下的所有文件和文件夹)
 @return 遍历结果数组
 */
+ (NSArray *)cc_listFilesInDirectoryAtPath:(NSString *)path deep:(BOOL)deep;

#pragma mark - File Exist

/**
 通过完整路径判断是否存在文件
 */
+(BOOL)cc_fileExistsAtFullPath:(NSString *)fullPath;

/**
  判断Document文件夹下是否含有fileName 文件
 */
+(BOOL)cc_fileExistsAtDocumentPath:(NSString *)fileName;

/**
  判断路径是否为空(判空条件是文件大小为0，或者是文件夹下没有子文件)
 */
+ (BOOL)cc_isEmptyItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error;

#pragma mark - create

/**
  创建文件夹
 */
+ (BOOL)cc_createDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error;


/**
 在Document创建文件
 */
+ (BOOL)cc_createFileAtDocumentDircetoryWithName:(NSString *)fileName;
/**
 在Library创建文件
 */
+ (BOOL)cc_createFileAtLibraryDircetoryWithName:(NSString *)fileName;
/**
 在Cache创建文件
 */
+ (BOOL)cc_createFileAtCacheDircetoryWithName:(NSString *)fileName;
/**
 在Tmp创建文件
 */
+ (BOOL)cc_createFileAtTmpDircetoryWithName:(NSString *)fileName;

/**
 在指定路径创建文件
 */
+ (BOOL)cc_createFileAtPath:(NSString *)path;
/**
 在指定路径创建文件
 */
+ (BOOL)cc_createFileAtPath:(NSString *)path error:(NSError *__autoreleasing *)error;

/**
  创建文件，是否覆盖
 */
+ (BOOL)cc_createFileAtPath:(NSString *)path overwrite:(BOOL)overwrite;
/**
 创建文件，包含文件内容
 */
+ (BOOL)cc_createFileAtPath:(NSString *)path content:(id)content;
/**
 创建文件，包含文件内容，是否覆盖
 */
+ (BOOL)cc_createFileAtPath:(NSString *)path content:(id)content overwrite:(BOOL)overwrite;
/*创建文件
 *参数1：文件创建的路径
 *参数2：写入文件的内容
 *参数3：假如已经存在此文件是否覆盖
 *参数4：错误信息
 */
+ (BOOL)cc_createFileAtPath:(NSString *)path content:(id)content overwrite:(BOOL)overwrite error:(NSError *__autoreleasing *)error;

#pragma mark - remove

/**
 删除文件
 */
+(BOOL)cc_removeItemAtPath:(NSString *)path;
/**
 删除文件
 */
+(BOOL)cc_removeItemAtPath:(NSString *)path error:(NSError * _Nullable *_Nullable)error;


#pragma mark - write to file
/**
  写入文件内容
 */
+(BOOL)cc_writeFileAtPath:(NSString *)path content:(id)content;
/**
 写入文件内容
 */
+(BOOL)cc_writeFileAtPath:(NSString *)path content:(id)content error:(NSError **)error;

/**
 在文件末尾追加数据，！只建议用于文本追加
 */
+(BOOL)cc_appendData:(NSData *)data withPath:(NSString *)path;

#pragma mark - Read
+ (NSData *)cc_getFileData:(NSString *)filePath;


#pragma mark - File Info
#pragma mark -- file type
/**
判断目录是否是文件夹
 */
+ (BOOL)cc_isDirectoryAtPath:(NSString *)path;

/**
 判断目录是否是文件
 */
+ (BOOL)cc_isFileAtPath:(NSString *)path;
/**
 判断目录是否可以执行
 */
+ (BOOL)cc_isExecutableItemAtPath:(NSString *)path;
/**
 判断目录是否可读
 */
+ (BOOL)cc_isReadableItemAtPath:(NSString *)path;
/**
  判断目录是否可写
 */
+ (BOOL)cc_isWritableItemAtPath:(NSString *)path;

#pragma mark -- date
/**
 获取文件创建时间
 */
+ (NSDate *)cc_creationDateOfItemAtPath:(NSString *)path;
/**
 获取文件创建时间
 */
+ (NSDate *)cc_creationDateOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error;

/**
 获取文件修改时间
 */
+ (NSDate *)cc_modificationDateOfItemAtPath:(NSString *)path;
/**
 获取文件修改时间
 */
+ (NSDate *)cc_modificationDateOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error ;

#pragma mark -- directory size

/**
   获取文件夹大小
 */
+ (NSNumber *)cc_sizeOfDirectoryAtPath:(NSString *)path;
/**
 获取文件夹大小
 */
+ (NSNumber *)cc_sizeOfDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error;
/**
 获取文件夹大小，返回格式化后的数值
 */
+ (NSString *)cc_sizeFormattedOfDirectoryAtPath:(NSString *)path;
/**
 获取文件夹大小，返回格式化后的数值(错误信息error)
 */
+ (NSString *)cc_sizeFormattedOfDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error;

#pragma mark -- item size
/**
   获取目录大小
 */
+ (NSNumber *)cc_sizeOfItemAtPath:(NSString *)path;

/**
  获取目录大小(错误信息error)
 */
+ (NSNumber *)cc_sizeOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error;
/**
 获取目录大小，返回格式化后的数值
 */
+ (NSString *)cc_sizeFormattedOfItemAtPath:(NSString *)path;
/**
 获取目录大小，返回格式化后的数值
 */
+ (NSString *)cc_sizeFormattedOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error;

#pragma mark -- file size
/**
 获取文件大小
 */
+ (NSNumber *)cc_sizeOfFileAtPath:(NSString *)path;
/**
 获取文件大小
 */
+ (NSNumber *)cc_sizeOfFileAtPath:(NSString *)path error:(NSError *__autoreleasing *)error;
/**
 获取文件大小，返回格式化后的数值
 */
+ (NSString *)cc_sizeFormattedOfFileAtPath:(NSString *)path;
/**
 获取文件大小，返回格式化后的数值
 */
+ (NSString *)cc_sizeFormattedOfFileAtPath:(NSString *)path error:(NSError *__autoreleasing *)error;

#pragma mark - file attributes

/**
   根据key获取文件某个属性
 */
+ (id)cc_attributeOfItemAtPath:(NSString *)path forKey:(NSString *)key;

/**
 根据key获取文件某个属性
 @param path 完整路径
 @param key NSFileAttributeKey （NSFileManager中可找）
 @param error 错误信息

 */
+ (id)cc_attributeOfItemAtPath:(NSString *)path forKey:(NSString *)key error:(NSError *__autoreleasing *)error;

/**
  获取文件属性集合
 */
+ (NSDictionary *)cc_attributesOfItemAtPath:(NSString *)path;

/**
 获取文件属性集合

 @param path 文件完整路径
 @param error 错误信息
 */
+ (NSDictionary *)cc_attributesOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error;

+ (NSString *)cc_sizeFormatted:(NSNumber *)size;

@end

