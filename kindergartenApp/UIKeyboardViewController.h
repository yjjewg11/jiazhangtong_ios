//
//  UIKeyboardViewController.h
//
//
//  Created by  YFengchen on 13-1-4.
//  Copyright 2013 __zhongyan__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIKeyboardViewControllerDelegate;

@interface UIKeyboardViewController : NSObject <UITextFieldDelegate, UITextViewDelegate> {
	UIView *objectView;
    NSMutableArray  * allInputFields;
}
//移除监听通知
- (void)removeKeyBoardNotification;

//监听键盘隐藏和显示事件
- (void)addKeyBoardNotification;

@property (nonatomic, assign) id <UIKeyboardViewControllerDelegate> boardDelegate;
@property (nonatomic, assign) CGFloat kboardHeight;
@property (nonatomic, assign) BOOL isEmojiInput; //是否是表情输入键盘
@property (nonatomic, assign) BOOL isShowKeyBoard;//是否强制执行 keyboardWillShowOrHide方法

- (id)initWithControllerDelegate:(id <UIKeyboardViewControllerDelegate>)delegateObject;

- (void)buildDelegate;

@end


@protocol UIKeyboardViewControllerDelegate <NSObject>

@optional
- (void)keyboardWillShowOrHide:(BOOL)isShow inputY:(CGFloat)y;
- (void)alttextFieldDidEndEditing:(UITextField *)textField;
- (void)alttextViewDidEndEditing:(UITextView *)textView;
- (void)textViewDidChange:(UITextView *)textView;

@end
