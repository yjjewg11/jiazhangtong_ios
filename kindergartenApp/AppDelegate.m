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
//#import "UMFeedback.h"
#import "UMSocialQQHandler.h"
#import "UMessage.h"
#import "KGNavigationController.h"
#import "LoginViewController.h"
#import "KGHUD.h"
#import "KGAccountTool.h"
#import <Bugly/Bugly.h>
#import "EZOpenSDK.h"



#define BUGLY_APP_ID @"900009876"


#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define RemoveHUDNotification @"RemoveHUD"

#define NewMessageKey @"newMessage"

@interface AppDelegate ()<BMKGeneralDelegate>


@end

@implementation AppDelegate


+ (AppDelegate *)appDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]  delegate];
}

//
//
//
//- (void)umengTrack {
////    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行]
//    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    [MobClick setAppVersion:version];//参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
//    //
//    [MobClick startWithAppkey:uMengAppKey reportPolicy:(ReportPolicy)BATCH channelId:nil];
//    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
//    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
//    
//    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
//    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
//    
//    [MobClick updateOnlineConfig];  //在线参数配置
//    
//    //    1.6.8之前的初始化方法
//    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
//    
//}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
 
      // 从这到当前方法结束是您的业务代码
    NSLog(@"Path:%@", NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));
    
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
//    [UMFeedback setAppkey:uMengAppKey];
    //设置友盟更新
//    [self umengTrack];
    //友盟分享
    [self umengShareConfig];
    //设置友盟推送消息
    [self registerUMessageNotification:launchOptions];
    
    //消除icon badge
    [self clearBadge];
    
    
    //关闭友盟Crash收集
//    [MobClick setCrashReportEnabled:NO];
//    [MobClick setLogEnabled:NO];
//    
    
    
    [self setupBugly];
    

//    [Bugly startWithAppId:@"900009876"];
    
    //注册SessionTimeout通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionTimeoutNotification:) name:Key_Notification_SessionTimeout object:nil];
    
    [self loadMessageList:launchOptions];
    
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"IoiA8xNOSEe2EuMR49NDjYKp"  generalDelegate:self];
    if (!ret)
    {
        NSLog(@"百度地图 manager start failed!");
    }
    [EZOpenSDK initLibWithAppKey:@"44b89d0bea824201ad557c48f73635d9"];
    

    return YES;
}
//
//static int exception_callback_handler() {
//    NSLog(@"bugly exception callback handler");
//    
//    NSException * exception = [[CrashReporter sharedInstance] getCurrentException];
//    if (exception) {
//        // 捕获的Obj-C异常
//    }
//    
//    // 捕获的错误信号堆栈
//    NSString * callStack = [[CrashReporter sharedInstance] getCrashStack];
//    NSLog(@" %@", callStack);
//    
//    KGUser * userinfo = [KGAccountTool account];
//    
//    // 设置崩溃场景的附件
//    if (userinfo) {
//        [[CrashReporter sharedInstance] setUserData:@"用户身份" value:userinfo.loginname];
//    }else{
//        [[CrashReporter sharedInstance] setUserData:@"用户身份" value:@"未登录用户"];
//    }
//    
//    [[CrashReporter sharedInstance] setAttachLog:@"业务关键日志"];
//    
//    return 1;
//}
//
//// 自定义Bugly配置
//- (void)customizeBuglySDKConfig {
//    // 调试阶段开启sdk日志打印, 发布阶段请务必关闭
//#if DEBUG == 1
//    [[CrashReporter sharedInstance] enableLog:YES];
//#endif
//    
//    // SDK默认采用BundleShortVersion(BundleVersion)的格式作为版本,如果你的应用版本不是采用这样的格式，你可以通过此接口设置
//    //    [[CrashReporter sharedInstance] setBundleVer:@"1.0.2"];
//    
//    // 如果你的App有对应的发布渠道(如AppStore),你可以通过此接口设置, 默认值为unknown,
//    [[CrashReporter sharedInstance] setChannel:@"测试渠道"];
//    KGUser * userinfo = [KGAccountTool account];
//    // 你可以在初始化之前设置本地保存的用户身份, 也可以在用户身份切换后调用此接口即时修改
//    [[CrashReporter sharedInstance] setUserId:[NSString stringWithFormat:@"测试用户:%@", userinfo.loginname]];
//    
//    // 关闭卡顿监听上报
//    [[CrashReporter sharedInstance] enableBlockMonitor:NO autoReport:NO];
//    
//    // 关闭进程内符号化处理, SDK默认开启此功能, 如果开启, 请检查Xcode工程配置Strip Style不能为ALL Symbols
//    [[CrashReporter sharedInstance] setEnableSymbolicateInProcess:NO];
//    
//    // 自定义崩溃处理回调函数
//    exp_call_back_func = &exception_callback_handler;
//}

