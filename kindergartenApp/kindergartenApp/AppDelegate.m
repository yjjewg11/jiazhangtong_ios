//
//  AppDelegate.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/5/30.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "AppDelegate.h"
#import "UIWindow+Extension.h"
#import "KGHttpService.h"
#import "KeychainItemWrapper.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "SystemShareKey.h"
#import "UMFeedback.h"
#import "MobClick.h"
#import "UMSocialQQHandler.h"
#import "UMessage.h"

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()

@end

@implementation AppDelegate


+ (AppDelegate *)appDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]  delegate];
}



- (void)umengTrack {
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];//参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:uMengAppKey reportPolicy:(ReportPolicy)BATCH channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
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
    
    
    
    // 启动tag页面
    [self.window switchRootViewController];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //设置友盟反馈 appkey
    [UMFeedback setAppkey:uMengAppKey];
    //设置友盟更新
    [self umengTrack];
    //友盟分享
    [self umengShareConfig];
    //设置友盟推送消息
    [self registerUMessageNotification:launchOptions];
    
    //消除icon badge
    [self clearBadge];
    
    UILocalNotification * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(remoteNotification){
        [self handleNotification:application notification:nil remoteNotification:remoteNotification];
        remoteNotification.fireDate = [NSDate date];
        remoteNotification.timeZone = [NSTimeZone defaultTimeZone];
        remoteNotification.soundName = UILocalNotificationDefaultSoundName;
        NSDictionary * dic = [(NSDictionary *)remoteNotification objectForKey:@"aps"];
        remoteNotification.alertBody = [dic objectForKey:@"alert"];
        UIApplication * app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:remoteNotification];
    }
    
    return YES;
}

//清除Badge
- (void)clearBadge{
    if(bIsIos8){
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [UIApplication sharedApplication].applicationIconBadgeNumber = Number_Zero;
    }else{
        [UIApplication sharedApplication].applicationIconBadgeNumber = Number_Zero;
    }
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
    
    [UMessage registerDeviceToken:deviceToken];
}

//save token
- (void)savePushToken:(NSString *)key{
    KeychainItemWrapper * wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:Key_KeyChain accessGroup:nil];
//    NSString * wrapperToken = [wrapper objectForKey:(__bridge id)kSecAttrAccount];
    
//    if(![key isEqualToString:wrapperToken] || [key isEqualToString:String_DefValue_Empty]){
    
        [KGHttpService sharedService].pushToken = key;
        
        [[KGHttpService sharedService] submitPushToken:^(NSString *msgStr) {
            [wrapper setObject:key forKey:(__bridge id)kSecAttrAccount];
        } faild:^(NSString *errorMsg) {
        }];
//    }
}


// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self handleNotification:application notification:userInfo remoteNotification:nil];
}

#pragma mark - 处理接收 通知消息
- (void)handleNotification:(UIApplication *)application notification:(NSDictionary *)notification remoteNotification:(UILocalNotification *)remoteNotification {
    
    if(remoteNotification){
        notification = (NSDictionary *)remoteNotification;
    }
//    NSDictionary * dic = [notification objectForKey:@"aps"];
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage sendClickReportForRemoteNotification:notification];
//    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"通知" message:[dic objectForKey:@"alert"] delegate:nil cancelButtonTitle:@"忽略" otherButtonTitles:@"查看", nil];
//    [alertView show];
    _pushNotification = notification;
    NSLog(@"%@",notification);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"%@",notification);
    NSLog(@"接,收本地通知啦！！！");
}


//share config
- (void)umengShareConfig{
    [UMSocialData setAppKey:uMengAppKey];
    [UMSocialData openLog:NO];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:ShareKey_WeChat appSecret:ShareKey_WeChatSecret url:webUrl];
    //设置qq
    [UMSocialQQHandler setQQWithAppId:ShareKey_TencentWB appKey:ShareKey_TencentSecret url:@"http://www.umeng.com/social"];

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

#pragma mark - 注册友盟的消息推送
- (void)registerUMessageNotification:(NSDictionary *)launchOptions{
    //set AppKey and LaunchOptions
    [UMessage startWithAppkey:uMengAppKey launchOptions:launchOptions];
    
    //register remoteNotification types
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    //for log
    [UMessage setLogEnabled:NO];
}


@end
