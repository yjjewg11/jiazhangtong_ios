//
//  UIColor+MFColor.m
//  maifangbao
//
//  Created by whb on 15/5/24.
//  Copyright (c) 2015年 whb. All rights reserved.
//


#import "UIWindow+Extension.h"
#import "KGAccountTool.h"
#import "KGUser.h"
#import "KGTabBarViewController.h"
#import "LoginViewController.h"
#import "KGNavigationController.h"
#import "KGHttpService.h"
#import "KGHUD.h"

@implementation UIWindow (Extension)

- (void)switchRootViewController
{
    //    NSString *key = @"CFBundleVersion";
    // 上一次的使用版本（存储在沙盒中的版本号）
    //    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    // 当前软件的版本号（从Info.plist中获得）
    //    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    [self notAllowedEntner];
//    [self autoLoginJessionid];
    
    return;
    if (YES) { // 版本号相同：这次打开和上次打开的是同一个版本
        //登陆页面
        //判断是否已经登陆，如果登陆直接跳到首页，否者跳到登陆页面
        KGUser * account = [KGAccountTool account];
        
       
        if (!account) {//没有登陆
            self.rootViewController  = [[KGNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        }else{//直接跳转到首页
            [self autoLogin:account];
            self.rootViewController = [[KGTabBarViewController alloc] init];
        }
        [self makeKeyAndVisible];
        
    }
    //    else { // 这次打开的版本和上一次不一样，显示新特性
    //
    //        //新特性页面
    //        self.rootViewController = [[MFBNewfeatureViewController alloc] init];
    //
    //        // 将当前的版本号存进沙盒
    //        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
    //        [[NSUserDefaults standardUserDefaults] synchronize];
    //    }
}


- (void)autoLogin:(KGUser *)user {
    
    


    [[KGHttpService sharedService] login:user success:^(NSString *msgStr) {
        [self allowedEntner];
    } faild:^(NSString *errorMsg) {
//         [UIApplication sharedApplication].keyWindow;
        [[KGHUD sharedHud] show:self onlyMsg:errorMsg];
        self.rootViewController  = [[KGNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    }];
}
//验证不通过允许进入
- (void)notAllowedEntner{
    self.rootViewController  = [[KGNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    [self makeKeyAndVisible];

}
//验证通过允许进入
- (void)allowedEntner{
      [GuidePageController firstLaunch];
    
    [self makeKeyAndVisible];

 
}
//第三方登录
- (void)autoLoginThirdAccessToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *access_token=[defaults objectForKey:KEY_thirdLogin_access_token];
    NSString *type=[defaults objectForKey:KEY_thirdLogin_type];
    
    if(access_token.length>0&&type.length>0){
        [self userinfo_thirdLogin:access_token type:type];
    }
    
    [self notAllowedEntner];
}

/**
 access_token
 String
 是
 票据
 type
 String
 是
 取值:qq, weixin
 */
- (void)userinfo_thirdLogin: (NSString *)access_token type:(NSString *)type{
    
    NSDictionary *  dic=@{@"access_token":access_token,@"type":type};
    NSString * url=[NSString stringWithFormat:@"%@%@", [KGHttpUrl getBaseServiceURL], @"rest/userinfo/thirdLogin.json"];
    [[KGHUD sharedHud] show:self.rootViewController.view msg:@"登录中..."];
    
    [[KGHttpService sharedService] postByDicByParams:url param:dic success:^(id success) {
        [[KGHUD sharedHud] hide:self.rootViewController.view];
        LoginRespDomain *loginRespDomain = [LoginRespDomain objectWithKeyValues:success];
        [KGHttpService sharedService].loginRespDomain = loginRespDomain;
        [KGHttpService sharedService].userinfo=loginRespDomain.userinfo;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:loginRespDomain.JSESSIONID forKey:Key_loginJessionID];
        [defaults setObject:type forKey:KEY_thirdLogin_type];
        [defaults setObject:access_token forKey:KEY_thirdLogin_access_token];
        [defaults synchronize];
        
      [self allowedEntner];
        
        
        
    } failed:^(NSString *errorMsg) {
        [[KGHUD sharedHud] hide:self.rootViewController.view];
        [self notAllowedEntner];

    }];
    
    
    
    
}
#pragma mark - 自动登录
- (void)autoLoginJessionid
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * jid =  [defaults objectForKey:Key_loginJessionID];
    NSLog(@"local jessionid %@",jid);
    
    if(jid<1){
        [self autoLoginThirdAccessToken];
        return;
    }
    {
        [[KGHUD sharedHud] show: self.rootViewController];
        
        
        [[KGHttpService sharedService] cheakUserJessionID:jid success:^(NSString *msgStr)
         {
             
             [ [KGHUD sharedHud] hide:  self.rootViewController ];
          
             if ([msgStr isEqualToString:@"success"])
             {
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    [self allowedEntner];
                                });
             }
             else
             {
                 [self autoLoginThirdAccessToken];
             }
             
         }faild:^(NSString *errorMsg)
         {
             [self autoLoginThirdAccessToken];
         }];
    }
}

@end