- (void)sessionTimeoutNotification:(NSNotification *)notification
{
    self.window.rootViewController  = [[KGNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    [self.window makeKeyAndVisible];
    [[KGHUD sharedHud] show:self.window onlyMsg:@"登录超时,请重新登录."];
}

//打开app 直接定位到消息页
- (void)loadMessageList:(NSDictionary *)launchOptions {
    UILocalNotification * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(remoteNotification){
        //从通知栏打开app 直接定位到消息页
        __weak KGTabBarViewController * tabVC = (KGTabBarViewController*)self.window.rootViewController;
        tabVC.selectedIndex = Number_Two;
    }
}

//清除Badge
- (void)clearBadge{
    if(bIsIos8){
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [UIApplication sharedApplication].applicationIconBadgeNumber = Number_Zero;
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert];
        [UIApplication sharedApplication].applicationIconBadgeNumber = Number_Zero;
    }
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    
    return UIInterfaceOrientationMaskAll;
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
    [application registerForRemoteNotifications];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:String_DefValue_Arrows]];
    
    NSArray * strAry = [token componentsSeparatedByString:String_DefValue_EmptyStr];
    NSMutableString * key = [NSMutableString stringWithString:String_DefValue_Empty];
    for(NSString * str in strAry){
        [key appendString:str];
    }
    
    if(![key isEqualToString:String_DefValue_Empty]){
        [self savePushToken:key];
    }
    
//    [UMessage registerDeviceToken:deviceToken];
}

//save token
- (void)savePushToken:(NSString *)key{
    KeychainItemWrapper * wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:Key_KeyChain accessGroup:nil];
    
    [KGHttpService sharedService].pushToken = key;
    id temp = [[NSUserDefaults standardUserDefaults] objectForKey:NewMessageKey];
    if (temp == nil) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:NewMessageKey];
    }
    NSString * status;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:NewMessageKey]) {
        status = @"0";
    }else{
        status = @"2";
    }
    
    [[KGHttpService sharedService] submitPushTokenWithStatus:status success:^(NSString *msgStr) {
        [wrapper setObject:key forKey:(__bridge id)kSecAttrAccount];
    } faild:^(NSString *errorMsg) {
        
    }];
        
}


// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
//    NSLog(@"DeviceToken 获取失败，原因：%@",error);
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
    
    if([ self.window.rootViewController isKindOfClass:[KGTabBarViewController class]]){
        
        __weak KGTabBarViewController * tabVC = (KGTabBarViewController*)self.window.rootViewController;
        if(tabVC.selectedIndex != Number_Two) {
            UIViewController * vc = [tabVC.childViewControllers objectAtIndex:Number_Two];
            vc.tabBarItem.image = [[UIImage imageNamed:@"zhuye_xinxiaoxi"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }

    }
    
    
//    NSDictionary * dic = [notification objectForKey:@"aps"];
    //关闭友盟自带的弹出框
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:notification];
    
//    [UMessage setAutoAlert:NO];
//    [UMessage sendClickReportForRemoteNotification:notification];
//    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"通知" message:[dic objectForKey:@"alert"] delegate:nil cancelButtonTitle:@"忽略" otherButtonTitles:@"查看", nil];
//    [alertView show];
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
    [UMSocialQQHandler setQQWithAppId:ShareKey_TencentWB appKey:ShareKey_TencentSecret url:webUrl];

    //打开新浪微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //打开腾讯微博SSO开关，设置回调地址  因腾讯微博sdk暂未提供64位SDK 所以友盟也没法增加针对腾讯微博的64位处理
    //    [UMSocialTencentWeiboHandler openSSOWithRedirectUrl:@"http://sns.whalecloud.com/tencent2/callback"];
}

