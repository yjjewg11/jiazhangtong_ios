//
//  FuniHttpUrl.m
//  kindergartenApp
//
//  Created by You on 15/6/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGHttpUrl.h"

#define URL(baseURL, businessURL) [NSString stringWithFormat:@"%@%@", baseURL, businessURL];

#define baseServiceURL       @"http://120.25.248.31/px-mobile/"      //正式
#define dynamicMenuURL       @"rest/userinfo/getDynamicMenu.json"    //首页动态菜单
#define loginURL             @"rest/userinfo/login.json"             //登录
#define logoutURL            @"rest/userinfo/logout.json"            //登出
#define regURL               @"rest/userinfo/reg.json"               //注册
//#define updatepasswordURL    @"rest/userinfo/updatepassword.json"    //修改密码
#define updatepasswordURL    @"rest/userinfo/updatepasswordBySms.json"  //修改密码
#define phoneCodeURL         @"rest/sms/sendCode.json"               //短信验证码
#define classNewsMyURL           @"rest/classnews/getClassNewsByMy.json"   //我的孩子班级互动列表
#define classNewsByClassIdURL  @"rest/classnews/getClassNewsByClassuuid.json"   //班级互动列表
#define classNewsHTMLURL  @"kd/index.html?fn=phone_myclassNews"   //班级互动列表HTML


#define groupListURL          @"rest/group/list.json" //获取机构列表


#define announcementListURL   @"rest/announcements/queryMy.json"               //公告列表
#define myChildrenURL         @"rest/student/listByMyChildren.json"               //我的孩子列表
#define saveChildrenURL       @"rest/student/save.json"                           //保存孩子信息
#define saveDZURL             @"rest/dianzan/save.json"             //点赞
#define delDZURL              @"rest/dianzan/delete.json"           //取消点赞
#define dzListURL             @"rest/dianzan/getByNewsuuid.json"    //点赞列表
#define saveReplyURL          @"rest/reply/save.json"               //回复
#define delReplyURL           @"rest/classnewsreply/delete.json"    //取消回复
#define replyListURL          @"rest/reply/getReplyByNewsuuid.json" //回复列表

#define uploadImgURL          @"rest/uploadFile/upload.json"  //上传图片

#define messageListURL        @"rest/pushMessage/queryMy.json" //消息列表

#define teacherAndJudgesURL   @"rest/userinfo/getTeachersAndJudges.json" //评价老师列表
#define saveTeacherJudgesURL  @"rest/teachingjudge/save.json" //评价老师

#define saveTeacherJudgesURL  @"rest/teachingjudge/save.json" //通讯录

@implementation KGHttpUrl

//首页动态菜单
+ (NSString *)getDynamicMenuUrl {
    return URL(baseServiceURL, dynamicMenuURL);
}


//获取机构列表
+ (NSString *)getGroupUrl {
    return URL(baseServiceURL, groupListURL);
}

//login
+ (NSString *)getLoginUrl {
    return URL(baseServiceURL, loginURL);
}


//logout
+ (NSString *)getLogoutUrl {
    return URL(baseServiceURL, logoutURL);
}


//reg
+ (NSString *)getRegUrl {
    return URL(baseServiceURL, regURL);
}


//updatepassword
+ (NSString *)getUpdatepasswordUrl {
    return URL(baseServiceURL, updatepasswordURL);
}


//phone code
+ (NSString *)getPhoneCodeUrl {
    return URL(baseServiceURL, phoneCodeURL);
}


//AnnouncementList
+ (NSString *)getAnnouncementListUrl {
    return URL(baseServiceURL, announcementListURL);
}


//Announcement Info
+ (NSString *)getAnnouncementInfoUrl:(NSString *)uuid {
    return [NSString stringWithFormat:@"%@rest/announcements/%@.json", baseServiceURL, uuid];
}


//MyChildren
+ (NSString *)getMyChildrenUrl {
    return URL(baseServiceURL, myChildrenURL);
}


//SaveChildren
+ (NSString *)getSaveChildrenUrl {
    return URL(baseServiceURL, saveChildrenURL);
}


//根据互动UUID获取单个互动详情
+ (NSString *)getClassNewsByIdUrl:(NSString *)uuid {
    return [NSString stringWithFormat:@"%@rest/classnews/%@.json", baseServiceURL, uuid];
}


//分页获取班级互动列表
+ (NSString *)getClassNewsByClassIdUrl {
    return URL(baseServiceURL, classNewsByClassIdURL);
}

//班级互动HTML 地址
+ (NSString *)getClassNewsHTMLURL {
    return URL(baseServiceURL, classNewsHTMLURL);
}


//分页获取我的孩子相关班级互动列表
+ (NSString *)getClassNewsMyByClassIdUrl {
    return URL(baseServiceURL, classNewsMyURL);
}



//更新学生资料
+ (NSString *)getSaveStudentInfoUrl {
    return URL(baseServiceURL, saveChildrenURL);
}


//点赞
+ (NSString *)getSaveDZUrl {
    return URL(baseServiceURL, saveDZURL);
}


//取消点赞
+ (NSString *)getDelDZUrl {
    return URL(baseServiceURL, delDZURL);
}


//点赞列表
+ (NSString *)getDZListUrl {
    return URL(baseServiceURL, dzListURL);
}

//回复
+ (NSString *)getSaveReplyUrl {
    return URL(baseServiceURL, saveReplyURL);
}

//取消回复
+ (NSString *)getDelReplyUrl {
    return URL(baseServiceURL, delReplyURL);
}

//回复列表
+ (NSString *)getReplyListUrl {
    return URL(baseServiceURL, replyListURL);
}

///上传图片
+ (NSString *)getUploadImgUrl {
    return URL(baseServiceURL, uploadImgURL);
//    return @"http://120.25.127.141/runman-rest/rest/uploadFile/upload.json";
}

//消息列表
+ (NSString *)getMessageListUrl {
    return URL(baseServiceURL, messageListURL);
}


//评价老师列表
+ (NSString *)getTeacherListUrl {
    return URL(baseServiceURL, teacherAndJudgesURL);
}

//评价老师
+ (NSString *)getSaveTeacherJudgeUrl {
    return URL(baseServiceURL, saveTeacherJudgesURL);
}



@end
