//
//  CCAppInfoManager.h
//  CCToolKit
//
//  Created by Harry_L on 2018/5/11.
//  Copyright © 2018年 Harry_L. All rights reserved.
/*
    LMS's good
*/
#import <Foundation/Foundation.h>
#import "CCVersion.h"


@class CCVersion;


// After checked app need update , post notification's name.
extern NSString *const CCAppStoreVersionDidCheckNotification;
//Success : userInfo : @{@"IsSuccess":@true,@"IsNeedUpdate":@false | @true,@"AppStoreVersion":(CCVersion *)appStoreVersion,@"AppStoreTrackUrl":(NSString *)appStoreUrl}
//failture : userInfo : @{@"IsSuccess":@false,@"IsNeedUpdate":@false,@"error":(NSError *)error}


typedef void(^CCVersionCheckResultBlock)(BOOL needUpdate, CCVersion *appStoreVersion, NSString *trackUrl,NSError *error);

@interface CCSoftwareManager : NSObject


/**
  Returns the shared defaults object.
 */
+(instancetype)manager;

/**
 Check version updates through appleId.

 @param appId iTunes AppId Number
 @param completitionHandler Call CCVersionCheckResultBlock Block After Checking Version.
 */
+(void)checkAppNeedUpdateWithAppId:(NSString *)appId CompletitionHandler:(CCVersionCheckResultBlock)completitionHandler;
/**
 Check for updates through automatically detected BundleId

 @param completitionHandler Call CCVersionCheckResultBlock Block After Checking Version.
 */
+(void)checkAppNeedUpdateWithCompletitionHandler:(CCVersionCheckResultBlock)completitionHandler;
/**
 Check version updates through bundleId.
 
 @param bundleId iTunes AppId Number
 @param completitionHandler Call CCVersionCheckResultBlock Block After Checking Version.
 */
+(void)checkAppNeedUpdateWithBundleId:(NSString *)bundleId CompletitionHandler:(CCVersionCheckResultBlock)completitionHandler;



/**
 The current Version Object.
 */
@property (nonatomic,strong,readonly) CCVersion *currentVersion;
/**
  Generate an AppStore Version object after checking for version updates.
 */
@property (nonatomic,strong,readonly) CCVersion *appStoreVersion;
/**
 Generate an AppStore download Url  after checking for version updates.
 */
@property (nonatomic,copy,readonly) NSString *appStoreUrl;


/**
  Get App BundleId.
 */
@property (nonatomic,readonly) NSString *bundleId;
/**
   Get App build Version.
 */
@property (nonatomic,readonly) NSString *buildVersion;

/**
  Get the result of updating after checking the version update. Default is false.
 */
@property (nonatomic,assign,getter=isNeedUpdate) BOOL needUpdate;

/**
   whether the device is iphoneX
 */
@property (nonatomic,assign) BOOL isIphoneX;

/**
 The name identifying the device.
 */
@property (nonatomic,readonly) NSString *deviceName;
/**
 The name of the operating system running on the device.
 */
@property (nonatomic,readonly) NSString *deviceSystemName;

/**
 The current version of the operating system.
 */
@property (nonatomic,readonly) NSString *deviceSystemVersion;

/**
 The model of the device as a localized string.For example ,"iPhone"
 */
@property (nonatomic,readonly) NSString *deviceLocalizedModel;

/**
 The model Name of the device as a localized string. For example,"iPhone 7"
 */
@property (nonatomic,readonly) NSString *deviceModelName;

/**
  The name of the user’s home cellular service provider. For example, "中国联通"
 */
@property (nonatomic,readonly) NSString *carrierName;




@end
