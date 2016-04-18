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
#import "BaseReplyDomain.h"
#import "DianZanDomain.h"
#import "AnnouncementDomain.h"
#import "TeacherVO.h"
#import "GroupDomain.h"
#import "WriteVO.h"
#import "QueryChatsVO.h"
#import "AddressBookResp.h"
#import "FavoritesDomain.h"
#import "SPDataListVO.h"
#import "SPCourseDetailDomain.h"
#import "SPSchoolDomain.h"
#import "SPCommentDomain.h"
#import "SPCommentVO.h"
#import "SPTeacherDetailDomain.h"
#import "SPShareSaveDomain.h"
#import "YouHuiDomain.h"
#import "YouHuiDataListVO.h"
#import "MySPCourseTeacherList.h"
#import "MySPAllCourseListVO.h"
#import "SPCourseDetailVO.h"
#import "EnrolStudentDataVO.h"
#import "DiscorveryMeiRiTuiJianDomain.h"
#import "DiscorveryNewNumberDomain.h"
#import "DiscorveryReMenJingXuanDomain.h"
#import "SystemConfigOfTopic.h"
#import "ListBaseDomain.h"
#import "FPMyFamilyPhotoCollectionDomain.h"
#import "FPFamilyPhotoLastTimeVO.h"
#import "FPFamilyPhotoUpdateCount.h"
#import "FPFamilyPhotoStatusDomain.h"
#import "FPMoiveDomain.h"
#import "FPTimeLineDZDomain.h"
#import "FPTimeLineCommentDomain.h"
#import "FPFamilyPhotoNormalDomain.h"
#import "FPMyFamilyPhotoListColletion.h"
#import "FPCollegeListDomin.h"
#import "KGHttpUrl.h"
#import "FPFamilyInfoDomain.h"
#import "FPFamilyMembers.h"
#import "KGListBaseDomain.h"
#import "GlobalMap.h"

#import "BaseReplyDomain.h"
#import "KGAccountTool.h"
#import "AFAppDotNetAPIClient.h"
#import "KGHttpUrl.h"
#import "MJExtension.h"
#import "KGListBaseDomain.h"
#import "DynamicMenuDomain.h"
#import "GroupDomain.h"
#import "MessageDomain.h"
#import "StudentSignRecordDomain.h"
#import "RecipesDomain.h"
#import "EmojiDomain.h"
#import "AddressBookDomain.h"
#import "chatInfoDomain.h"
#import "KGEmojiManage.h"
#import "TimetableDomain.h"
#import "ClassDomain.h"
#import "CardInfoDomain.h"
#import "AFNetworking.h"
#import "SPTimetableDomain.h"
#import "SPCourseTypeDomain.h"
#import "SPCourseDetailDomain.h"
#import "SPSchoolDomain.h"
#import "EnrolStudentsSchoolDomain.h"
#import "FPCollegeListDomin.h"
#import "FPCollegePhotoDetailDomin.h"
#import "FPFamilyMembers.h"
#import "KGDateUtil.h"
#import "FPMoive4QDomain.h"
#import "ListBaseDomain.h"
@interface KGHttpService : NSObject
@property (strong, nonatomic) KGUser * userinfo;
@property (strong, nonatomic) NSString * pushToken;
@property (strong, nonatomic) KGTabBarViewController * tabBarViewController;//首页控制器
@property (strong, nonatomic) LoginRespDomain * loginRespDomain;
@property (strong, nonatomic) NSArray         * dynamicMenuArray;           //首页动态菜单数据
@property (strong, nonatomic) NSArray         * groupArray;                 //机构列表数据
@property (strong, nonatomic) GroupDomain     * groupDomain;                //选择的机构 默认为机构列表第一条数据 首页切换机构后需要重置

+ (KGHttpService *)sharedService;
- (void)queryByPage:(NSString * )url pageNo:(NSInteger ) pageNo success:(void (^)(KGListBaseDomain * baseDomain))success faild:(void (^)(NSString * errorMsg))faild;

- (void)sessionTimeoutHandle:(KGBaseDomain *)baseDomain;
- (void)requestErrorCode:(NSError*)error faild:(void (^)(NSString* errorMessage))faild;
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

- (void)getClassOrSchoolNews:(PageInfoDomain *)pageObj groupuuid:(NSString *)groupuuid courseuuid:(NSString *)courseuuid success:(void (^)(PageInfoDomain * pageInfo))success faild:(void (^)(NSString * errorMsg))faild;

// 班级互动 end


//学生相关 begin

- (void)saveStudentInfo:(KGUser *)user success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;
- (void)addStudentInfo:(KGUser *)user success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;

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

