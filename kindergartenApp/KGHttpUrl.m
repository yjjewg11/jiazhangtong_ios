//
//  FuniHttpUrl.m
//  kindergartenApp
//
//  Created by You on 15/6/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGHttpUrl.h"

#define URL(baseURL, businessURL) [NSString stringWithFormat:@"%@%@", baseURL, businessURL];
//#define baseServiceURL       @"http://jz.wenjienet.com/px-mobile/"      //正式
#define baseServiceURL       @"http://120.25.212.44/px-mobile/"         //测试

#define dynamicMenuURL       @"rest/userinfo/getDynamicMenu.json"    //首页动态菜单
#define loginURL             @"rest/userinfo/login.json"             //登录
#define logoutURL            @"rest/userinfo/logout.json"            //登出
#define checkUserJessionID   @"rest/userinfo/getUserinfo.json"       //自动登录时先验证getUserInfo获取信息
#define regURL               @"rest/userinfo/reg.json"               //注册
//#define updatepasswordURL    @"rest/userinfo/updatepassword.json"   //修改密码
#define updatepasswordURL    @"rest/userinfo/updatePasswordBySms.json"//修改密码
#define getTeacherInfo       @"rest/userinfo/getTeacherInfo.json"     //获取用户信息
#define KDInfoURL            @"rest/share/getKDInfo.html"             //校园相关
#define ZSJHInfoURL          @"rest/share/getRecruitBygroupuuid.html" //招生计划

#define teacherPhoneBookURL  @"rest/userinfo/getTeacherPhoneBook.json" //老师和园长通讯录
#define saveToTeacherURL     @"rest/message/saveToTeacher.json"  //给老师写信
#define queryByTeacherURL    @"rest/message/queryByTeacher.json" //查询和老师的信件
#define saveToLeaderURL      @"rest/message/saveToLeader.json"   //给园长写信
#define queryByLeaderURL     @"rest/message/queryByLeader.json"  //查询和园长的信件
#define readMsgURL           @"rest/pushMessage/read.json"       //阅读信件



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
#define fpUploadImgURL        @"rest/fPPhotoItem/upload.json"

#define messageListURL        @"rest/pushMessage/queryMy.json" //消息列表

#define teacherAndJudgesURL   @"rest/teachingjudge/getTeachersAndJudges.json" //评价老师列表
#define saveTeacherJudgesURL  @"rest/teachingjudge/save.json" //评价老师

//#define saveTeacherJudgesURL  @"rest/teachingjudge/save.json" //通讯录

#define specialtyCoursesURL   @"rest/pxteachingplan/nextList.json"  //课程表 -  下次特长课

#define courseTypeUrl         @"rest/share/getCourseType.json"    //特长课程首页 - 特长课程分类

#define specialtyCoursesListURL @"rest/pxCourse/queryByPage.json" //特长课程列表

#define specialtyHotCoursesListURL @"rest/pxCourse/hotByPage.json"  //热门课程列表

#define specialtySchoolListURL @"rest/group/pxlistByPage.json"    //特长班列表

#define specialtyTeacherListURL @"rest/pxteacher/queryByPage.json" //教师列表

#define specialtyCourseCommentURL @"rest/appraise/queryByPage.json"  //课程家长评论

#define saveUserTelDatasURL @"rest/pxTelConsultation/save.json" //保存用户咨询

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

