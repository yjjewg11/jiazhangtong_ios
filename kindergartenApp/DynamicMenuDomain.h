//
//  DynamicMenuDomain.h
//  kindergartenApp
//  首页动态菜单
//  Created by yangyangxun on 15/7/25.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface DynamicMenuDomain : KGBaseDomain

@property (strong, nonatomic) NSString * name;    //菜单名

@property (strong, nonatomic) NSString * iconUrl; //图标

@property (strong, nonatomic) NSString * url;     //调用浏览器打开地址.


@end