//获取本地jessionid存到cookie，跳过登录
-(BOOL)setupCookieByLocalJessionid;
// 评价老师 end



//精品文章 begin

//获取单个文章详情
- (void)getArticlesInfo:(NSString *)uuid success:(void (^)(AnnouncementDomain * announcementObj))success faild:(void (^)(NSString * errorMsg))faild;

//分页获取文章列表
- (void)getArticlesList:(PageInfoDomain *)pageInfo success:(void (^)(NSArray * articlesArray))success faild:(void (^)(NSString * errorMsg))faild;

//精品文章 end


//签到记录 begin

//签到记录列表
- (void)getStudentSignRecordList:(NSInteger)pageNo  success:(void (^)(NSArray * recordArray))success faild:(void (^)(NSString * errorMsg))faild;

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

- (void)getSPTeachingPlanList:(void (^)(NSArray * spTeachPlanArray))success faild:(void (^)(NSString * errorMsg))faild;
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

#pragma mark - 特长课程
- (void)getSPCourseType:(void(^)(NSArray * spCourseTypeArr))success faild:(void(^)(NSString * errorMsg))faild;

- (void)getSPCourseList:(NSString *)groupuuid map_point:(NSString *)map_point type:(NSString *)type sort:(NSString *)sort teacheruuid:(NSString *)teacheruuid pageNo:(NSString *)pageNo success:(void(^)(SPDataListVO * spCourseList))success faild:(void(^)(NSString * errorMsg))faild;

- (void)getSPSchoolList:(NSString *)mapPoint pageNo:(NSString *)pageNo sort:(NSString *)sort success:(void(^)(SPDataListVO * spSchoolList))success faild:(void(^)(NSString * errorMsg))faild;

- (void)getSPCourseDetail:(NSString *)uuid success:(void(^)(SPCourseDetailVO * detailVO))success faild:(void(^)(NSString * errorMsg))faild;

- (void)getSPCourseDetailSchoolInfo:(NSString *)groupuuid success:(void (^)(SPSchoolDomain * spSchoolDetail))success faild:(void (^)(NSString * errorMsg))faild;

- (void)getSPCourseComment:(NSString *)ext_uuid pageNo:(NSString *)pageNo success:(void (^)(SPCommentVO * commentVO))success faild:(void (^)(NSString * errorMsg))faild;

- (void)getSPHotCourse:(NSString *)map_point pageNo:(NSString *)pageNo success:(void(^)(SPDataListVO * hotCourseList))success faild:(void(^)(NSString * errorMsg))faild;

- (void)getSPTeacherList:(NSString *)groupuuid pageNo:(NSString *)pageNo success:(void (^)(SPDataListVO * dataListVo))success faild:(void (^)(NSString * errorMsg))faild;

- (void)getSPTeacherDetail:(NSString *)uuid success:(void (^)(SPTeacherDetailDomain * teacherDomain))success faild:(void (^)(NSString * errorMsg))faild;

- (void)getSPCourseExtraFun:(NSString *)uuid success:(void(^)(SPShareSaveDomain * shareSaveDomain))success faild:(void(^)(NSString * errorMsg))faild;

- (void)getSPSchoolExtraFun:(NSString *)uuid success:(void(^)(SPShareSaveDomain * shareSaveDomain))success faild:(void(^)(NSString * errorMsg))faild;

- (void)getSPSchoolInfoShareUrl:(NSString *)groupuuid success:(void (^)(NSString * url))success faild:(void (^)(NSString * errorMsg))faild;

- (void)getSPSchoolInfoTimeTableUrl:(NSString *)groupuuid success:(void (^)(NSString * vo))success faild:(void (^)(NSString * errorMsg))faild;

#pragma mark - 优惠活动
- (void)getYouHuiList:(NSString *)map_point pageNo:(NSInteger)pageNo success:(void (^)(YouHuiDataListVO * teacherDomain))success faild:(void (^)(NSString * errorMsg))faild;

- (void)getYouHuiInfo:(NSString *)uuid success:(void (^)(AnnouncementDomain * announcementObj))success faild:(void (^)(NSString * errorMsg))faild;

- (void)saveTelUserDatas:(NSString *)ext_uuid type:(NSString *)type success:(void(^)(NSString * msg))success faild:(void(^)(NSString * errorMsg))faild;

#pragma mark - 我的特长课程
- (void)MySPCourseList:(NSString *)pageNo isdisable:(NSString *)isdisable success:(void(^)(SPDataListVO * msg))success faild:(void(^)(NSString * errorMsg))faild;

