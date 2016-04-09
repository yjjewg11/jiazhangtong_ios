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
+ (NSString *)getNowDateYMD;
+ (NSString *)getTime;

//获取过去几天日期  默认当天
+ (NSString *)getDate:(NSInteger)date;

//获取指定日期差
+ (NSString *)calculateDay:(NSString *)currentDateStr date:(NSInteger)date;

//毫秒时间
+ (NSString *)millisecond;

//当前时间
+ (NSString *)presentTime;

//获取调用接口查询条件需要的所用时间字符串格式
+ (NSString *)getFPFormatSringWithDate:(NSDate *)date;
+ (NSString *)getFPFormatSringWithDateStr:(NSString *)dateStr;
+ (NSDate *)getDateWithFPFormatString:(NSString *)string;
//获取调用接口查询条件需要的所用时间字符串格式
+ (NSString *)getQueryFormDateStringByString:(NSString *)string;
//获取调用接口查询条件需要的所用时间字符串格式
+ (NSString *)getQueryFormDateStringByDate:(NSDate *)date;

/**
 * 计算指定时间是否大雨指定分钟数
 */
+(BOOL)isReload:(NSDate*)compareDate loadTime:(NSInteger)loadTime;

//时间格式的字符串转日期对象
+ (NSDate *)getDateByDateStr:(NSString *)str format:(NSString *)formatStr;

//获取指定日期的周一
+ (NSString *)getBeginWeek:(NSString *)dateStr;

//获取指定日期的周五
+ (NSString *)getEndWeek:(NSString *)dateStr;

//输入参数是日期字符串，输出结果是星期几的数字。
+ (NSInteger)weekdayStringFromDate:(NSString *)inputDateStr;

//输入参数是日期字符串，输出结果是星期几。
+ (NSString *)weekdayFromDate:(NSString *)inputDateStr;

//计算相差几天
+ (NSInteger)intervalSinceNow: (NSString *) theDate;

//获取当前时区时间
+ (NSDate *)getLocalDate;

+ (NSString *)getLocalDateStr;
+ (NSString *)getDateStrByNSDate: (NSDate *)date;
+ (NSString *)getDateStrByNSDate: (NSDate *)date format:(NSString *)formatStr;

@end
