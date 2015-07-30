//
//  SystemUmeng.h
//  funiiPhoneApp
//
//  Created by rockyang on 14-5-10.
//  Copyright (c) 2014年 LQ. All rights reserved.
//

#import "AppDelegate.h"

//umeng事件id  begin
#define umengEvent_keywordSearch                @"keywordSearch"                //关键词搜索"
#define umengEvent_oldHouseKeywordSearch        @"oldHouseKeywordSearch"        //二手房关键词搜索"
#define umengEvent_newHouseHome                 @"newHouseHome"                 //新房首页"
#define umengEvent_nearOpen                     @"nearOpen"                     //近期开盘"
#define umengEvent_specialOffers                @"specialOffers"                //优惠打折"
#define umengEvent_specialOffersCommunity       @"specialOffersCommunity"       //优惠打折进入楼盘"
#define umengEvent_specialOffersApplyOpen       @"specialOffersApplyOpen"       //优惠打折报名页"
#define umengEvent_specialOffersApplySubmit     @"specialOffersApplySubmit"     //优惠打折报名提交"
#define umengEvent_hotSell                      @"hotSell"                      //热销排行"
#define umengEvent_hotSellCommunity             @"hotSellCommunity"             //热销排行进入楼盘"
#define umengEvent_mapSearchCommunity           @"mapSearchCommunity"           //楼盘地图"
#define umengEvent_nearbyCommunity              @"nearbyCommunity"              //附近楼盘"
#define umengEvent_conditionCommunity           @"conditionCommunity"           //条件找房"
#define umengEvent_communityHome                @"communityHome"                //楼盘首页"
#define umengEvent_communityPhotos              @"communityPhotos"              //分期相册"
#define umengEvent_communityCollectNO           @"communityCollectNO"           //取消收藏分期"
#define umengEvent_communityCollectOK           @"communityCollectOK"           //收藏分期"
#define umengEvent_communityApply               @"communityApply"               //分期首页报名"
#define umengEvent_communityInfo                @"communityInfo"                //分期参数详情"
#define umengEvent_roomTypeList                 @"roomTypeList"                 //户型列表"
#define umengEvent_roomTypeInfo                 @"roomTypeInfo"                 //户型详情"
#define umengEvent_roomTypeBuild                @"roomTypeBuild"                //户型楼栋分布"
#define umengEvent_roomTypeImages               @"roomTypeInfoImages"           //户型图浏览"
#define umengEvent_roomTypeInfoFav              @"roomTypeInfoFav"              //户型详情收藏"
#define umengEvent_roomTypeInfoFavNo            @"roomTypeInfoFavNo"            //户型详情取消收藏"
#define umengEvent_buildingList                 @"buildingList"                 //楼栋列表"
#define umengEvent_roomList                     @"roomList"                     //一房一价"
#define umengEvent_roomListIcon                 @"roomListIcon"                 //一房一价图示"
#define umengEvent_roomListRoomInfo             @"roomListRoomInfo"             //一房一价房间"
#define umengEvent_roomListShare                @"roomListShare"                //一房一价分享"
#define umengEvent_communityPosition            @"communityPosition"            //分期位置"
#define umengEvent_communityPositionPio         @"communityPositionPio"         //分期位置周边"
#define umengEvent_communityPositionNav         @"communityPositionNav"         //分期位置导航"
#define umengEvent_complaintList                @"complaintList"                //投诉"
#define umengEvent_complaintInfo                @"complaintInfo"                //投诉详情"
#define umengEvent_communityIntroduction        @"communityIntroduction"        //分期楼盘介绍"
#define umengEvent_communityDynamicList         @"communityDynamicList"         //分期楼盘动态列表"
#define umengEvent_communityDynamic             @"communityDynamic"             //分期首页楼盘动态"
#define umengEvent_communityTel                 @"communityTel"                 //分期电话拨打"
#define umengEvent_esfHome                      @"esfHome"                      //二手房首页"
#define umengEvent_esfKeyword                   @"esfKeyword"                   //二手房关键词"
#define umengEvent_esfQrCodeCode                @"esfQrCodeCode"                //二手房扫描核实码输入"
#define umengEvent_nearbyHouse                  @"nearbyHouse"                  //二手房附近房源"
#define umengEvent_mapHouse                     @"mapHouse"                     //二手房地图"
#define umengEvent_mapHousePlot                 @"mapHousePlot"                 //二手房地图二手房点击"
#define umengEvent_mapHousePlotSearch           @"mapHousePlotSearch"           //二手房地图户型搜索"
#define umengEvent_oldHouseFilter               @"oldHouseFilter"               //二手房筛选"
#define umengEvent_oldHouseVerify               @"oldHouseVerify"               //二手房验证"
#define umengEvent_oldHouseVerifyQR             @"oldHouseVerifyQR"             //二手房扫描验证"
#define umengEvent_oldHouseVerifyCard           @"oldHouseVerifyCard"           //二手房产权证验证"
#define umengEvent_oldHouseVerifyCardSub        @"oldHouseVerifyCardSubmit"     //二手房产权证验证提交"
#define umengEvent_oldHouseVerifyCardRes        @"oldHouseVerifyCardResult"     //二手房产权证验证结果"
#define umengEvent_oldHouseVerifyBusines        @"oldHouseVerifyBusiness"       //二手房业务件号验证"
#define umengEvent_oldHouseVerifySubmit         @"oldHouseVerifyBusinessSubmit" //二手房业务件号验证提交"
#define umengEvent_oldHouseVerifyResult         @"oldHouseVerifyBusinessResult" //二手房业务件号验证结果"
#define umengEvent_oldHouseVOL                  @"oldHouseVOL"                  //二手房成交走势"
#define umengEvent_oldHouseInfo                 @"oldHouseInfo"                 //二手房详情"
#define umengEvent_oldHousePhoto                @"oldHousePhoto"                //二手房相册"
#define umengEvent_oldHouseFav                  @"oldHouseFav"                  //二手房收藏
#define umengEvent_oldHouseFavNo                @"oldHouseFavNo"                //二手房取消收藏"
#define umengEvent_oldHouseMap                  @"oldHouseMap"                  //二手房地图"
#define umengEvent_oldHouseMapPio               @"oldHouseMapPio"               //二手房地图周边"
#define umengEvent_oldHouseMapNav               @"oldHouseMapNav"               //二手房地图导航"
#define umengEvent_oldHouseTel                  @"oldHouseTel"                  //二手房电话"
#define umengEvent_informationHome              @"informationHome"              //资讯首页"
#define umengEvent_informationInfo              @"informationInfo"              //资讯详情"
#define umengEvent_informationInfoShare         @"informationInfoShare"         //资讯详情分享"
#define umengEvent_userCenterHome               @"userCenterHome"               //用户中心"
#define umengEvent_login                        @"login"                        //登录"
#define umengEvent_loginSubmit                  @"loginSubmit"                  //登录提交"
#define umengEvent_register                     @"register"                     //注册"
#define umengEvent_registerSubmit               @"registerSubmit"               //注册提交"
#define umengEvent_registerProtocol             @"registerProtocol"             //注册协议"
#define umengEvent_collectList                  @"collectList"                  //收藏列表"
#define umengEvent_browseList                   @"browseList"                   //浏览列表"
#define umengEvent_messageCenter                @"messageCenter"                //消息中心"
#define umengEvent_setting                      @"setting"                      //设置"
#define umengEvent_aboutUs                      @"aboutUs"                      //关于我们"
#define umengEvent_vserionCheck                 @"vserionCheck"                 //版本检测"
#define umengEvent_feedback                     @"feedback"                     //意见反馈"
#define umengEvent_feedbackSubmit               @"feedbackSubmit"               //意见反馈提交"
//umeng事件id  end

