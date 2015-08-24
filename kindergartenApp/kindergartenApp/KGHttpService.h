//
//  FuniHttpService.h
//  kindergartenApp
//
//  Created by You on 15/6/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KGTabBarViewController.h"
#import "KGUser.h"
#import "LoginRespDomain.h"
#import "PageInfoDomain.h"
#import "TopicDomain.h"
#import "ReplyDomain.h"
#import "DianZanDomain.h"
#import "AnnouncementDomain.h"
#import "TeacherVO.h"
#import "GroupDomain.h"
#import "WriteVO.h"
#import "QueryChatsVO.h"
#import "AddressBookResp.h"
#import "FavoritesDomain.h"

@interface KGHttpService : NSObject

@property (strong, nonatomic) NSString * pushToken;
@property (strong, nonatomic) KGTabBarViewController * tabBarViewController;//首页控制器
@property (strong, nonatomic) LoginRespDomain * loginRespDomain;
@property (strong, nonatomic) NSArray         * dynamicMenuArray; //首页动态菜单数据
@property (strong, nonatomic) NSArray         * groupArray; //机构列表数据
@property (strong, nonatomic) GroupDomain     * groupDomain; //选择的机构 默认为机构列表第一条数据 首页切换机构后需要重置


+ (KGHttpService *)sharedService;

//根据组织id得到图片
- (NSString *)getGroupImgByUUID:(NSString *)groupUUID;

//根据组织id得到名称
- (NSString *)getGroupNameByUUID:(NSString *)groupUUID;

//根据学生id得到班级
- (NSString *)getClassNameByUUID:(NSString *)classUUID;

//获取学生信息
- (KGUser *)getUserByUUID:(NSString *)uuid;

//根据班级获取学生信息
- (KGUser *)getUserByClassUUID:(NSString *)uuid;

//图片上传
- (void)uploadImg:(UIImage *)img withName:(NSString *)imgName type:(NSInteger)imgType success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;

//提交推送token
- (void)submitPushTokenWithStatus:(NSString *)status success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;

//获取表情
- (void)getEmojiList:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;

//获取首页动态菜单
- (void)getDynamicMenu:(void (^)(NSArray * menuArray))success faild:(void (^)(NSString * errorMsg))faild;

//获取机构列表
- (void)getGroupList:(void (^)(NSArray * groupArray))success faild:(void (^)(NSString * errorMsg))faild;

// 账号相关 begin

- (void)login:(KGUser *)user success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;

- (void)logout:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;

- (void)reg:(KGUser *)user success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;


- (void)updatePwd:(KGUser *)user success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;

//获取指定学生绑定的卡号信息
- (void)getBuildCardList:(NSString *)useruuid success:(void (^)(NSArray * cardArray))success faild:(void (^)(NSString * errorMsg))faild;

//获取用户信息
- (void)getUserInfo:(NSString *)useruuid success:(void (^)(KGUser * userInfo))success faild:(void (^)(NSString * errorMsg))faild;


- (void)getPhoneVlCode:(NSString *)phone type:(NSInteger)type success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;


// 账号相关 end



//班级互动 begin

// 根据互动id获取互动详情
- (void)getClassNewsByUUID:(NSString *)uuid success:(void (^)(TopicDomain * classNewInfo))success faild:(void (^)(NSString * errorMsg))faild;

// 新增互动
- (void)saveClassNews:(TopicDomain *)topicDomain success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;


// 分页获取班级互动列表
- (void)getClassNews:(PageInfoDomain *)pageObj success:(void (^)(PageInfoDomain * pageInfo))success faild:(void (^)(NSString * errorMsg))faild;

// 班级互动 end


//学生相关 begin

- (void)saveStudentInfo:(KGUser *)user success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;


//学生相关 end


//点赞相关 begin

//保存点赞
- (void)saveDZ:(NSString *)newsuid type:(KGTopicType)dzype success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;

//取消点赞
- (void)delDZ:(NSString *)newsuid success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;

