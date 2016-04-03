//
//  BaseReplyInputViewController.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/3.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "BaseReplyInputViewController.h"
#import "KGHttpService.h"
#import "KGHUD.h"
#import "TopicInteractionView.h"
#import "ReplyListViewController.h"
#import "UUInputFunctionView.h"
#import "Masonry.h"
#import "KGEmojiManage.h"
#import "PhotoVC.h"
#import "BaseReplyDomain.h"
#import "MBProgressHUD+HM.h"


@interface BaseReplyInputViewController () <UUInputFunctionViewDelegate, UIGestureRecognizerDelegate> {
    TopicInteractionView * topicInteractionView; //点赞回复视图
    UUInputFunctionView  * IFView;
    
    BOOL _canSend;
}

@end

@implementation BaseReplyInputViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    [self loadInputFuniView];
    [self regNotification];
    
    
    self.keyBoardController.isShowKeyBoard = YES;
    
    self.keyboardTopType = EmojiAndTextMode;
    
    _canSend = YES;
   }

- (void)regNotification {
    [super regNotification];
    
    self.keyBoardController.isEmojiInput = YES;
    
    //注册回复通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topicReplyNotification:) name:Key_Notification_TopicReply object:nil];
    
        //注册开始编辑回帖通知(在回帖的输入框获得焦点时候触发)
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginReplyTopicNotification:) name:Key_Notification_BeginBaseReplyInput object:nil];

    //注册显示评论列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBaseReplyListNotification:) name:Key_Notification_ShowBaseReplyList object:nil];
    
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

- (void)showBaseReplyListNotification:(NSNotification *)notification {
    NSDictionary  * dic = [notification userInfo];
   
    NSNumber *type=[dic objectForKey:@"type"];
    self.rel_uuid= [dic objectForKey:@"rel_uuid"];
    self.type=[type integerValue];
    if(self.baseReplyListVC==nil){
        
        self.baseReplyListVC=[[BaseReplyListVCTableView alloc]initWithSuperVC:self];
        
        
        [self.view addSubview:self.baseReplyListVC];
    }else{
        [self.view bringSubviewToFront:self.baseReplyListVC];
    }
    [self.baseReplyListVC setHidden:NO];
    
    
    [self.baseReplyListVC setBaseReplyData:self.rel_uuid type:self.type ];
}

//begin reply topic
- (void)beginReplyTopicNotification:(NSNotification *)notification {
//    NSDictionary  * dic = [notification userInfo];
//    _topicInteractionDomain = [dic objectForKey:Key_TopicInteractionDomain];
    [_emojiAndTextView.contentTextView becomeFirstResponder];
    
}



//topic reply通知
- (void)topicReplyNotification:(NSNotification *)notification {
    NSDictionary  * dic = [notification userInfo];
    NSString * replyText = [dic objectForKey:Key_TopicTypeReplyText];
    [self callBackInputEnter:replyText];
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
                //                [_emojiAndTextView.contentTextView setText:String_DefValue_Empty];
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
    
    [self callBackInputEnter:message];
    [KGEmojiManage sharedManage].isSwitchEmoji = NO;
    [self keyboardWillShowOrHide:NO inputY:8];
    
    [_emojiAndTextView.contentTextView setText:String_DefValue_Empty];
    [_emojiAndTextView.contentTextView resignFirstResponder];

    
}


- (void)callBackInputEnter:(NSString *)replyText{
    BaseReplyDomain *domain =[[BaseReplyDomain alloc]init];
    domain.rel_uuid=self.rel_uuid;
    domain.type=self.type;
    domain.content=replyText;
    [[KGHttpService sharedService]  baseReply_save:domain success:^(NSString *msgStr) {
        [self.baseReplyListVC headerRereshing];
        
        [_emojiAndTextView.contentTextView setText:String_DefValue_Empty];
        [_emojiAndTextView.contentTextView resignFirstResponder];

    }faild:^(NSString *errorMsg) {
        [MBProgressHUD showError:@"获取评论列表失败!"];
        
    }];
}
@end
