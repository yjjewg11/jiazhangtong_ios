//
//  MFAccountTool.m
//  maifangbao
//
//  Created by whb on 15/5/23.
//  Copyright (c) 2015年 whb. All rights reserved.
//

#import "KGAccountTool.h"

@implementation KGAccountTool

/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(KGUser *)account
{
    // 自定义对象的存储必须用NSKeyedArchiver，不再有什么writeToFile方法
    [NSKeyedArchiver archiveRootObject:account toFile:KGAccountPath];
}



+ (void)delAccount {
    //清空沙箱中账号信息
//    NSFileManager *mgr = [NSFileManager defaultManager];
    //    [mgr removeItemAtPath:MFAccountPath error:nil];
    [NSKeyedArchiver archiveRootObject:nil toFile:KGAccountPath];
}


/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (KGUser *)account
{
    // 加载模型
    KGUser *account = [NSKeyedUnarchiver unarchiveObjectWithFile:KGAccountPath];
    return account;
}


@end
