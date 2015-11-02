//
//  MFAccountTool.h
//  maifangbao
//  账号处理
//  Created by whb on 15/5/23.
//  Copyright (c) 2015年 whb. All rights reserved.
//

#import "KGUser.h"

@interface KGAccountTool : NSObject

/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(KGUser *)account;


+ (void)delAccount;

/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (KGUser *)account;

@end