//点赞列表
- (void)getDZList:(NSString *)newsuid success:(void (^)(DianZanDomain * dzDomain))success faild:(void (^)(NSString * errorMsg))faild;

//点赞相关 end


//回复相关 begin

//保存回复
- (void)saveReply:(ReplyDomain *)reply success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;

//取消回复
- (void)delReply:(NSString *)uuid success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;

//分页获取回复列表
- (void)getReplyList:(PageInfoDomain *)pageInfo topicUUID:(NSString *)topicUUID success:(void (^)(PageInfoDomain * pageInfo))success faild:(void (^)(NSString * errorMsg))faild;

//回复相关 end



//公告相关 begin

//获取单个公告详情
- (void)getAnnouncementInfo:(NSString *)uuid success:(void (^)(AnnouncementDomain * announcementObj))success faild:(void (^)(NSString * errorMsg))faild;

//分页获取公告列表
- (void)getAnnouncementList:(PageInfoDomain *)pageInfo success:(void (^)(NSArray * announcementArray))success faild:(void (^)(NSString * errorMsg))faild;

//公告相关 end


//分页获取消息列表
- (void)getMessageList:(PageInfoDomain *)pageInfo success:(void (^)(NSArray * messageArray))success faild:(void (^)(NSString * errorMsg))faild;

//读取消息
- (void)readMessage:(NSString *)msguuid success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;


// 评价老师 begin

//获取评价老师列表
- (void)getTeacherList:(void (^)(NSArray * teacherArray))success faild:(void (^)(NSString * errorMsg))faild;


//评价老师
- (void)saveTeacherJudge:(TeacherVO *)teacherVO success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;


// 评价老师 end



//精品文章 begin

//获取单个文章详情
- (void)getArticlesInfo:(NSString *)uuid success:(void (^)(AnnouncementDomain * announcementObj))success faild:(void (^)(NSString * errorMsg))faild;

//分页获取文章列表
- (void)getArticlesList:(PageInfoDomain *)pageInfo success:(void (^)(NSArray * articlesArray))success faild:(void (^)(NSString * errorMsg))faild;

//精品文章 end


//签到记录 begin

//签到记录列表
- (void)getStudentSignRecordList:(void (^)(NSArray * recordArray))success faild:(void (^)(NSString * errorMsg))faild;

//签到记录 end



//食谱 begin

//食谱列表
- (void)getRecipesList:(NSString *)groupuuid beginDate:(NSString *)beginDate endDate:(NSString *)endDate success:(void (^)(NSArray * recipesArray))success faild:(void (^)(NSString * errorMsg))faild;

//食谱 end




//通讯录 begin

//通讯录列表
- (void)getAddressBookList:(void (^)(AddressBookResp * addressBookResp))success faild:(void (^)(NSString * errorMsg))faild;

//查询和老师或者园长的信息列表
- (void)getTeacherOrLeaderMsgList:(QueryChatsVO *)queryChatsVO success:(void (^)(NSArray * msgArray))success faild:(void (^)(NSString * errorMsg))faild;

//给老师或者园长写信
- (void)saveAddressBookInfo:(WriteVO *)writeVO success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;

//通讯录 end


//课程表 begin

//课程表列表
- (void)getTeachingPlanList:(NSString *)beginDate endDate:(NSString *)endDate cuid:(NSString *)classuuid success:(void (^)(NSArray * teachPlanArray))success faild:(void (^)(NSString * errorMsg))faild;

//课程表 end


//收藏 begin

//收藏列表
- (void)getFavoritesList:(NSInteger)pageNo success:(void (^)(NSArray * favoritesArray))success faild:(void (^)(NSString * errorMsg))faild;

//保存收藏
- (void)saveFavorites:(FavoritesDomain *)favoritesDomain success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;

//取消收藏
- (void)delFavorites:(NSString *)uuid success:(void(^)(NSString *msgStr))success failed:(void(^)(NSString *errorMsg))faild;

//收藏 end

#pragma mark - 修改密码
- (void)modifyPassword:(KGUser *)user success:(void(^)(NSString * msg))success faild:(void(^)(NSString * errorMsg))faild;

@end
