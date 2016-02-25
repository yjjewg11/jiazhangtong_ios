//
//  UIColor+MFColor.m
//  maifangbao
//
//  Created by whb on 15/5/24.
//  Copyright (c) 2015年 whb. All rights reserved.
//


#import "KGTabBarViewController.h"
#import "LoginViewController.h"
#import "AddressBooksViewController.h"
#import "MessageViewController.h"
#import "MeViewController.h"
#import "KGNavigationController.h"
#import "KGHttpService.h"
#import "UIColor+Extension.h"
#import "UIColor+flat.h"
#import "SpCourseHomeVC.h"
#import "DiscorveryVC.h"
#import "MineHomeVC.h"
#import "FPHomeVC.h"

#import "HomeVC.h"

@interface KGTabBarViewController ()

@end

@implementation KGTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    HomeVC * home = [[HomeVC alloc] init];
    [self addChildVc:home title:@"学校" image:@"hxuexiao" selectedImage:@"hxuexiao2"];
    
    
    DiscorveryVC * vc = [[DiscorveryVC alloc] init];
    [self addChildVc:vc title:@"发现" image:@"hfaxian" selectedImage:@"hfaxian2"];
    
    MessageViewController * messageController = [[MessageViewController alloc] init];
    [self addChildVc:messageController title:@"消息" image:@"hxiaoxi" selectedImage:@"hxiaoxi2"];
    
    FPHomeVC * fpVC = [[FPHomeVC alloc] init];
    [self addChildVc:fpVC title:@"家庭相册" image:@"jiatingxiangce1" selectedImage:@"jiatingxiangce2"];
    
    MineHomeVC * homeVC = [[MineHomeVC alloc] init];
    [self addChildVc:homeVC title:@"我的" image:@"hwode" selectedImage:@"hwode3"];
    
    // 2.更换系统自带的tabbar
    [KGHttpService sharedService].tabBarViewController = self;
//    self.tabBar.delegate = self;
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
//    统计点击事件
    switch (item.tag) {
        case 100:
            [self umengEvent:@"schoolCount" attributes:@{@"name":@"iphone"} number:@(1)];
            break;
        case 101:
            [self umengEvent:@"findCount" attributes:@{@"name":@"iphone"} number:@(1)];
            break;
        case 102:
            [self umengEvent:@"informationCount" attributes:@{@"name":@"iphone"} number:@(1)];
            break;
        case 103:
            [self umengEvent:@"familyAlbum" attributes:@{@"name":@"iphone"} number:@(1)];
            break;
        case 104:
            [self umengEvent:@"myInfo" attributes:@{@"name":@"iphone"} number:@(1)];
            break;
        default:
            break;
    }
}
#pragma mark - UM 点击统计

- (void)umengEvent:(NSString *)eventId attributes:(NSDictionary *)attributes number:(NSNumber *)number
{
    NSString * numberKey = @"__ct__";
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:attributes];
    [mutableDictionary setObject:[number stringValue] forKey:numberKey];
    [MobClick event:eventId attributes:mutableDictionary];
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
    //设置item的tag
   
    if ([title isEqualToString:@"学校"]) {
        childVc.tabBarItem.tag = 100;
    }
    else if([title isEqualToString:@"发现"])
    {
        childVc.tabBarItem.tag = 101;
    }
    else if([title isEqualToString:@"消息"])
    {
        childVc.tabBarItem.tag = 102;
    }
    else if([title isEqualToString:@"家庭相册"])
    {
        childVc.tabBarItem.tag = 103;
    }
    else if([title isEqualToString:@"我的"])
    {
        childVc.tabBarItem.tag = 104;
    }
    // 设置子控制器的图片
    childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (bIsIos7) {
        childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