- (void)MySPCourseComment:(NSString *)classuuid pageNo:(NSString *)pageNo success:(void(^)(SPDataListVO * msg))success faild:(void(^)(NSString * errorMsg))faild;

- (void)MySPCourseTeacherList:(NSString *)classuuid success:(void(^)(NSArray * teacherArr))success faild:(void(^)(NSString * errorMsg))faild;

- (void)MySPCourseSaveComment:(NSString *)extuuid classuuid:(NSString *)classuuid type:(NSString *)type score:(NSString *)score content:(NSString *)content success:(void(^)(NSString * mgr))success faild:(void(^)(NSString * errorMsg))faild;

- (void)getListAll:(NSString *)classuuid pageNo:(NSString *)pageNo success:(void(^)(MySPAllCourseListVO * courseListVO))success faild:(void(^)(NSString * errorMsg))faild;

#pragma mark - 招生模块
- (void)getAllSchoolList:(NSString *)groupuuid pageNo:(NSString *)pageNo mappoint:(NSString *)map_point sort:(NSString *)sort success:(void(^)(NSArray * listArr))success faild:(void(^)(NSString * errorMsg))faild;

- (void)getZhaoShengSchoolDetail:(NSString *)groupuuid mappoint:(NSString *)map_point success:(void(^)(EnrolStudentDataVO * vo))success faild:(void(^)(NSString * errorMsg))faild;

- (void)getMySchoolComment:(NSString *)groupuuid success:(void(^)(EnrolStudentDataVO * vo))success faild:(void(^)(NSString * errorMsg))faild;

- (void)MySchoolSaveComment:(NSString *)extuuid classuuid:(NSString *)classuuid type:(NSString *)type score:(NSString *)score content:(NSString *)content anonymous:(NSString *)anonymous success:(void(^)(NSString * mgr))success faild:(void(^)(NSString * errorMsg))faild;

#pragma mark - 发现模块
- (void)getMeiRiTuiJian:(void(^)(DiscorveryMeiRiTuiJianDomain * mgr))success faild:(void(^)(NSString * errorMsg))faild;
- (void)getReMenJingXuan:(NSString *)pageNo success:(void(^)(NSArray * remenjingxuanarr))success faild:(void(^)(NSString * errorMsg))faild;
- (void)getDiscorveryNewNumber:(void(^)(DiscorveryNewNumberDomain * newnum))success faild:(void(^)(NSString * errorMsg))faild;

- (void)getSysConfig:(NSString *)md5 success:(void(^)(SystemConfigOfTopic * sysDomain))success faild:(void(^)(NSString * errorMsg))faild;

- (void)getTitle:(NSString *)url success:(void(^)(NSString * data))success faild:(void(^)(NSString * errorMsg))faild;


- (void)meiRiJingXuanHuiDiao:(void(^)(NSString * data))success faild:(void(^)(NSString * errorMsg))faild;

- (void)cheakUserJessionID:(NSString *)jid success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;

#pragma mark - 家庭相册模块
-(void)fpFamilyPhotoCollection_get:(NSString *)uuid  success :(void(^)( FPMyFamilyPhotoCollectionDomain *    domain))success faild:(void(^)(NSString * errorMsg))faild;
- (void)fpFamilyPhotoCollection_save:(FPFamilyPhotoNormalDomain *)domain success:(void (^)(KGBaseDomain * msgStr))success faild:(void (^)(NSString * errorMsg))faild;
- (void)fPFamilyMembers_save:(FPFamilyMembers *)domain success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;
- (void)fPFamilyMembers_delete:(NSString *)uuid success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;

-(void)getCollegePhotoListWithPageNo:(NSInteger)pageNo success:(void(^)(FPCollegeListDomin *domin))success faild:(void(^)(NSString * errorMsg))faild;

-(void)getMyFamilyPhoto:(void(^)(FPMyFamilyPhotoListColletion * domain))success faild:(void(^)(NSString * errorMsg))faild;

- (void)getMyPhotoCollection:(void(^)(NSArray * datas))success faild:(void(^)(NSString * errorMsg))faild;

- (void)getPhotoCollectionUseFamilyUUID:(NSString *)familyUUID withTime:(NSString *)time timeType:(NSInteger)type pageNo:(NSString *)pageNo success:(void(^)(FPFamilyPhotoLastTimeVO * lastTimeVO))success faild:(void(^)(NSString * errorMsg))faild;

- (void)getFPPhotoUpdateDataWithFamilyUUID:(NSString *)familyUUID   domain:(FPFamilyInfoDomain *) domain  pageNo :(NSInteger) pageNo success:(void(^)(PageInfoDomain * needUpDateDatas))success faild:(void(^)(NSString * errorMsg))faild;


