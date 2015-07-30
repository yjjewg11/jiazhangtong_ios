//
//  FuniKeyChain.h
//  funiiPhoneApp
//
//  Created by You on 14/12/5.
//  Copyright (c) 2014年 LQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FuniKeyChain : NSObject


/**
 *  保存数据到KeyChain
 *
 *  @param service key
 *  @param data    需要保存的数据
 */
+ (void)save:(NSString *)service data:(id)data;


/**
 *  从KeyChain获取制定key数据
 *
 *  @param service key
 *
 *  @return 返回获取的数据
 */
+ (id)load:(NSString *)service;


/**
 *  删除指定key数据
 *
 *  @param service key
 */
+ (void)delete:(NSString *)service;

@end
