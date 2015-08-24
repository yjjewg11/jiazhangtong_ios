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

//绑定的卡号列表
+ (NSString *)getBuildCardUrl:(NSString *)uuid;

//获取用户信息
+ (NSString *)getUserInfoUrl:(NSString *)uuid;


//phone code
+ (NSString *)getPhoneCodeUrl;

//校园介绍
+ (NSString *)getYQJSByGroupuuid:(NSString *)groupuuid;

//招生计划
+ (NSString *)getZSJHURLByGroupuuid:(NSString *)groupuuid;


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

//新增班级互动
+ (NSString *)getSaveClassNewsUrl;

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

//特长课程
+ (NSString *)getSpecialtyCoursesUrl;

//精品文章
+ (NSString *)getArticleListUrl;

//精品文章详情
+ (NSString *)getArticleInfoListUrl:(NSString *)uuid;

//签到记录
+ (NSString *)getStudentSignRecordUrl;

//食谱列表
+ (NSString *)getRecipesListUrl;

//推送token
+ (NSString *)getPushTokenUrl;

//表情
+ (NSString *)getEmojiUrl;

//老师和园长通讯录
+ (NSString *)getTeacherPhoneBookUrl;

//给老师发消息
+ (NSString *)getSaveTeacherUrl;

//获取和老师的消息列表
+ (NSString *)getQueryByTeacherUrl;

//给园长发消息
+ (NSString *)getSaveLeaderUrl;

//获取园长消息列表
+ (NSString *)getQueryLeaderUrl;

//阅读消息
+ (NSString *)getReadMsgUrl;

//课程表
+ (NSString *)getTeachingPlanUrl;

//收藏列表
+ (NSString *)getFavoritesListUrl;

//保存收藏
+ (NSString *)getsaveFavoritesUrl;

//修改密码
+ (NSString *)getModidyPWDUrl;

//取消收藏
+ (NSString *)getDelFavoritesUrl;

@end
