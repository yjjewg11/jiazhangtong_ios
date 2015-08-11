//
//  UIColor+MFColor.m
//  maifangbao
//
//  Created by whb on 15/5/24.
//  Copyright (c) 2015年 whb. All rights reserved.
//


#import "KGTabBarViewController.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "AddressBooksViewController.h"
#import "MessageViewController.h"
#import "MeViewController.h"
#import "KGNavigationController.h"
#import "KGHttpService.h"
#import "UIColor+Extension.h"

@interface KGTabBarViewController ()
@end

@implementation KGTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.初始化子控制器
    HomeViewController * home = [[HomeViewController alloc] init];
    [self addChildVc:home title:@"首页" image:@"zhuye2" selectedImage:@"zhuye1"];
    
    AddressBooksViewController * addressBooksVC = [[AddressBooksViewController alloc] init];
    [self addChildVc:addressBooksVC title:@"通讯录" image:@"tongxunlu2" selectedImage:@"tongxunlu1"];

    MessageViewController * messageController = [[MessageViewController alloc] init];
    [self addChildVc:messageController title:@"消息" image:@"xiaoxi2" selectedImage:@"xiaoxi1"];
    
    MeViewController * meController = [[MeViewController alloc] init];
    [self addChildVc:meController title:@"我的" image:@"wode1" selectedImage:@"wode2"];
    
    // 2.更换系统自带的tabbar
    [KGHttpService sharedService].tabBarViewController = self;

}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    if (bIsIos7) {
        childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    }
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = KGColor(123, 123, 123, 1);
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = KGColor(273, 36, 44, 1);
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    KGNavigationController *nav = [[KGNavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
}


@end