+ (NSString *)getUserInfoWithJessionID:(NSString *)jid
{
    return URL(baseServiceURL, checkUserJessionID);
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

+ (NSString *)getAddChildrenUrl{
    return URL(baseServiceURL, @"rest/student/add.json");
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

//分页获取学校或者班级的互动列表
+ (NSString *)getSchoolOrClassNewsUrl:(NSString *)groupuuid courseuuid:(NSString *)courseuuid {
    return [NSString stringWithFormat:@"%@rest/classnews/queryPxClassNewsBy.json?groupuuid=%@&courseuuid=%@",baseServiceURL,groupuuid,courseuuid];
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

+ (NSString *)getFPUploadImgUrl {
    return URL(baseServiceURL, fpUploadImgURL);
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

#pragma mark - 特长课程
//特长课程
+ (NSString *)getSpecialtyCoursesUrl {
    return URL(baseServiceURL, specialtyCoursesURL);
}

+ (NSString *)getCourseTypeUrl {
    return URL(baseServiceURL, courseTypeUrl)
}

+ (NSString *)getSpecialtyCoursesListURL{
    return URL(baseServiceURL, specialtyCoursesListURL);
}

+ (NSString *)getSpecialtyCoursesListURL:(NSString *)type sort:(NSString *)sort{
    return [NSString stringWithFormat:@"%@rest/pxCourse/queryByPage.json?type=%@&sort=%@",baseServiceURL,type,sort];
}

+ (NSString *)getSpecialtyHotCourseListURL{
    return URL(baseServiceURL,specialtyHotCoursesListURL);
}

+ (NSString *)getSpecialtySchoolListURL{
    return URL(baseServiceURL, specialtySchoolListURL);
}

+ (NSString *)getSpecialtyTeacherListURL{
    return URL(baseServiceURL, specialtyTeacherListURL);
}

+ (NSString *)getSpecialtySchoolListURL:(NSString *)mapPoint sort:(NSString *)sort{
    return [NSString stringWithFormat:@"%@rest/group/pxlistByPage.json?map_point=%@&sort=%@",baseServiceURL,mapPoint,sort];
}

+ (NSString *)getSpecialtyCourseDetailURL:(NSString *)uuid{
    return [NSString stringWithFormat:@"%@rest/pxCourse/get2.json?uuid=%@",baseServiceURL,uuid];
}



+ (NSString *)getSpecialtyCourseDetailSchoolInfoURL:(NSString *)groupuuid{
    return [NSString stringWithFormat:@"%@rest/group/%@.json",baseServiceURL,groupuuid];
}

+ (NSString *)getSchoolInfoShareUrl:(NSString *)groupuuid{
    return [NSString stringWithFormat:@"%@rest/group/get2.json?uuid=%@",baseServiceURL,groupuuid];
}

+ (NSString *)getSpecialtyTeacherDetailURL:(NSString *)teacheruuid{
    return [NSString stringWithFormat:@"%@rest/pxteacher/%@.json",baseServiceURL,teacheruuid];
}

+ (NSString *)saveTelUserDatasURL:(NSString *)ext_uuid type:(NSString *)type{
    return URL(baseServiceURL, saveUserTelDatasURL);
}

//我的特长课程
+ (NSString *)getMySPCourseListURL:(NSString *)pageNo isdisable:(NSString *)isdisable{
    return [NSString stringWithFormat:@"%@rest/pxclass/listMyChildClassByPage.json?pageNo=%@&isdisable=%@",baseServiceURL,pageNo,isdisable];
}

+ (NSString *)getMySPCourseComments:(NSString *)classuuid pageNo:(NSString *)pageNo{
    return [NSString stringWithFormat:@"%@rest/appraise/queryMyByPage.json?class_uuid=%@&pageNo=%@",baseServiceURL,classuuid,pageNo];
}

+ (NSString *)getMySPCourseTeacherList:(NSString *)classuuid{
    return [NSString stringWithFormat:@"%@rest/pxclass/listclassTeacher.json?classuuid=%@",baseServiceURL,classuuid];
}

+ (NSString *)getMySPListAll:(NSString *)classuuid pageNo:(NSString *)pageNo{
    return [NSString stringWithFormat:@"%@rest/pxteachingplan/listAllByclassuuid.json?classuuid=%@&pageNo=%@",baseServiceURL,classuuid,pageNo];
}

+ (NSString *)getSaveMySPCommentURL{
    return URL(baseServiceURL, @"rest/appraise/save.json");
}

//优惠活动
+ (NSString *)getYouHuiListURL:(NSString *)map_point pageNo:(NSInteger)pageNo{
    return [NSString stringWithFormat:@"%@rest/share/pxbenefitList.json?map_point=%@&pageNo=%ld",baseServiceURL,map_point,(long)pageNo];
}

+ (NSString *)getYouHuiInfoListUrl:(NSString *)uuid {
    return [NSString stringWithFormat:@"%@rest/share/getPxbenefitJSON.json?uuid=%@", baseServiceURL, uuid];
}

+ (NSString *)getSpecialtyCourseCommentURL{
    return URL(baseServiceURL, specialtyCourseCommentURL);
}

//精品文章
+ (NSString *)getArticleListUrl {
    return URL(baseServiceURL, articleListURL);
}


//精品文章详情
+ (NSString *)getArticleInfoListUrl:(NSString *)uuid {
    return [NSString stringWithFormat:@"%@rest/share/getArticleUrlJSON.json?uuid=%@", baseServiceURL, uuid];
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

#pragma mark - 招生模块
+ (NSString *)getAllSchoolListUrl{
    return URL(baseServiceURL, @"rest/group/kdlistByPage.json");
}

+ (NSString *)getZhaoShengSchoolDetailUrl{
    return URL(baseServiceURL, @"rest/group/getKD.json");
}

+ (NSString *)getMySchoolCommentUrl{
    return URL(baseServiceURL, @"rest/appraise/queryMyKDByPage.json");
}

#pragma mark - 发现模块
+ (NSString *)getMeiRiTuiJianUrl{
    return URL(baseServiceURL, @"rest/userinfo/getMainTopic.json");
}

+ (NSString *)getReMenJingXuanUrl{
    return URL(baseServiceURL, @"rest/snsTopic/hotByPage.json");
}

+ (NSString *)getNewsNumberUrl{
    return URL(baseServiceURL, @"rest/userinfo/getNewMsgNumber.json");
}

#pragma mark - 获取系统参数
+ (NSString *)getSysConfigOfTopic{
    return URL(baseServiceURL, @"rest/share/getConfig.json");
}

+ (NSString *)uploadPicUrl{
    return URL(baseServiceURL, @"rest/uploadFile/upload.json");
}

#pragma mark - 获取title
+ (NSString *)getTitleUrl{
    return URL(baseServiceURL, @"rest/share/getHtmlTitle.json");
}

#pragma mark - 每日精选回调
+ (NSString *)meiRiHuiDiaoUrl{
    return URL(baseServiceURL, @"rest/userinfo/getMainTopic.json");
}

#pragma mark - 家庭相册模块
+ (NSString *)getMyFamilyPhotoUrl{
    return URL(baseServiceURL, @"rest/fpFamilyPhotoCollection/queryMy.json");
}
+ (NSString *)getCollegePhotoUrl{
    return URL(baseServiceURL, @"rest/fPPhotoItem/queryMyFavorites.json")
}
+ (NSString *)getFamilyPhotoUseFamilyUUIDAndTimeUrl{
    return URL(baseServiceURL, @"rest/fPPhotoItem/queryOfIncrement.json");
}

+ (NSString *)getFamilyPhotoUpdateCountUrl{
    return URL(baseServiceURL, @"rest/fPPhotoItem/queryOfNewDataCount.json");
}

+ (NSString *)getFamilyPhotoUpdateDataUrl{
    return URL(baseServiceURL, @"rest/fPPhotoItem/queryOfUpdate.json");
}

#pragma mark - 修改照片属性
+ (NSString *)modifyFPItemUrl{
    return URL(baseServiceURL, @"rest/fPPhotoItem/save.json");
}

#pragma mark - 获取一张照片信息额外信息（收藏，点赞）. 
+ (NSString *)getFPItemExtraInfoUrl:(NSString *)uuid{
    return [NSString stringWithFormat:@"%@rest/fPPhotoItem/extra.json?uuid=%@",baseServiceURL,uuid];
}

#pragma mark - 评论
+ (NSString *)saveFPItemCommentUrl{
    return URL(baseServiceURL, @"rest/baseReply/save.json");
}

#pragma mark - 删除时光轴相片
+ (NSString *)deleteFPTimeLineItem:(NSString *)uuid{
    return [NSString stringWithFormat:@"%@rest/fPPhotoItem/delete.json?uuid=%@",baseServiceURL,uuid];
}

#pragma mark - 时光轴相片评论列表
+ (NSString *)getTimeLineItemCommentListUrl{
    return URL(baseServiceURL,@"rest/baseReply/queryByRel_uuid.json");
}

#pragma mark - 获取一张照片信息
+ (NSString *)getTimeLineItemUrl{
    return URL(baseServiceURL, @"rest/fPPhotoItem/get.json");
}

//点赞
+ (NSString *)getFPSaveDZUrl:(NSString *)uuid{
    return [NSString stringWithFormat:@"%@rest/baseDianzan/save.json",baseServiceURL];
}

//取消点赞
+ (NSString *)getFPDelDZUrl:(NSString *)uuid{
    return [NSString stringWithFormat:@"%@rest/baseDianzan/delete.json?type=21&rel_uuid=%@",baseServiceURL,uuid];
}

#pragma mark - 获取收藏照片列表
+ (NSString *)getFPCollegeUrl{
    return [NSString stringWithFormat:@"%@rest/fPPhotoItem/queryMy.json",baseServiceURL];
}



@end






