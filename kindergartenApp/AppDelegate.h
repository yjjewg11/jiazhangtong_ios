//
//  AppDelegate.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/5/30.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import "SPKitExample.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController *navigationController;
    BMKMapManager* _mapManager;
}
@property (strong, nonatomic) UIWindow * window;

+ (AppDelegate *)appDelegate;


@end

