//
//  FuniDateUtil.m
//  funiApp
//
//  Created by You on 13-5-18.
//  Copyright (c) 2013年 you. All rights reserved.
//

#import "KGDateUtil.h"


@implementation KGDateUtil

+ (NSString *)getTime{
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * na = [df stringFromDate:currentDate];
    
    return na;
}


//毫秒时间
+ (NSString *)millisecond
{
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970]*1000;
    NSInteger i=time;      //NSTimeInterval返回的是double类型
    return [NSString stringWithFormat:@"%ld",(long)i];
}

//当前时间
+ (NSString *)presentTime
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmss"];
    NSString *date =  [formatter stringFromDate:[NSDate date]];
    NSString *timeLocal = [[NSString alloc] initWithFormat:@"%@", date];
    return timeLocal;
}

/**
 * 计算指定时间是否大雨指定分钟数
 */
+(BOOL)isReload:(NSDate *)compareDate loadTime:(NSInteger)loadTime{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    BOOL  result = NO;
    if(timeInterval > loadTime*60){
        result = YES;
    }
    return  result;
}

//时间格式的字符串转日期对象
+ (NSDate *)getDateByDateStr:(NSString *)str format:(NSString *)formatStr {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatStr];
    return [dateFormatter dateFromString:str];
}


@end
