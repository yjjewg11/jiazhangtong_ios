//
//  AppDelegate.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/5/30.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "AppDelegate.h"
#import "UIWindow+Extension.h"
#import "BaiduMobStat.h"
#import "BPush.h"
#import "KGHttpService.h"
#import "KeychainItemWrapper.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "SystemShareKey.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


+ (AppDelegate *)appDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]  delegate];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [application setStatusBarStyle:UIStatusBarStyleDefault];
    
    // 创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.tintColor =
    [UIColor colorWithHue:1
               saturation:0.67
               brightness:0.93
                    alpha:1];
    
    [self buildBaiduMobStat];
    [self buildBaiduPush:application didFinishLaunchingWithOptions:launchOptions];
    
    //消除icon badge
    [self clearBadge];
    
    // 启动tag页面
    [self.window switchRootViewController];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [self.window makeKeyAndVisible];
    return YES;
}

//清除Badge
- (void)clearBadge{
    if(bIsIos8){
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [UIApplication sharedApplication].applicationIconBadgeNumber = Number_Zero;
    }else{
        [UIApplication sharedApplication].applicationIconBadgeNumber = Number_Zero;
    }
}

- (void)testLocalNotifi
{
    NSLog(@"测试本地通知啦！！！");
    NSDate *fireDate = [[NSDate new] dateByAddingTimeInterval:5];
    [BPush localNotification:fireDate alertBody:@"这是本地通知" badge:3 withFirstAction:@"打开" withSecondAction:@"关闭" userInfo:nil soundName:nil region:nil regionTriggersOnce:YES category:nil];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    completionHandler(UIBackgroundFetchResultNewData);
    
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
    [application registerForRemoteNotifications];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"test:%@",deviceToken);
    
    NSString * token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:String_DefValue_Arrows]];
    
    NSArray * strAry = [token componentsSeparatedByString:String_DefValue_EmptyStr];
    NSMutableString * key = [NSMutableString stringWithString:String_DefValue_Empty];
    for(NSString * str in strAry){
        [key appendString:str];
    }
    
    if(![key isEqualToString:String_DefValue_Empty]){
        [self savePushToken:key];
    }
    
    [BPush registerDeviceToken:deviceToken];
}

//save token
- (void)savePushToken:(NSString *)key{
    KeychainItemWrapper * wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:Key_KeyChain accessGroup:nil];
    NSString * wrapperToken = [wrapper objectForKey:(__bridge id)kSecAttrAccount];
    
    if(![key isEqualToString:wrapperToken] || [key isEqualToString:String_DefValue_Empty]){
        
        [KGHttpService sharedService].pushToken = wrapperToken;
        
        [[KGHttpService sharedService] submitPushToken:^(NSString *msgStr) {
            [wrapper setObject:key forKey:(__bridge id)kSecAttrAccount];
        } faild:^(NSString *errorMsg) {
        }];
    }
}


// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // App 收到推送的通知
    [BPush handleNotification:userInfo];
    
    NSLog(@"%@",userInfo);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"接收本地通知啦！！！");
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
}



//绑定百度推送
- (void)buildBaiduPush:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // iOS8 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
#warning 测试 开发环境 时需要修改BPushMode为BPushModeDevelopment 需要修改Apikey为自己的Apikey
    
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    [BPush registerChannel:launchOptions apiKey:BaiduPushAppId pushMode:BPushModeDevelopment withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:YES];
    
//    [BPush registerChannel:launchOptions apiKey:<#在百度云推送官网上注册后得到的apikey#> pushMode:BPushModeProduction withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:YES];
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }
#if TARGET_IPHONE_SIMULATOR
    Byte dt[32] = {0xc6, 0x1e, 0x5a, 0x13, 0x2d, 0x04, 0x83, 0x82, 0x12, 0x4c, 0x26, 0xcd, 0x0c, 0x16, 0xf6, 0x7c, 0x74, 0x78, 0xb3, 0x5f, 0x6b, 0x37, 0x0a, 0x42, 0x4f, 0xe7, 0x97, 0xdc, 0x9f, 0x3a, 0x54, 0x10};
    [self application:application didRegisterForRemoteNotificationsWithDeviceToken:[NSData dataWithBytes:dt length:32]];
#endif
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    /*
     // 测试本地通知
     [self performSelector:@selector(testLocalNotifi) withObject:nil afterDelay:1.0];
     */
    
    NSLog(@"device =======%@",[[UIDevice currentDevice]name]);
}


//绑定百度统计
- (void)buildBaiduMobStat {
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES; // 是否允许截获并发送崩溃信息，请设置YES或者NO
//    statTracker.channelId = @"ReplaceMeWithYourChannel";//设置您的app的发布渠道 默认APP Store
    statTracker.logStrategy = BaiduMobStatLogStrategyAppLaunch;//根据开发者设定的发送策略,发送日志
//    statTracker.logSendInterval = 1;  //为1时表示发送日志的时间间隔为1小时,当logStrategy设置为BaiduMobStatLogStrategyCustom时生效
    statTracker.logSendWifiOnly = NO; //是否仅在WIfi情况下发送日志数据
    statTracker.sessionResumeInterval = 10;//设置应用进入后台再回到前台为同一次session的间隔时间[0~600s],超过600s则设为600s，默认为30s
    statTracker.shortAppVersion  = IosAppVersion; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    statTracker.enableDebugOn = YES; //调试的时候打开，会有log打印，发布时候关闭
    /*如果有需要，可自行传入adid
     NSString *adId = @"";
     if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f){
     adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
     }
     statTracker.adid = adId;
     */
    
    //    AppKey:e633eaf16d
    [statTracker startWithAppId:BaiduMobStatAppId];//设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
}


//share config
- (void)umengShareConfig{
    [UMSocialData setAppKey:uMengAppKey];
    [UMSocialData openLog:NO];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:ShareKey_WeChat appSecret:ShareKey_WeChatSecret url:webUrl];
    
    //打开新浪微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //打开腾讯微博SSO开关，设置回调地址  因腾讯微博sdk暂未提供64位SDK 所以友盟也没法增加针对腾讯微博的64位处理
    //    [UMSocialTencentWeiboHandler openSSOWithRedirectUrl:@"http://sns.whalecloud.com/tencent2/callback"];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL judge = [UMSocialSnsService handleOpenURL:url];
    return judge;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    BOOL judge = [UMSocialSnsService handleOpenURL:url];
    
    return  judge;
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}


@end
