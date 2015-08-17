//
//  TopicInteractViewController.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "BaseTopicInteractViewController.h"
#import "KGHttpService.h"
#import "KGHUD.h"
#import "TopicInteractionView.h"
#import "ReplyListViewController.h"
#import "UUInputFunctionView.h"
#import "Masonry.h"
#import "KGEmojiManage.h"
#import "OnlyEmojiView.h"

@interface BaseTopicInteractViewController () <UUInputFunctionViewDelegate, UIGestureRecognizerDelegate> {
    TopicInteractionView * topicInteractionView; //点赞回复视图
    UUInputFunctionView  * IFView;
    OnlyEmojiView * onlyEmojiView;//只存在表情视图
    CGFloat emojiInputY;
}

@end

@implementation BaseTopicInteractViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInputFuniView];
    
    self.keyBoardController.isEmojiInput = YES;
    
    //注册点赞回复通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topicFunClickedNotification:) name:Key_Notification_TopicFunClicked object:nil];
    //注册加载更多回复通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topicRelpyMoreBtnClickedNotification:) name:Key_Notification_TopicLoadMore object:nil];
}


//topicFun点击监听通知
- (void)topicFunClickedNotification:(NSNotification *)notification {
    NSDictionary  * dic = [notification userInfo];
    NSInteger      type = [[dic objectForKey:Key_TopicCellFunType] integerValue];
    BOOL     isSelected = [[dic objectForKey:Key_TopicFunRequestType] boolValue];
    NSString * replyText = [dic objectForKey:Key_TopicTypeReplyText];
    topicInteractionView = [dic objectForKey:Key_TopicInteractionView];
    
    _topicUUID = [dic objectForKey:Key_TopicUUID];
    _topicType = [[dic objectForKey:Key_TopicType] integerValue];
    
    [[KGHUD sharedHud] show:self.contentView];
    if(type == Number_Ten) {
        //点赞
        [self dzOperationHandler:isSelected];
    } else {
        //回复
        [self postTopic:replyText viewMessage:replyText];
    }
}


- (void)dzOperationHandler:(BOOL)isSelected {
    
    if(isSelected) {
        //点赞
        [[KGHttpService sharedService] saveDZ:_topicUUID type:_topicType success:^(NSString *msgStr) {
            [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
            [topicInteractionView resetDZName:YES name:[KGHttpService sharedService].loginRespDomain.userinfo.name];
        } faild:^(NSString *errorMsg) {
            [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
        }];
    } else {
        //取消点赞
        [[KGHttpService sharedService] delDZ:_topicUUID success:^(NSString *msgStr) {
            [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
            [topicInteractionView resetDZName:NO name:[KGHttpService sharedService].loginRespDomain.userinfo.name];
        } faild:^(NSString *errorMsg) {
            [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
        }];
    }
}

- (void)postTopic:(NSString *)replyText viewMessage:(NSString *)message {
    ReplyDomain * replyObj = [[ReplyDomain alloc] init];
    replyObj.content = replyText;
    replyObj.newsuuid = _topicUUID;
    replyObj.type = _topicType;
    
    //    [[KGHttpService sharedService] saveReply:replyObj success:^(NSString *msgStr) {
    //        [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
    //
    //        ReplyDomain * domain = [[ReplyDomain alloc] init];
    //        domain.content = message;
    //        domain.newsuuid = _topicUUID;
    //        domain.type = _topicType;
    //        domain.create_user = [KGHttpService sharedService].loginRespDomain.userinfo.name;;
    //        domain.create_useruuid = [KGHttpService sharedService].loginRespDomain.userinfo.uuid;
    //
    //        [topicInteractionView resetReplyList:domain];
    //        [self resetTopicReplyContent:domain];
    //
    //    } faild:^(NSString *errorMsg) {
    //        [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
    //    }];
}

//重置回复内容
- (void)resetTopicReplyContent:(ReplyDomain *)domain {
    
}

//回复加载更多按钮点击
- (void)topicRelpyMoreBtnClickedNotification:(NSNotification *)notification {
    NSDictionary  * dic = [notification userInfo];
    NSString * tUUID = [dic objectForKey:Key_TopicUUID];
    _topicType = (KGTopicType)[dic objectForKey:Key_TopicType];
    
    ReplyListViewController * baseVC = [[ReplyListViewController alloc] init];
    baseVC.topicUUID = tUUID;
    baseVC.topicType = _topicType;
    [self.navigationController pushViewController:baseVC animated:YES];
}


//键盘通知
- (void)keyboardWillShowOrHide:(BOOL)isShow inputY:(CGFloat)y {
    CGFloat wH  = KGSCREEN.size.height;
    
    if(![KGEmojiManage sharedManage].isSwitchEmoji) {
        if(isShow) {
            IFView.y = y;
            [IFView resetTextEmojiInput];
            [IFView.TextViewInput becomeFirstResponder];
            IFView.hidden = NO;
            emojiInputY = IFView.y;
        } else {
            IFView.y = wH;
            IFView.hidden = YES;
            IFView.TextViewInput.text = String_DefValue_Empty;
            [KGEmojiManage sharedManage].chatHTMLInfo = [[NSMutableString alloc] initWithString:String_DefValue_Empty];
            [IFView.TextViewInput resignFirstResponder];
        }
    } else {
        
        if(IFView.TextViewInput.inputView) {
            //表情键盘
//            CGFloat inputH = 216;
//            CGFloat inputY = wH - inputH - 40;
//            IFView.y = inputY;
//            CGFloat tempY = emojiInputY;
//            IFView.y = tempY + 45;
        } else {
//            CGFloat inputH = self.keyBoardController.kboardHeight;
//            CGFloat inputY = wH - inputH - 40;
//            IFView.y = inputY;
//            IFView.y = emojiInputY;
        }
    }
}

//加载底部只有表情的视图
- (void)loadOnlyEnojiInputView{
    onlyEmojiView = [[[NSBundle mainBundle] loadNibNamed:@"OnlyEmojiView" owner:nil options:nil] lastObject];
    
}

//加载底部输入功能View
- (void)loadInputFuniView {
    IFView = [[UUInputFunctionView alloc]initWithSuperVC:self isShow:NO];
    IFView.delegate = self;
    [self.view addSubview:IFView];
}

#pragma UUIput Delegate
// text
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message {
    NSString * requestReplyStr = [KGEmojiManage sharedManage].chatHTMLInfo;
    [self postTopic:requestReplyStr viewMessage:message];
    [KGEmojiManage sharedManage].isSwitchEmoji = NO;
    [self keyboardWillShowOrHide:NO inputY:8];
}


@end
