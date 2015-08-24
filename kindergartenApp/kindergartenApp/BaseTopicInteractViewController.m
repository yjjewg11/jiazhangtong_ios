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
#import "PhotoVC.h"


@interface BaseTopicInteractViewController () <UUInputFunctionViewDelegate, UIGestureRecognizerDelegate> {
    TopicInteractionView * topicInteractionView; //点赞回复视图
    UUInputFunctionView  * IFView;
}

@end

@implementation BaseTopicInteractViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self regNotification];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [IFView removeFromSuperview];
    [_onlyEmojiView removeFromSuperview];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self loadInputFuniView];
    [self regNotification];
}

- (void)regNotification {
    [super regNotification];
    
    self.keyBoardController.isEmojiInput = YES;
    
    //注册点赞通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topicDZNotification:) name:Key_Notification_TopicDZ object:nil];
    
    //注册回复通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topicReplyNotification:) name:Key_Notification_TopicReply object:nil];
    
    //注册开始编辑回帖通知(在回帖的输入框获得焦点时候触发)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginReplyTopicNotification:) name:Key_Notification_BeginReplyTopic object:nil];
    
    //注册加载更多回复通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topicRelpyMoreBtnClickedNotification:) name:Key_Notification_TopicLoadMore object:nil];
    
    //注册点击图片浏览图片通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(browseImagesNotification:) name:Key_Notification_BrowseImages object:nil];
}

//设置键盘顶部悬浮类型
- (void)setKeyboardTopType:(KeyBoardTopType)keyboardTopType{
    _keyboardTopType = keyboardTopType;
    switch (_keyboardTopType) {
        case OnlyEmojiMode:
            [self loadOnlyEnojiInputView];
            break;
        case EmojiAndTextMode:
            [self loadEmojiAndText];
            break;
        case ChatMode:
            [self loadInputFuniView];
            break;
    }
}


//begin reply topic
- (void)beginReplyTopicNotification:(NSNotification *)notification {
    NSDictionary  * dic = [notification userInfo];
    _topicInteractionDomain = [dic objectForKey:Key_TopicInteractionDomain];
    [_emojiAndTextView.contentTextView becomeFirstResponder];
    
}

//topic DZ通知
- (void)topicDZNotification:(NSNotification *)notification {
    NSDictionary  * dic = [notification userInfo];
    BOOL     isSelected = [[dic objectForKey:Key_TopicFunRequestType] boolValue];
    topicInteractionView = [dic objectForKey:Key_TopicInteractionView];
    _topicInteractionDomain = [dic objectForKey:Key_TopicInteractionDomain];
    
    [self dzOperationHandler:isSelected];
}

//topic reply通知
- (void)topicReplyNotification:(NSNotification *)notification {
    NSDictionary  * dic = [notification userInfo];
    NSString * replyText = [dic objectForKey:Key_TopicTypeReplyText];
    
    //回复
    [self postTopic:replyText];
}


- (void)dzOperationHandler:(BOOL)isSelected {
//    [[KGHUD sharedHud] show:self.contentView];
    if(isSelected) {
        //点赞
        [[KGHttpService sharedService] saveDZ:_topicInteractionDomain.topicUUID type:_topicInteractionDomain.topicType success:^(NSString *msgStr) {
//            [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
            [topicInteractionView resetDZName:YES name:[KGHttpService sharedService].loginRespDomain.userinfo.name];
        } faild:^(NSString *errorMsg) {
//            [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
        }];
    } else {
        //取消点赞
        [[KGHttpService sharedService] delDZ:_topicInteractionDomain.topicUUID success:^(NSString *msgStr) {
//            [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
            [topicInteractionView resetDZName:NO name:[KGHttpService sharedService].loginRespDomain.userinfo.name];
        } faild:^(NSString *errorMsg) {
//            [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
        }];
    }
}

//回帖。  提交需要的回帖数据从EmojiManage中获取   aaa<img alt="惊恐" src="htt//...png" />
//replyText只是用来界面显示     aaa[惊恐]bbb[大笑]
- (void)postTopic:(NSString *)replyText {
//    NSString * requestReplyStr = [KGEmojiManage sharedManage].chatHTMLInfo;
    ReplyDomain * replyObj = [[ReplyDomain alloc] init];
    replyObj.content = replyText;
    replyObj.newsuuid = _topicInteractionDomain.topicUUID;
    replyObj.type = _topicInteractionDomain.topicType;
    
    [[KGHttpService sharedService] saveReply:replyObj success:^(NSString *msgStr) {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
        
        ReplyDomain * domain = [[ReplyDomain alloc] init];
        domain.content = replyText;
        domain.newsuuid = _topicInteractionDomain.topicUUID;
        domain.type = _topicInteractionDomain.topicType;
        domain.create_user = [KGHttpService sharedService].loginRespDomain.userinfo.name;;
        domain.create_useruuid = [KGHttpService sharedService].loginRespDomain.userinfo.uuid;
        
        [self resetTopicReplyContent:domain];
        [_emojiAndTextView.contentTextView resignFirstResponder];
        
    } faild:^(NSString *errorMsg) {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
        [_emojiAndTextView.contentTextView resignFirstResponder];
    }];
}

