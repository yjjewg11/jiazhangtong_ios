//
//  ParentInfoUpdateDomain.h
//  kindergartenApp
//
//  Created by liumingquan on 16/4/19.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

/**
 email
 name		必填	姓名
 img			头像地址
 relname	String		真实姓名

 */
@interface ParentInfoUpdateDomain : KGBaseDomain
@property (strong, nonatomic) NSString       * name;
@property (strong, nonatomic) NSString       * img;
@property (strong, nonatomic) NSString       * realname;
@property (strong, nonatomic) NSString       * email;


@property (strong, nonatomic) NSString * tel;


@end
