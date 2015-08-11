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

@interface BaseTopicInteractViewController () {
    
    NSString        * topicUUID;  //帖子UUID
    KGTopicType       topicType; //帖子类型
    TopicInteractionView * topicInteractionView; //点赞回复视图
}

@end

@implementation BaseTopicInteractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册点赞回复通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topicFunClickedNotification:) name:Key_Notification_TopicFunClicked object:nil];
}

//topicFun点击监听通知
- (void)topicFunClickedNotification:(NSNotification *)notification {
    NSDictionary  * dic = [notification userInfo];
    NSInteger      type = [[dic objectForKey:Key_TopicCellFunType] integerValue];
    BOOL     isSelected = [[dic objectForKey:Key_TopicFunRequestType] boolValue];
    NSString * replyText = [dic objectForKey:Key_TopicTypeReplyText];
    topicInteractionView = [dic objectForKey:Key_TopicInteractionView];
    
    topicUUID = [dic objectForKey:Key_TopicUUID];
    topicType = (KGTopicType)[dic objectForKey:Key_TopicType];
    
    [[KGHUD sharedHud] show:self.contentView];
    if(type == Number_Ten) {
        //点赞
        [self dzOperationHandler:isSelected];
    } else {
        //回复
        [self postTopic:replyText];
    }
}


- (void)dzOperationHandler:(BOOL)isSelected {
    
    if(isSelected) {
        //点赞
        [[KGHttpService sharedService] saveDZ:topicUUID type:topicType success:^(NSString *msgStr) {
            [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
            [topicInteractionView resetDZName:YES name:[KGHttpService sharedService].loginRespDomain.userinfo.name];
        } faild:^(NSString *errorMsg) {
            [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
        }];
    } else {
        //取消点赞
        [[KGHttpService sharedService] delDZ:topicUUID success:^(NSString *msgStr) {
            [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
            [topicInteractionView resetDZName:NO name:[KGHttpService sharedService].loginRespDomain.userinfo.name];
        } faild:^(NSString *errorMsg) {
            [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
        }];
    }
}

- (void)postTopic:(NSString *)replyText {
    ReplyDomain * replyObj = [[ReplyDomain alloc] init];
    replyObj.content = replyText;
    replyObj.newsuuid = topicUUID;
    replyObj.topicType = topicType;
    
    [[KGHttpService sharedService] saveReply:replyObj success:^(NSString *msgStr) {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
        
        ReplyDomain * domain = [[ReplyDomain alloc] init];
        domain.content = replyText;
        domain.newsuuid = topicUUID;
        domain.topicType = topicType;
        domain.create_user = [KGHttpService sharedService].loginRespDomain.userinfo.name;;
        domain.create_useruuid = [KGHttpService sharedService].loginRespDomain.userinfo.uuid;
        
        [topicInteractionView resetReplyList:domain];
        [self resetTopicReplyContent];
        
    } faild:^(NSString *errorMsg) {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
    }];
}

//重置回复内容
- (void)resetTopicReplyContent {
    
}


@end
