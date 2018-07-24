//
//  CCSoftwareManager.m
//  CCToolKit
//
//  Created by Harry_L on 2018/5/11.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import "CCSoftwareManager.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <sys/utsname.h>
#import <UIKit/UIKit.h>


NSString *const CCAppStoreVersionDidCheckNotification = @"CCAppStoreVersionDidCheckNotification";


@implementation CCSoftwareManager
{
    
    
    NSString *_bundleId;
    
    NSString *_buildVersion;
    
    NSString *_deviceName;
    
    NSString *_deviceSystemName;
    
    NSString *_deviceSystemVersion;
    
    NSString *_deviceLocalizedModel;
    
    NSString *_deviceModelName;
    
    NSString *_carrierName;
    
}
@synthesize currentVersion = _currentVersion;
- (void)setCurrentVersion:(CCVersion *)currentVersion {
    if (_currentVersion != currentVersion) {
        _currentVersion = currentVersion;
    }
}
@synthesize appStoreVersion = _appStoreVersion;
- (void)setAppStoreVersion:(CCVersion *)appStoreVersion {
    if (_appStoreVersion != appStoreVersion) {
        _appStoreVersion = appStoreVersion;
    }
}
@synthesize appStoreUrl = _appStoreUrl;
- (void)setAppStoreUrl:(NSString *)appStoreUrl {
    if (_appStoreUrl != appStoreUrl) {
        _appStoreUrl = [appStoreUrl copy];
    }
}

@synthesize releaseNotes = _releaseNotes;
- (void)setReleaseNotes:(NSString *)releaseNotes{
    if (_releaseNotes != releaseNotes) {
        _releaseNotes = [releaseNotes copy];
    }
}

#pragma mark -  Init
+(instancetype)manager{
    static CCSoftwareManager *appInfoManager = nil;
    static dispatch_once_t appOnceToken;
    if (!appInfoManager) {
        dispatch_once(&appOnceToken, ^{//线程安全
            appInfoManager = [[CCSoftwareManager  alloc] init];
        });
    }
    return appInfoManager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _currentVersion = [CCVersion currentClientVersion];
    }
    return self;
}

#pragma mark - Action
+(void)checkAppNeedUpdateWithAppId:(NSString *)appId CompletitionHandler:(CCVersionCheckResultBlock)completitionHandler{
    [[CCSoftwareManager manager] checkAppNeedUpdateWithAppId:appId OrBundleId:[NSBundle mainBundle].bundleIdentifier CompletitionHandler:completitionHandler];
}
+(void)checkAppNeedUpdateWithCompletitionHandler:(CCVersionCheckResultBlock)completitionHandler{
    [[CCSoftwareManager manager] checkAppNeedUpdateWithAppId:nil OrBundleId:[NSBundle mainBundle].bundleIdentifier CompletitionHandler:completitionHandler];
}
+(void)checkAppNeedUpdateWithBundleId:(NSString *)bundleId CompletitionHandler:(CCVersionCheckResultBlock)completitionHandler{
    [[CCSoftwareManager manager] checkAppNeedUpdateWithAppId:nil OrBundleId:bundleId CompletitionHandler:completitionHandler];
    
}

