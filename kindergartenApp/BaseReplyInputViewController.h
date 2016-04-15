//
//  BaseReplyInputViewController.h
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/3.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "BaseKeyboardViewController.h"

#import "FaceBoard.h"
#import "KGEmojiManage.h"
#import "OnlyEmojiView.h"
#import "EmojiAndTextView.h"
#import "BaseReplyListVCTableView.h"

@interface BaseReplyInputViewController : BaseKeyboardViewController
@property (assign, nonatomic) KeyBoardTopType keyboardTopType;//键盘顶部样式类型
@property (weak, nonatomic) UITextView * weakTextView;//弱类型
@property (strong, nonatomic) FaceBoard * faceBoard;
@property (strong, nonatomic) OnlyEmojiView * onlyEmojiView;//只存在表情视图
@property (assign, nonatomic) CGFloat emojiInputY;
@property (strong, nonatomic) EmojiAndTextView * emojiAndTextView;
  @property (strong, nonatomic) BaseReplyListVCTableView * baseReplyListVC;


@property (strong,nonatomic) NSString *rel_uuid;
@property (nonatomic)  KGTopicType type;
//回调方法，通知子类成功,返回输入数据
- (void)callBackInputEnter:(NSString *)replyText;




@end