-(BOOL)myRUL_handleOpenURL:(NSURL *)url{
    
    if ([url.description hasPrefix:@"wjkj.jiazhangtong://"]) {
        //你的处理逻辑
        
        return YES;
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //你的处理逻辑

    if([self myRUL_handleOpenURL:url])return YES;
   
    
    BOOL judge = [UMSocialSnsService handleOpenURL:url];
    return judge;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    //你的处理逻辑
    
    if([self myRUL_handleOpenURL:url])return YES;
    
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

- (void)applicationDidEnterBackground:(UIApplication *)application{
    [[NSNotificationCenter defaultCenter] postNotificationName:RemoveHUDNotification object:nil];
}

#pragma mark - 注册友盟的消息推送
- (void)registerUMessageNotification:(NSDictionary *)launchOptions{
    
    
    //设置 AppKey 及 LaunchOptions
    [UMessage startWithAppkey:uMengAppKey launchOptions:launchOptions];
    //注册通知
    [UMessage registerForRemoteNotifications];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            
        } else {
            //点击不允许
            
        }
    }];

    
    //for log
    
#if DEBUG
     [UMessage setLogEnabled:YES];
#endif
    
   
    //set AppKey and LaunchOptions
//    [UMessage startWithAppkey:uMengAppKey launchOptions:launchOptions];
//    
//    //register remoteNotification types
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
//    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
//    {
//        //register remoteNotification types
//        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
//        action1.identifier = @"action1_identifier";
//        action1.title=@"Accept";
//        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
//        
//        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
//        action2.identifier = @"action2_identifier";
//        action2.title=@"Reject";
//        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
//        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
//        action2.destructive = YES;
//        
//        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
//        categorys.identifier = @"category1";//这组动作的唯一标示
//        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
//        
//        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
//                                                                                     categories:[NSSet setWithObject:categorys]];
//        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
//        
//    } else{
//        //register remoteNotification types
//        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
//         |UIRemoteNotificationTypeSound
//         |UIRemoteNotificationTypeAlert];
//    }
//#else
//    
//    //register remoteNotification types
//    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
//     |UIRemoteNotificationTypeSound
//     |UIRemoteNotificationTypeAlert];
//    
//#endif
//    //for log
//    [UMessage setLogEnabled:NO];
}

/**
 *返回网络错误
 *@param iError 错误号
 */
- (void)onGetNetworkState:(int)iError
{
    
}

/**
 *返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKPermissionCheckResultCode
 */
- (void)onGetPermissionState:(int)iError
{
    
}



- (void)setupBugly {
    // Get the default config
    BuglyConfig * config = [[BuglyConfig alloc] init];
    
    // Open the debug mode to print the sdk log message.
    // Default value is NO, please DISABLE it in your RELEASE version.
#if DEBUG
    config.debugMode = YES;
#endif
    
    // Open the customized log record and report, BuglyLogLevelWarn will report Warn, Error log message.
    // Default value is BuglyLogLevelSilent that means DISABLE it.
    // You could change the value according to you need.
    config.reportLogLevel = BuglyLogLevelWarn;
    
    // Open the STUCK scene data in MAIN thread record and report.
    // Default value is NO
    config.blockMonitorEnable = YES;
    
    // Set the STUCK THRESHOLD time, when STUCK time > THRESHOLD it will record an event and report data when the app launched next time.
    // Default value is 3.5 second.
    config.blockMonitorTimeout = 1.5;
    
    // Set the app channel to deployment
    config.channel = @"Bugly";
    
    config.delegate = self;
    
    config.blockMonitorEnable=YES;
    config.unexpectedTerminatingDetectionEnable=YES;
    config.appTransportSecurityEnable=YES;
    config.symbolicateInProcessEnable=YES;
    // NOTE:Required
    // Start the Bugly sdk with APP_ID and your config
    [Bugly startWithAppId:BUGLY_APP_ID
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
    
    // Set the customizd tag thats config in your APP registerd on the  bugly.qq.com
    // [Bugly setTag:1799];
    
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [UIDevice currentDevice].name]];
    
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
    
    // NOTE: This is only TEST code for BuglyLog , please UNCOMMENT it in your code.
    //[self performSelectorInBackground:@selector(testLogOnBackground) withObject:nil];
}

@end
