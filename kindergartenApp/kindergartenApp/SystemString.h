//
//  SystemString.h
//  funiiPhoneApp
//
//  Created by You on 14-5-4.
//  Copyright (c) 2014年 LQ. All rights reserved.
//

#import "AppDelegate.h"

#define BaiduMobStatAppId                       @"e633eaf16d"
#define BaiduPushAppId                          @"6482358"

//request code begin
#define String_RequestSuccess_1000               1000
#define String_RequestError_400                  400
#define String_RequestError_1001                 -1001
#define String_RequestError_1004                 -1004
#define String_RequestError_Msg_1001             @"请求超时 请待会再试!"
#define String_RequestError_1009                 -1009
#define String_RequestError_Msg_1009             @"网络不给力哦 请检查您是否在冲浪!"
#define String_RequestError_VersionCheckTitle    @"版本检测"
//request code end

//response code begin
#define String_Status                           @"status"
#define String_Success                          @"success"
#define String_SessionTimeout                   @"sessionTimeout"
#define String_LoginFail                        @"登录失败"
//response code end

// version update begin
#define String_VersionUpdateFlag_None            @"01" //无操作
#define String_VersionUpdateFlag_Sel             @"02" //选择更新
#define String_VersionUpdateFlag_Coerce          @"03" //强制更新
#define String_VersionUpdateFlag_Wait            @"04" //等待更新
// version update end

//ErrorMessage begin
#define String_Message_LocationAPPError     @"请在系统设置中打开'定位服务'来允许'透明房产网'确定您的位置"
#define String_Message_LocationError        @"GPS定位错误"
#define String_Message_LocationKnown        @"定位服务不可用,请在系统设置中打开"
#define String_Message_QRCodeError          @"扫描错误,请重新扫描"
#define String_Message_RequestError         @"请求失败"
#define String_Message_RequestError2        @"请求失败,请稍后重试!"
#define String_Message_CommitError          @"提交失败"
#define String_Message_Commiting            @"提交中..."
#define String_Message_OperSuccess          @"操作成功"
#define String_Message_Login                @"账号或密码不能为空"
#define String_Message_FindPwd              @"账号不能为空"
#define String_Message_Logining             @"登录中..."
#define String_Message_LoginSuccess         @"登录成功"
#define String_Message_IdeaSuccess          @"发送成功,谢谢!"
#define String_Message_RegSuccess           @"注册成功"
#define String_Message_LoginFail            @"登录失败"
#define String_Message_Logout               @"退出成功"
#define String_Message_Idea                 @"请输入您的意见"
#define String_Message_IdeaLength           @"您输入的反馈意见超过140字"
#define String_Message_Nologin              @"请登录"
#define String_Message_MobileError          @"请输入有效手机"
#define String_Message_RegNameError         @"请输入有效邮箱"
#define String_Message_RegPwdError          @"密码长度6-20位"
#define String_Message_NoData               @"暂无数据"
#define String_Message_NoMoreData           @"暂无更多数据"
#define String_Message_NoPhoto              @"暂无图片"
#define String_Message_No                   @"暂无"
#define String_Message_NoValue              @"null"
#define String_Message_NoValueTwo           @"(null)"
//ErrorMessage end


//def value
#define String_DefValue_MapCity          @"成都市"
#define String_DefValue_MapCity2         @"成都"
#define String_DefValue_CellIdentifier   @"CellIdentifier"
#define String_DefValue_Empty            @""
#define String_DefValue_EmptyStr         @" "
#define String_DefValue_SpliteStr        @","
#define String_DefValue_Arrows           @"<>"
#define String_DefValue_UpdateInfoSplite @"$$"
#define String_DefValue_ConditionSplite  @"&"
#define String_DefValue_EmojiRegex       @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]"


// title begin
#define String_Title_SpecialOffers       @"优惠打折"

// title end

// form verify begin
#define String_Verify_UserName         @"请输入姓名"
#define String_Verify_UserName2        @"请输入用户名"
#define String_Verify_Card             @"请输入有效身份证号"
#define String_Verify_Card2            @"请输入有效证件号"
#define String_Verify_Card3            @"请输入有效备案号"
#define String_Verify_Card4            @"请输入有效预约号"
#define String_Verify_Phone            @"请输入有效手机号"
#define String_Verify_IdeaDefValue     @"您的建议和意见"
#define String_Verify_EmailDefValue    @"邮箱(选填)"
#define String_Verify_EMailDefValue    @"请输入有效邮箱"
#define String_Verify_EMailDefValue2   @"您的邮箱地址(选填)"
#define String_Verify_RegPwdDefValue   @"请输入密码"
#define String_Verify_RegPwdDefValue2  @"请输入6-16位数的密码"
// form verify end

#define String_DefValue_Filter           @"筛选"
#define String_DefValue_Clear            @"清空"
#define String_DefValue_Editing          @"编辑"
#define String_DefValue_Cancel           @"取消"
#define String_DefValue_Confirm          @"确定"
#define String_DefValue_Delete           @"删除"
#define String_DefValue_ConfirmClearLog  @"确认清空"
#define String_DefValue_ConfirmTel       @"确认拨打"
#define String_DefValue_TelTurn          @"转"
#define String_DefValue_TelSplite        @",,"
#define String_DefValue_DotSplite        @"."
#define String_DefValue_Loading          @"加载中.."

//房间状态 begin
#define String_RoomStatus_Vendibility           @"可售"
#define String_RoomStatus_PreparedContract      @"拟定合同"
#define String_RoomStatus_Sold                  @"已售"
#define String_RoomStatus_Certificate           @"发证"
#define String_RoomStatus_Mortgage              @"抵押"
#define String_RoomStatus_CloseDown             @"查封"
#define String_RoomStatus_NoSell                @"非售"
#define String_RoomStatus_CantSell              @"不可售"
#define String_RoomStatus_Order                 @"定购"
#define String_RoomStatus_Own                   @"自有"
#define String_RoomStatus_Public                @"公用"
//房间状态 end

//version begin
#define String_Version_ResultsKey         @"results"
#define String_Version_VersionKey         @"version"
#define String_Alert_Prompt               @"提示"
#define String_Alert_UpgradePrompt        @"升级提示"
#define String_Alert_Next                 @"下次再说"
#define String_Alert_Now                  @"现在升级"
#define String_Alert_NotUpdate            @"您当前已是最新版本!"
#define String_Alert_NewUpdate            @"发现新版本 "
#define String_Alert_CheckError           @"版本检测错误!"
#define String_Alert_Notification         @"通知"
#define String_Alert_Show                 @"查看"
#define String_Alert_Ignore               @"忽略"
#define String_Alert_Update               @"更新"
#define String_Alert_Know                 @"知道了"
//version end

#define BackPressed_Notice   @"返回按钮点击通知"

