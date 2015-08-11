//
//  BaseKeyboardViewController.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/18.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "BaseViewController.h"
#import "UIKeyboardViewController.h"

@interface BaseKeyboardViewController : BaseViewController <UIKeyboardViewControllerDelegate> {
    
    //表单所搜输入框集合
    NSMutableArray  * textFieldMArray;
}


@property (strong, nonatomic) UIKeyboardViewController * keyBoardController;


/**
 *  移除messageView
 */
//- (void)removeCurrentMessageView;

//滑动手势
- (void)addSwipeGesture;

//水平手势x值发生改变
- (void)didChangeViewX:(CGFloat)x gesture:(UIPanGestureRecognizer*)gesture;

/**
 *  添加输入框到array统一管理验证
 */
- (void)addTextFieldToMArray;


/**
 *  验证所有输入框
 *
 *  @return 返回是否验证通过
 */
- (BOOL)validateInputInView;


- (void)notificationMessage:(NSString *)msgStr;

@end