//重置回复内容
- (void)resetTopicReplyContent:(ReplyDomain *)domain {
    
}

//回复加载更多按钮点击
- (void)topicRelpyMoreBtnClickedNotification:(NSNotification *)notification {
    NSDictionary  * dic = [notification userInfo];
    _topicInteractionDomain = [dic objectForKey:Key_TopicInteractionDomain];
    
    ReplyListViewController * baseVC = [[ReplyListViewController alloc] init];
    baseVC.topicUUID = _topicInteractionDomain.topicUUID;
    baseVC.topicType = _topicInteractionDomain.topicType;
    [self.navigationController pushViewController:baseVC animated:YES];
}

//图片点击浏览图片通知
- (void)browseImagesNotification:(NSNotification *)notification {
    NSDictionary  * dic = [notification userInfo];
    NSMutableArray * imagesMArray = [dic objectForKey:Key_ImagesArray];
    
    PhotoVC * vc = [[PhotoVC alloc] init];
    vc.imgMArray = imagesMArray;
    [self.navigationController pushViewController:vc animated:YES];
}


//键盘通知
- (void)keyboardWillShowOrHide:(BOOL)isShow inputY:(CGFloat)y {
    CGFloat wH  = KGSCREEN.size.height;
    
    if(![KGEmojiManage sharedManage].isSwitchEmoji) {
        if (_keyboardTopType == OnlyEmojiMode) {
            if (isShow) {
                _onlyEmojiView.y = y;
                _emojiInputY = _onlyEmojiView.y;
            }else{
                _onlyEmojiView.y = wH;
            }
            return;
        }
        
        if (_keyboardTopType == EmojiAndTextMode) {
            if (isShow) {
                _emojiAndTextView.y = y;
                [_emojiAndTextView.contentTextView becomeFirstResponder];
                _emojiInputY = _emojiAndTextView.y;
            }else{
                _emojiAndTextView.y = wH;
                [_emojiAndTextView.contentTextView resignFirstResponder];
                _emojiAndTextView.contentTextView.inputView = nil;
                [_emojiAndTextView.contentTextView setText:String_DefValue_Empty];
            }
            return;
        }
        
        if(isShow) {
            IFView.y = y;
            [IFView resetTextEmojiInput];
            [IFView.TextViewInput becomeFirstResponder];
            IFView.hidden = NO;
            _emojiInputY = IFView.y;
        } else {
            IFView.y = wH;
            IFView.hidden = YES;
            IFView.TextViewInput.text = String_DefValue_Empty;
            [IFView.TextViewInput resignFirstResponder];
        }
    } else {
        if (_keyboardTopType == OnlyEmojiMode) {
            if (isShow) {
                _onlyEmojiView.y = y;
                _emojiInputY = _onlyEmojiView.y;
            }else{
                _onlyEmojiView.y = wH;
            }
            return;
        }
        if (_keyboardTopType == EmojiAndTextMode) {
            if (isShow) {
                _emojiAndTextView.y = y;
                _emojiInputY = _emojiAndTextView.y;
            }else{
                _emojiAndTextView.y = wH;
            }
            return;
        }
    }
}

//加载底部有表情，发送，文本框的视图
- (void)loadEmojiAndText{
    _emojiAndTextView = [[[NSBundle mainBundle] loadNibNamed:@"EmojiAndTextView" owner:nil options:nil] lastObject];
    _emojiAndTextView.width = APPWINDOWWIDTH;
    _emojiAndTextView.y = KGSCREEN.size.height;;
    [[UIApplication sharedApplication].keyWindow addSubview:_emojiAndTextView];
}

//加载底部只有表情的视图
- (void)loadOnlyEnojiInputView{
    if (!_faceBoard) {
        _faceBoard = [[FaceBoard alloc] init];
        _faceBoard.inputTextView = self.weakTextView;
    }
    
    _onlyEmojiView = [[[NSBundle mainBundle] loadNibNamed:@"OnlyEmojiView" owner:nil options:nil] lastObject];
    _onlyEmojiView.width = APPWINDOWWIDTH;
    _onlyEmojiView.y = KGSCREEN.size.height;
    [[UIApplication sharedApplication].keyWindow addSubview:_onlyEmojiView];
    __weak typeof(self) weakSelf = self;
    [_onlyEmojiView setPressedBlock:^(UIButton * button){
        [KGEmojiManage sharedManage].isChatEmoji = YES;
        [KGEmojiManage sharedManage].isSwitchEmoji = YES;
        [weakSelf.weakTextView resignFirstResponder];
        if (button.selected) {
            weakSelf.weakTextView.inputView = weakSelf.faceBoard;
        }else{
            weakSelf.weakTextView.inputView = nil;
        }
        [weakSelf.weakTextView becomeFirstResponder];
    }];
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
    
    [self postTopic:message];
    [KGEmojiManage sharedManage].isSwitchEmoji = NO;
    [self keyboardWillShowOrHide:NO inputY:8];
}


@end
