//
//  EmojiAndTextView.h
//  kindergartenApp
//
//  Created by CxDtreeg on 15/8/17.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGTextView.h"
#import "KGEmojiManage.h"
#import "FaceBoard.h"
typedef NS_ENUM(NSUInteger, KeyBoardTopType) {
    OnlyEmojiMode,//只有切换表情
    EmojiAndTextMode,//有表情和文本输入框
    ChatMode//聊天类型
};

typedef void(^ButtonPressed)(UIButton *);

@interface EmojiAndTextView : UIView

@property (strong, nonatomic) IBOutlet KGTextView *contentTextView;
@property (strong, nonatomic) ButtonPressed pressedBlock;
@property (strong, nonatomic) FaceBoard * faceBoard;

@end