-(void)checkAppNeedUpdateWithAppId:(NSString *)appId OrBundleId:(NSString *)bundleId CompletitionHandler:(CCVersionCheckResultBlock)completitionHandler{
    
    NSURLRequest *request;
    if (appId != nil) {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",appId]]];
        
        NSLog(@"【1】当前为APPID检测，您设置的APPID为:%@  当前版本号为:%@",appId, self.currentVersion.stringValue);
    }
    else {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@&country=cn",bundleId]]];
        NSLog(@"【1】当前为BundelId检测，您设置的bundelId为:%@  当前版本号为:%@",bundleId, self.currentVersion.stringValue);
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    __block typeof(self) blockSelf = self;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
 
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completitionHandler) {
                    completitionHandler(false,nil,nil,nil,error);
                }
                [[NSNotificationCenter defaultCenter]postNotificationName:CCAppStoreVersionDidCheckNotification object:self userInfo:@{@"IsSuccess":@false,@"IsNeedUpdate":@false,@"error":error}];
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([appInfoDic[@"resultCount"] integerValue] == 0) {
                NSError *error1 = [NSError errorWithDomain:@"检测出未上架的APP或者查询不到" code:0 userInfo:nil];
                if (completitionHandler) {
                    completitionHandler(false,nil,nil,nil,error1);
                }
                [[NSNotificationCenter defaultCenter]postNotificationName:CCAppStoreVersionDidCheckNotification object:self userInfo:@{@"IsSuccess":@false,@"IsNeedUpdate":@false,@"error":error1}];
                return;
            }
            else{
                NSLog(@"【3】苹果服务器返回的检测结果：\n appId = %@ \n bundleId = %@ \n 开发账号名字 = %@ \n 商店版本号 = %@ \n 应用名称 = %@ \n 打开连接 = %@",appInfoDic[@"results"][0][@"artistId"],appInfoDic[@"results"][0][@"bundleId"],appInfoDic[@"results"][0][@"artistName"],appInfoDic[@"results"][0][@"version"],appInfoDic[@"results"][0][@"trackName"],appInfoDic[@"results"][0][@"trackViewUrl"]);
                
                blockSelf.appStoreVersion =  [CCVersion versionWithString: appInfoDic[@"results"][0][@"version"]];
                blockSelf.appStoreUrl = appInfoDic[@"results"][0][@"trackViewUrl"];
                blockSelf.releaseNotes= appInfoDic[@"results"][0][@"releaseNotes"];
                
                switch ([blockSelf.currentVersion compare:blockSelf.appStoreVersion]) {
                    case NSOrderedAscending:
                    {
                        NSLog(@"【4】判断结果：当前版本号%@ < 商店版本号%@ 需要更新\n=================",blockSelf.currentVersion.stringValue,blockSelf.appStoreVersion.stringValue);
                        self.needUpdate = true;
                        if (completitionHandler) {
                            completitionHandler(true,blockSelf.appStoreVersion,blockSelf.appStoreUrl,blockSelf.releaseNotes,nil);
                        }
                        [[NSNotificationCenter defaultCenter]postNotificationName:CCAppStoreVersionDidCheckNotification object:self userInfo:@{@"IsSuccess":@true,@"IsNeedUpdate":@true,@"AppStoreVersion":blockSelf.appStoreVersion,@"releaseNotes":blockSelf.releaseNotes,@"AppStoreTrackUrl":blockSelf.appStoreUrl}];
                    }
                        break;
                    case NSOrderedDescending:
                    {
                        NSLog(@"【4】判断结果：当前版本号%@ > 商店版本号%@ 不需要更新\n================",blockSelf.currentVersion.stringValue,blockSelf.appStoreVersion.stringValue);
                        blockSelf.needUpdate = false;
                        if (completitionHandler) {
                            completitionHandler(false,blockSelf.appStoreVersion,blockSelf.appStoreUrl,blockSelf.releaseNotes,nil);
                        }
                        [[NSNotificationCenter defaultCenter]postNotificationName:CCAppStoreVersionDidCheckNotification object:self userInfo:@{@"IsSuccess":@true,@"IsNeedUpdate":@false,@"AppStoreVersion":blockSelf.appStoreVersion,@"releaseNotes":blockSelf.releaseNotes,@"AppStoreTrackUrl":blockSelf.appStoreUrl,}];
                    }
                        break;
                    case NSOrderedSame:
                    {
                        NSLog(@"【4】判断结果：当前版本号%@ = 商店版本号%@ 不需要更新\n================",blockSelf.currentVersion.stringValue,blockSelf.appStoreVersion.stringValue);
                        blockSelf.needUpdate = false;
                        if (completitionHandler) {
                            completitionHandler(false,blockSelf.appStoreVersion,blockSelf.appStoreUrl,blockSelf.releaseNotes,nil);
                        }
                        [[NSNotificationCenter defaultCenter]postNotificationName:CCAppStoreVersionDidCheckNotification object:self userInfo:@{@"IsSuccess":@true,@"IsNeedUpdate":@false,@"AppStoreVersion":blockSelf.appStoreVersion,@"releaseNotes":blockSelf.releaseNotes,@"AppStoreTrackUrl":blockSelf.appStoreUrl}];
                    }
                        break;
                    default:
                        break;
                }
            }
        });
    }];
    [task resume];
    
}