- (void)uploadFPPhotoUpdateDataWithFamilyUUID:(NSString *)familyUUID img:(UIImage *)img success:(void(^)(NSString * str))success faild:(void(^)(NSString * errorMsg))faild;

- (void)modifyFPItemInfo:(NSString *)address note:(NSString *)note success:(void(^)(NSString * mgr))success faild:(void(^)(NSString * errorMsg))faild;

- (void)getFPItemExtraInfo:(NSString *)uuid success:(void(^)(FPTimeLineDZDomain * needUpDateDatas))success faild:(void(^)(NSString * errorMsg))faild;

- (void)saveFPItemReply:(NSString *)content rel_uuid:(NSString *)rel_uuid success:(void(^)(NSString * mgr))success faild:(void(^)(NSString * errorMsg))faild;

- (void)deleteFPTimeLineItem:(NSString *)uuid success:(void(^)(NSString * mgr))success faild:(void(^)(NSString * errorMsg))faild;

- (void)getFPItemCommentList:(NSString *)uuid pageNo:(NSString *)pageNo time:(NSString *)time success:(void(^)(NSArray * arr))success faild:(void(^)(NSString * errorMsg))faild;

- (void)getFPTimeLineItem:(NSString *)uuid success:(void(^)(FPFamilyPhotoNormalDomain * item))success faild:(void(^)(NSString * errorMsg))faild;

//不用
- (void)saveFPDZ:(NSString *)newsuid type:(KGTopicType)dzype success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;
//不用
- (void)delFPDZ:(NSString *)newsuid success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;
- (void)baseDianzan_save:(NSString *)rel_uuid type:(KGTopicType)dzype success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;
- (void)baseDian_queryNameByPage:(NSString *)rel_uuid type:(KGTopicType)dzype  pageNo:(NSString *)pageNo time:(NSString *)time success:(void(^)(PageInfoDomain * pageInfoDomain))success faild:(void(^)(NSString * errorMsg))faild;
- (void)baseDianzan_delete:(NSString *)newsuid  type:(KGTopicType)dzype  success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;
- (void)fPPhotoItem_addFavorites:(NSString *)uuid  success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild ;

- (void)fPPhotoItem_deleteFavorites:(NSString *)uuid  success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild ;
- (void)fPMovie_queryMy:(PageInfoDomain *)pageInfo success:(void (^)(NSArray * articlesArray))success faild:(void (^)(NSString * errorMsg))faild;
- (void)fPMovie_query:(PageInfoDomain *)pageInfo success:(void (^)(NSArray * articlesArray))success faild:(void (^)(NSString * errorMsg))faild ;
-(void)getByUuid:(NSString *)path  uuid:(NSString *)uuid  success :(void(^)( id     responseObject))success faild:(void(^)(NSString * errorMsg))faild;

- (void)baseReply_delete:(NSString *)newsuid  type:(KGTopicType)dzype  success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;
- (void)baseReply_queryByRel_uuid:(NSString *)rel_uuid type:(KGTopicType)dzype  pageNo:(NSString *)pageNo time:(NSString *)time success:(void(^)(PageInfoDomain * pageInfoDomain))success faild:(void(^)(NSString * errorMsg))faild;
- (void)baseReply_save:(BaseReplyDomain *)reply success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;
//通用post 参数bodyJSOn方法
-(void)postByBodyJson:(NSString *)path params:(NSDictionary *)jsonDictionary success:(void (^)(KGBaseDomain * baseDomain))success faild:(void (^)(NSString * errorMessage))faild;
- (void)fPMovie_queryByURL:(NSString *) url pageInfo:(PageInfoDomain *)pageInfo success:(void (^)(NSArray * articlesArray))success faild:(void (^)(NSString * errorMsg))faild;

-(void)getListByURL:(NSString *)path   success :(void (^)(ListBaseDomain * baseDomain))success faild:(void (^)(NSString * errorMessage))faild;
-(void)postByDomainBodyJson:(NSString *)path params:(KGBaseDomain *)domain success:(void (^)(KGBaseDomain * baseDomain))success faild:(void (^)(NSString * errorMessage))faild;
-(void)getByURL:(NSString *)path   success :(void (^)(KGBaseDomain * baseDomain))success faild:(void (^)(NSString * errorMessage))faild;

- (void)fpMovie_save:(FPMoiveDomain *)domain success:(void (^)(KGBaseDomain * msgStr))success faild:(void (^)(NSString * errorMsg))faild;
@end
