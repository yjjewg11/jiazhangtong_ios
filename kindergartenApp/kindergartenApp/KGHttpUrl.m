//
//  FuniHttpUrl.m
//  kindergartenApp
//
//  Created by You on 15/6/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGHttpUrl.h"

#define URL(baseURL, businessURL) [NSString stringWithFormat:@"%@%@", baseURL, businessURL];

#define baseServiceURL       @"http://jz.wenjienet.com/px-mobile/"      //正式
#define dynamicMenuURL       @"rest/userinfo/getDynamicMenu.json"    //首页动态菜单
#define loginURL             @"rest/userinfo/login.json"             //登录
#define logoutURL            @"rest/userinfo/logout.json"            //登出
#define regURL               @"rest/userinfo/reg.json"               //注册
//#define updatepasswordURL    @"rest/userinfo/updatepassword.json"    //修改密码
#define updatepasswordURL    @"rest/userinfo/updatePasswordBySms.json"  //修改密码
#define getTeacherInfo          @"rest/userinfo/getTeacherInfo.json"        //获取用户信息
#define KDInfoURL            @"rest/share/getKDInfo.html" //校园相关
#define ZSJHInfoURL          @"rest/share/getRecruitBygroupuuid.html" //招生计划

#define teacherPhoneBookURL  @"rest/userinfo/getTeacherPhoneBook.json" //老师和园长通讯录
#define saveToTeacherURL     @"rest/message/saveToTeacher.json"  //给老师写信
#define queryByTeacherURL    @"rest/message/queryByTeacher.json" //查询和老师的信件
#define saveToLeaderURL      @"rest/message/saveToLeader.json"   //给园长写信
#define queryByLeaderURL     @"rest/message/queryByLeader.json"  //查询和园长的信件
#define readMsgURL           @"rest/pushMessage/read.json"  //阅读信件


#define phoneCodeURL           @"rest/sms/sendCode.json"               //短信验证码
#define classNewsMyURL         @"rest/classnews/getClassNewsByMy.json"   //我的孩子班级互动列表
#define classNewsByClassIdURL  @"rest/classnews/getClassNewsByClassuuid.json"   //班级互动列表
#define classNewsHTMLURL       @"kd/index.html?fn=phone_myclassNews"   //班级互动列表HTML
#define saveClassNewsHTMLURL   @"rest/classnews/save.json"   //新增班级互动

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

#define teacherAndJudgesURL   @"rest/teachingjudge/getTeachersAndJudges.json" //评价老师列表
#define saveTeacherJudgesURL  @"rest/teachingjudge/save.json" //评价老师

//#define saveTeacherJudgesURL  @"rest/teachingjudge/save.json" //通讯录
#define specialtyCoursesURL   @"px/index.html"  //特长课程
#define articleListURL        @"rest/share/articleList.json"  //精品文章
#define studentSignRecordURL  @"rest/studentSignRecord/queryMy.json"  //签到记录


#define recipesListURL        @"rest/cookbookplan/list.json"  //食谱列表
#define pushDeviceURL         @"rest/pushMsgDevice/save.json"  //推送token提交
#define emojiURL              @"rest/share/getEmot.json"      //表情
#define teachingPLanURL       @"rest/teachingplan/list.json"      //课程表

#define saveFavoritesURL      @"rest/favorites/save.json"      //保存收藏
#define favoritesListURL      @"rest/favorites/query.json"     //收藏列表
#define modifyPWDURL          @"rest/userinfo/updatepassword.json" //修改密码
#define delFavoritesURL       @"rest/favorites/delete.json"   //取消收藏


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

//获取用户信息
+ (NSString *)getUserInfoUrl:(NSString *)uuid {
    return [NSString stringWithFormat:@"%@%@?uuid=%@", baseServiceURL, getTeacherInfo, uuid];
}

//绑定的卡号列表
+ (NSString *)getBuildCardUrl:(NSString *)uuid {
    return [NSString stringWithFormat:@"%@rest/studentbind/%@.json", baseServiceURL, uuid];
}


//phone code
+ (NSString *)getPhoneCodeUrl {
    return URL(baseServiceURL, phoneCodeURL);
}

//校园介绍
+ (NSString *)getYQJSByGroupuuid:(NSString *)groupuuid {
    return [NSString stringWithFormat:@"%@%@?uuid=%@", baseServiceURL, KDInfoURL, groupuuid];
}

//招生计划
+ (NSString *)getZSJHURLByGroupuuid:(NSString *)groupuuid {
    return [NSString stringWithFormat:@"%@%@?uuid=%@", baseServiceURL, ZSJHInfoURL, groupuuid];
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

//新增班级互动
+ (NSString *)getSaveClassNewsUrl {
    return URL(baseServiceURL, saveClassNewsHTMLURL);
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


//特长课程
+ (NSString *)getSpecialtyCoursesUrl {
    return URL(baseServiceURL, specialtyCoursesURL);
}

//精品文章
+ (NSString *)getArticleListUrl {
    return URL(baseServiceURL, articleListURL);
}


//精品文章详情
+ (NSString *)getArticleInfoListUrl:(NSString *)uuid {
    return [NSString stringWithFormat:@"%@rest/share/getArticleJSON.json?uuid=%@", baseServiceURL, uuid];
}

//签到记录
+ (NSString *)getStudentSignRecordUrl {
    return URL(baseServiceURL, studentSignRecordURL);
}

//食谱列表
+ (NSString *)getRecipesListUrl {
    return URL(baseServiceURL, recipesListURL);
}

//推送token
+ (NSString *)getPushTokenUrl {
    return URL(baseServiceURL, pushDeviceURL);
}

//表情
+ (NSString *)getEmojiUrl {
    return URL(baseServiceURL, emojiURL);
}

//老师和园长通讯录
+ (NSString *)getTeacherPhoneBookUrl {
    return URL(baseServiceURL, teacherPhoneBookURL);
}

//给老师发消息
+ (NSString *)getSaveTeacherUrl {
    return URL(baseServiceURL, saveToTeacherURL);
}
//获取和老师的消息列表
+ (NSString *)getQueryByTeacherUrl {
    return URL(baseServiceURL, queryByTeacherURL);
}

//给园长发消息
+ (NSString *)getSaveLeaderUrl {
    return URL(baseServiceURL, saveToLeaderURL);
}

//获取园长消息列表
+ (NSString *)getQueryLeaderUrl {
    return URL(baseServiceURL, queryByLeaderURL);
}

//阅读消息
+ (NSString *)getReadMsgUrl {
    return URL(baseServiceURL, readMsgURL);
}

//课程表
+ (NSString *)getTeachingPlanUrl {
    return URL(baseServiceURL, teachingPLanURL);
}

//收藏列表
+ (NSString *)getFavoritesListUrl {
    return URL(baseServiceURL, favoritesListURL);
}

//保存收藏
+ (NSString *)getsaveFavoritesUrl {
    return URL(baseServiceURL, saveFavoritesURL);
}

//取消收藏
+ (NSString *)getDelFavoritesUrl{
    return URL(baseServiceURL, delFavoritesURL);
}

//修改密码
+ (NSString *)getModidyPWDUrl{
    return URL(baseServiceURL, modifyPWDURL);
}


@end
