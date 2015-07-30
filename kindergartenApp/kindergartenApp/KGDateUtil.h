//
//  FuniDateUtil.h
//  funiApp
//
//  Created by You on 13-5-18.
//  Copyright (c) 2013年 you. All rights reserved.
//

#import <Foundation/Foundation.h>

#define dateFormatStr1  @"yyyy-MM-dd"
#define dateFormatStr2  @"yyyy-MM-dd HH:mm:ss"

@interface KGDateUtil : NSObject

+ (NSString *)getTime;

//毫秒时间
+ (NSString *)millisecond;

//当前时间
+ (NSString *)presentTime;

/**
 * 计算指定时间是否大雨指定分钟数
 */
+(BOOL)isReload:(NSDate*)compareDate loadTime:(NSInteger)loadTime;

//时间格式的字符串转日期对象
+ (NSDate *)getDateByDateStr:(NSString *)str format:(NSString *)formatStr;

@end
