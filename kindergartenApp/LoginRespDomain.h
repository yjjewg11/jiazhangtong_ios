//
//  LoginRespDomain.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/19.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"
#import "KGUser.h"

@interface LoginRespDomain : KGBaseDomain

@property (strong, nonatomic) NSArray        * list;       //孩子列表
@property (strong, nonatomic) NSArray        * group_list; //学校列表
@property (strong, nonatomic) NSArray        * class_list; //班级列表
@property (strong, nonatomic) NSString       * JSESSIONID;
@property (strong, nonatomic) KGUser         * userinfo;


@end