#pragma mark - App Info
-(NSString *)bundleId{
    if (!_bundleId) {
        _bundleId = [[NSBundle mainBundle].bundleIdentifier copy];
    }
    return _bundleId;
}

-(NSString *)buildVersion{
    if (!_buildVersion) {
        _buildVersion =  [[[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleVersion"] copy];
    }
    return _buildVersion;
}

#pragma mark - device Info
-(NSString *)deviceName{
    if (!_deviceName) {
        _deviceName = [UIDevice currentDevice].name;
    }
    return _deviceName;
}

-(NSString *)deviceSystemName{
    if (!_deviceSystemName) {
        _deviceSystemName = [UIDevice currentDevice].systemName;
    }
    return _deviceSystemName;
}

-(NSString *)deviceSystemVersion{
    if (!_deviceSystemVersion) {
        _deviceSystemVersion = [UIDevice currentDevice].systemVersion;
    }
    return _deviceSystemVersion;
}

-(NSString *)deviceLocalizedModel{
    if (!_deviceLocalizedModel) {
        _deviceLocalizedModel = [UIDevice currentDevice].localizedModel;
    }
    return _deviceLocalizedModel;
    
}

-(NSString *)carrierName{
    if (!_carrierName) {
        CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = [info subscriberCellularProvider];
        _carrierName = carrier.carrierName;
    }
    return _carrierName;
}



-(NSString *)deviceModelName{
    if (!_deviceModelName) {
        
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *platform = [NSString stringWithCString:systemInfo.machine
                                                encoding:NSUTF8StringEncoding];
        
        //iPhone
        if ([platform isEqualToString:@"iPhone1,1"])   {  _deviceModelName = @"iPhone 1G";}
        else if ([platform isEqualToString:@"iPhone1,2"])  {  _deviceModelName =  @"iPhone 3G";}
        else if ([platform isEqualToString:@"iPhone2,1"])  {  _deviceModelName =  @"iPhone 3GS";}
        else if ([platform isEqualToString:@"iPhone3,1"])  {  _deviceModelName =  @"iPhone 4";}
        else if ([platform isEqualToString:@"iPhone3,2"])  {  _deviceModelName =  @"iPhone 4";}
        else if ([platform isEqualToString:@"iPhone4,1"])  {  _deviceModelName =  @"iPhone 4S";}
        else if ([platform isEqualToString:@"iPhone5,1"])  {  _deviceModelName =  @"iPhone 5";}
        else if ([platform isEqualToString:@"iPhone5,2"])  {  _deviceModelName =  @"iPhone 5";}
        else if ([platform isEqualToString:@"iPhone5,3"])  {  _deviceModelName =  @"iPhone 5C";}
        else if ([platform isEqualToString:@"iPhone5,4"])  {  _deviceModelName =  @"iPhone 5C";}
        else if ([platform isEqualToString:@"iPhone6,1"])  {  _deviceModelName =  @"iPhone 5S";}
        else if ([platform isEqualToString:@"iPhone6,2"])  {  _deviceModelName = @"iPhone 5S";}
        else if ([platform isEqualToString:@"iPhone7,1"])  {  _deviceModelName =  @"iPhone 6 Plus";}
        else if ([platform isEqualToString:@"iPhone7,2"])  {  _deviceModelName =  @"iPhone 6";}
        else if ([platform isEqualToString:@"iPhone8,1"])  {  _deviceModelName = @"iPhone 6s";}
        else if ([platform isEqualToString:@"iPhone8,2"])  {  _deviceModelName = @"iPhone 6s Plus";}
        else if ([platform isEqualToString:@"iPhone8,4"])  {  _deviceModelName = @"iPhone SE";}
        else if ([platform isEqualToString:@"iPhone9,1"]  ||  [platform isEqualToString:@"iPhone9,3"] ) { _deviceModelName =  @"iPhone 7";}
        else if ([platform isEqualToString:@"iPhone9,2"]  ||  [platform isEqualToString:@"iPhone9,4"] ){  _deviceModelName = @"iPhone 7 Plus";}
        else if ([platform isEqualToString:@"iPhone10,1"] ||  [platform isEqualToString:@"iPhone10,4"]){  _deviceModelName = @"iPhone 8";     }
        else if ([platform isEqualToString:@"iPhone10,2"] ||  [platform isEqualToString:@"iPhone10,5"]){  _deviceModelName = @"iPhone 8 Plus";}
        else if ([platform isEqualToString:@"iPhone10,3"] ||  [platform isEqualToString:@"iPhone10,6"]){  _deviceModelName = @"iPhone X";     }
        //simulator
        else if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"])
        {_deviceModelName = @"Simulator";}
        //AirPods
        else if ([platform isEqualToString:@"AirPods1,1"]) {   _deviceModelName = [@"AirPods" copy];}
        
        //Apple TV
        else if ([platform isEqualToString:@"AppleTV2,1"]) {  _deviceModelName = @"Apple TV (2nd generation)";}
        else if ([platform isEqualToString:@"AppleTV3,1"] || [platform isEqualToString:@"AppleTV3,2"]) {  _deviceModelName =  @"Apple TV (3rd generation)";}
        else if ([platform isEqualToString:@"AppleTV5,3"]) {  _deviceModelName =  @"Apple TV (4th generation)";}
        else if ([platform isEqualToString:@"AppleTV6,2"]) {  _deviceModelName = @"Apple TV 4K";}
        
        //Apple Watch
        else if ([platform isEqualToString:@"Watch1,1"] || [platform isEqualToString:@"Watch1,2"])  { _deviceModelName =  @"Apple Watch (1st generation)";}
        else if ([platform isEqualToString:@"Watch2,6"] || [platform isEqualToString:@"Watch2,7"] )    {_deviceModelName =  @"Apple Watch Series 1";}
        else if ([platform isEqualToString:@"Watch2,3"] || [platform isEqualToString:@"Watch2,4"])    {_deviceModelName =  @"Apple Watch Series 2";}
        else if ([platform isEqualToString:@"Watch3,1"] || [platform isEqualToString:@"Watch3,2"] || [platform isEqualToString:@"Watch3,3"] || [platform isEqualToString:@"Watch3,4"]){_deviceModelName =  @"Apple Watch Series 3";}
        
        //HomePod
        else if ([platform isEqualToString:@"AudioAccessory1,1"]) { _deviceModelName = @"HomePod";}
        
        //iPad
        else if ([platform isEqualToString:@"iPad1,1"])   {_deviceModelName =  @"iPad";}
        else if ([platform isEqualToString:@"iPad2,1"] || [platform isEqualToString:@"iPad2,2"] || [platform isEqualToString:@"iPad2,3"] || [platform isEqualToString:@"iPad2,4"])    _deviceModelName = @"iPad 2";
        else if ([platform isEqualToString:@"iPad3,1"] || [platform isEqualToString:@"iPad3,2"] || [platform isEqualToString:@"iPad3,2"] || [platform isEqualToString:@"iPad3,3"])    _deviceModelName =  @"iPad (3rd generation)";
        
        else if ([platform isEqualToString:@"iPad3,4"] || [platform isEqualToString:@"iPad3,5"] || [platform isEqualToString:@"iPad3,6"])    _deviceModelName = @"iPad (4th generation)";
        
        else if ([platform isEqualToString:@"iPad4,1"] || [platform isEqualToString:@"iPad4,2"] || [platform isEqualToString:@"iPad4,3"])    _deviceModelName = @"iPad Air";
        
        else if ([platform isEqualToString:@"iPad5,3"] || [platform isEqualToString:@"iPad5,4"])    _deviceModelName = @"iPad Air 2";
        
        else if ([platform isEqualToString:@"iPad6,7"] || [platform isEqualToString:@"iPad6,8"])    _deviceModelName = @"iPad Pro (12.9-inch)";
        
        else if ([platform isEqualToString:@"iPad6,3"] || [platform isEqualToString:@"iPad6,4"])    _deviceModelName = @"iPad Pro (9.7-inch)";
        
        else if ([platform isEqualToString:@"iPad6,11"] ||[platform isEqualToString:@"iPad6,12"] )    _deviceModelName = @"iPad (5th generation)";
        
        else if ([platform isEqualToString:@"iPad7,1"] || [platform isEqualToString:@"iPad7,2"])    _deviceModelName = @"iPad Pro (12.9-inch, 2nd generation)";
        else if ([platform isEqualToString:@"iPad7,3"] || [platform isEqualToString:@"iPad7,4"])   _deviceModelName = @"iPad Pro (10.5-inch)";
        
        //iPad mini
        else if ([platform isEqualToString:@"iPad2,5"] || [platform isEqualToString:@"iPad2,6"] || [platform isEqualToString:@"iPad2,7"])  _deviceModelName  = @"iPad mini";
        else if ([platform isEqualToString:@"iPad4,4"] || [platform isEqualToString:@"iPad4,5"] || [platform isEqualToString:@"iPad4,6"])  _deviceModelName  = @"iPad mini 2";
        else if ([platform isEqualToString:@"iPad4,7"] || [platform isEqualToString:@"iPad4,8"] || [platform isEqualToString:@"iPad4,9"])  _deviceModelName  = @"iPad mini 3";
        else if ([platform isEqualToString:@"iPad5,1"] || [platform isEqualToString:@"iPad5,2"])
            _deviceModelName  = @"iPad mini 4";
        
        //iPod touch
        else if ([platform isEqualToString:@"iPod1,1"])    _deviceModelName =  @"iPod touch";
        else if ([platform isEqualToString:@"iPod2,1"])    _deviceModelName =  @"iPod touch (2nd generation)";
        else if ([platform isEqualToString:@"iPod3,1"])    _deviceModelName =  @"iPod touch (3rd generation)";
        else if ([platform isEqualToString:@"iPod4,1"])    _deviceModelName =  @"iPod touch (4th generation)";
        else if ([platform isEqualToString:@"iPod5,1"])    _deviceModelName =  @"iPod touch (5th generation)";
        else if ([platform isEqualToString:@"iPod7,1"])    _deviceModelName =  @"iPod touch (6th generation)";
        
    }
    return _deviceModelName;
    
}

-(BOOL)isIphoneX{
    if (!_isIphoneX) {
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *platform = [NSString stringWithCString:systemInfo.machine
                                                encoding:NSUTF8StringEncoding];
        if ([platform isEqualToString:@"iPhone10,3"] || [platform isEqualToString:@"iPhone10,6"]){
            _isIphoneX = true;
            
        }
        else if (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size)){
            _isIphoneX = true;
            
        }
        else{
            _isIphoneX = false;
        }
    }
    
    
    return _isIphoneX;
}


#pragma mark - Preventing KVC assignment
//Returns a Boolean value that indicates whether the key-value coding methods should access the corresponding instance variable directly on finding no accessor method for a property.
//YES if the key-value coding methods should access the corresponding instance variable directly on finding no accessor method for a property, otherwise NO.
//防止KVC赋值readonly属性
+ (BOOL)accessInstanceVariablesDirectly{
    return NO;
}


@end
