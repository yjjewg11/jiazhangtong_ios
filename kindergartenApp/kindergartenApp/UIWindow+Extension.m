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
        
    } faild:^(NSString *errorMsg) {
//         [UIApplication sharedApplication].keyWindow;
        [[KGHUD sharedHud] show:self onlyMsg:errorMsg];
        self.rootViewController  = [[KGNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    }];
}

@end