//umeng政务查询 begin
#define umengEvent_houseContract                   @"govQueryHouseContract"                  //商品房合同备案查询
#define umengEvent_houseContractResult             @"govQueryHouseContractResult"            //商品房合同备案查询结果
#define umengEvent_houseContractBtnClick           @"govQueryHouseContractBtnClick"          //商品房合同备案查询按钮点击

#define umengEvent_houseSourceInfo                 @"govQueryhouseSourceInfo"                //房源信息验证
#define umengEvent_houseSourceInfoResult           @"govQueryHouseSourceInfoResult"          //房源信息验证结果
#define umengEvent_houseSourceInfoBtnClick         @"govQueryhouseSourceInfoBtnClick"        //房源信息验证按钮点击

#define umengEvent_houseRegisterInfo               @"govQueryHouseRegisterInfo"              //房屋登记信息查询
#define umengEvent_houseRegisterInfoResult         @"govQueryHouseRegisterInfoResult"        //房屋登记信息查询结果
#define umengEvent_houseRegisterInfoBtnClick       @"govQueryHouseRegisterInfoBtnClick"      //房屋登记信息查询按钮点击

#define umengEvent_queryResultVerify               @"govQueryQueryResultVerify"              //查询结果验证
#define umengEvent_queryResultVerifyArchive        @"govQueryResultVerifyArchive"            //房屋档案资料验证查询
#define umengEvent_queryResultVerifyRegisterRecord @"govQueryResultVerifyRegisterRecord"     //个人及家庭房屋登记记录验证查询
#define umengEvent_queryResultVerifyBtnClick       @"govQueryQueryResultVerifyBtnClick"      //查询结果验证按钮点击

