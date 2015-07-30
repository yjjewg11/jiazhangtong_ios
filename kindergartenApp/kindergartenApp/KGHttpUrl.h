//
//  FuniHttpUrl.h
//  kindergartenApp
//
//  Created by You on 15/6/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGHttpUrl : NSObject

//首页动态菜单
+ (NSString *)getDynamicMenuUrl;

//获取机构列表
+ (NSString *)getGroupUrl;

//login
+ (NSString *)getLoginUrl;


//logout
+ (NSString *)getLogoutUrl;


//reg
+ (NSString *)getRegUrl;


//updatepassword
+ (NSString *)getUpdatepasswordUrl;


//phone code
+ (NSString *)getPhoneCodeUrl;


//AnnouncementList
+ (NSString *)getAnnouncementListUrl;


//Announcement Info
+ (NSString *)getAnnouncementInfoUrl:(NSString *)uuid;


//MyChildren
+ (NSString *)getMyChildrenUrl;


//SaveChildren
+ (NSString *)getSaveChildrenUrl;


//根据互动UUID获取单个互动详情
+ (NSString *)getClassNewsByIdUrl:(NSString *)uuid;


//分页获取班级互动列表
+ (NSString *)getClassNewsByClassIdUrl;

//班级互动HTML 地址
+ (NSString *)getClassNewsHTMLURL;


//分页获取我的孩子相关班级互动列表
+ (NSString *)getClassNewsMyByClassIdUrl;


//更新学生资料
+ (NSString *)getSaveStudentInfoUrl;

//点赞
+ (NSString *)getSaveDZUrl;

//取消点赞
+ (NSString *)getDelDZUrl;

//点赞列表
+ (NSString *)getDZListUrl;

//回复
+ (NSString *)getSaveReplyUrl;

//取消回复
+ (NSString *)getDelReplyUrl;

//回复列表
+ (NSString *)getReplyListUrl;

//上传图片
+ (NSString *)getUploadImgUrl;


//消息列表
+ (NSString *)getMessageListUrl;

//评价老师列表
+ (NSString *)getTeacherListUrl;

//评价老师
+ (NSString *)getSaveTeacherJudgeUrl;




@end
