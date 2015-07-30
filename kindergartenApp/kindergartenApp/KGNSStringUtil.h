//
//  FuniNSStringUtil.h
//  funiApp
//
//  Created by You on 13-6-22.
//  Copyright (c) 2013年 you. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGNSStringUtil : NSObject

+ (NSString *)getServiceImgSuffix:(NSString *)_imgPath;

+ (NSString *)formatImagePath:(NSString *)imgPath size:(NSString *)size;

//获得字符串大小
+ (CGSize)getNSStringSize:(NSString *)string font:(CGFloat)fontSize fSize:(CGSize)fSize;

//获取uuid
+ (NSString *)gen_uuid;


/**
 * 判断str里面是否包含数字
 * @return   YES包含   NO不包含
 */
+ (BOOL)isIncludeNumber:(NSString *)str;


/**
 *  判断是否为整形
 *
 *  @param string 源字符串
 *
 *  @return 返回是否整形
 */
+ (BOOL)isPureInt:(NSString*)str;


/**
 *  判断是否为浮点形
 *
 *  @param string 源字符串
 *
 *  @return 返回是否浮点
 */
+ (BOOL)isPureFloat:(NSString*)str;


/**
 *  判空
 *
 *  @param string 源字符串
 *
 *  @return 返回是否为空
 */
+ (BOOL)isEmpty:(NSString *)str;



+ (NSString *)trimString:(NSString *)str;


/**
 *  将文本转换为base64格式字符串
 *
 *  @param text <#text description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)base64StringFromText:(NSString *)text;


/**
 *  将base64格式字符串转换为文本
 *
 *  @param base64 <#base64 description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)textFromBase64String:(NSString *)base64;


+ (NSString *)md5:(NSString *)str;


/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+ (NSString *)compareCurrentTime:(NSDate*)compareDate;

@end