#define umengEvent_houseRegisterSchedule           @"scheduleQueryHouseRegister"             //房屋登记进度查询
#define umengEvent_houseRegisterScheduleResult     @"scheduleQueryHouseRegisterResult"       //房屋登记进度查询结果
#define umengEvent_houseRegisterScheduleBtnClick   @"scheduleQueryHouseRegisterBtnClick"     //房屋登记进度查询按钮点击

#define umengEvent_productAllowSchedule            @"scheduleQueryProductAllow"              //商品房预售许可进度查询
#define umengEvent_productAllowScheduleResult      @"scheduleQueryProductAllowResult"        //商品房预售许可进度查询结果
#define umengEvent_productAllowScheduleBtnClick    @"scheduleQueryProductAllowBtnClick"      //商品房预售许可进度查询按钮点击

#define umengEvent_SurveySchedule                  @"scheduleQuerySurvey"                    //房屋测绘报告审核进度查询
#define umengEvent_SurveyScheduleResult            @"scheduleQuerySurveyResult"              //房屋测绘报告审核进度查询结果
#define umengEvent_SurveyScheduleBtnClick          @"scheduleQuerySurveyBtnClick"            //房屋测绘报告审核进度查询按钮点击

#define umengEvent_onlineOrderForm                 @"orderWorkOnlineOrderForm"               //登记预约表单
#define umengEvent_orderQueryForm                  @"orderWorkOrderQueryForm"                //预约查询&预约取消表单
#define umengEvent_orderQueryResult                @"orderWorkOrderResult"                   //预约查询&预约取消结果
#define umengEvent_orderQueryFormBtnClick          @"orderWorkOrderQueryFormBtnClick"        //预约查询&预约取消表单按钮点击
#define umengEvent_onlineOrderFormSuccess          @"orderWorkOnlineOrderFormBtnClick"       //登记预约表单提交成功

#define umengEvent_personageHouseRegQuery          @"orderWorkPersonageHouseRegQuery"        //个人及家庭房屋登记记录查询
#define umengEvent_personageHouseRegQueryBtnClick  @"orderWorkPersonageHouseRegQueryBtnClick"//个人及家庭房屋登记记录查询按钮点击
#define umengEvent_personageHouseRegQuerySuccess   @"orderWorkPersonageHouseRegQuerySuccess" //个人及家庭房屋登记记录查询提交成功

#define umengEvent_houseRecordQuery                @"orderWorkHouseRecordQuery"              //房屋档案资料查询
#define umengEvent_houseRecordQueryBtnClick        @"orderWorkHouseRecordQueryBtnClick"      //房屋档案资料查询按钮点击
#define umengEvent_houseRecordQuerySuccess         @"orderWorkHouseRecordQuerySuccess"       //房屋档案资料查询提交成功

#define umengEvent_QueueDynamic                    @"QueueDynamic"       //排号动态

//umeng政务查询 end

//umeng事件参数 begin
#define umengEventParameKey_SearchCondition     @"searchCondition"              //搜索条件"
#define umengEventParameKey_SearchConditionV    @"searchConditionValue"         //搜索条件值"
#define umengEventParameKey_CommunityName       @"communityName"                //楼盘名称"
#define umengEventParameKey_BuildNo             @"buildNo"                      //楼栋号"
#define umengEventParameKey_RoomType            @"roomType"                     //户型"
#define umengEventParameKey_OldHouseName        @"oldHouseName"                 //二手房房源名称"
#define umengEventParameKey_PlotName            @"plotName"                     //二手房小区名称"
#define umengEventParameKey_Keyword             @"keyword"                      //关键词"
#define umengEventParameKey_RimType             @"rimType"                      //地图周边"
#define umengEventParameKey_InfomationType      @"infomationType"               //资讯类别 "

//umeng事件参数 end
