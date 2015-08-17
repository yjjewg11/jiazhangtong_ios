//
//  UUInputFunctionView.h
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceBoard.h"
#import "KGTextView.h"

@class UUInputFunctionView;

@protocol UUInputFunctionViewDelegate <NSObject>

// text
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message;

// image
@optional
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image;

// audio
@optional
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second;

@end

@interface UUInputFunctionView : UIView <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, retain) UIButton *btnSendMessage;
@property (nonatomic, retain) UIButton *btnChangeVoiceState;
//@property (nonatomic, retain) UIButton *btnVoiceRecord;
@property (nonatomic, retain) KGTextView *TextViewInput;

@property (nonatomic, assign) BOOL isAbleToSendTextMessage;

@property (nonatomic, retain) UIViewController *superVC;

@property (nonatomic, assign) id<UUInputFunctionViewDelegate>delegate;

@property (strong, nonatomic) FaceBoard *faceBoard;
@property (assign, nonatomic) BOOL isFacBoard;

//重置文本和表情输入状态
- (void)resetTextEmojiInput;

- (id)initWithSuperVC:(UIViewController *)superVC isShow:(BOOL)isShow;

- (void)changeSendBtnWithPhoto:(BOOL)isPhoto;

@end
