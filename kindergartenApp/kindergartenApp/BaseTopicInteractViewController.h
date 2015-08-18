//
//  TopicInteractViewController.h
//  kindergartenApp
//  有点赞回复的base VC
//  Created by yangyangxun on 15/8/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "BaseKeyboardViewController.h"
#import "ReplyDomain.h"
#import "FaceBoard.h"
#import "KGEmojiManage.h"
#import "OnlyEmojiView.h"
#import "EmojiAndTextView.h"
#import "TopicInteractionDomain.h"

typedef NS_ENUM(NSUInteger, KeyBoardTopType) {
    OnlyEmojiMode,//只有切换表情
    EmojiAndTextMode,//有表情和文本输入框
    ChatMode//聊天类型
};

@interface BaseTopicInteractViewController : BaseKeyboardViewController

//@property (strong, nonatomic) NSString        * topicUUID;  //帖子UUID
//@property (assign, nonatomic) KGTopicType       topicType; //帖子类型
@property (assign, nonatomic) KeyBoardTopType keyboardTopType;//键盘顶部样式类型
@property (weak, nonatomic) UITextView * weakTextView;//弱类型
@property (strong, nonatomic) FaceBoard * faceBoard;
@property (strong, nonatomic) OnlyEmojiView * onlyEmojiView;//只存在表情视图
@property (assign, nonatomic) CGFloat emojiInputY;
@property (strong, nonatomic) EmojiAndTextView * emojiAndTextView;
@property (strong, nonatomic) TopicInteractionDomain * topicInteractionDomain;

//重置回复内容
- (void)resetTopicReplyContent:(ReplyDomain *)domain;

@end
