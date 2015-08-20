//
//  TeacherJudgeViewController.h
//  kindergartenApp
//  评价老师
//  Created by yangyangxun on 15/7/28.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseKeyboardViewController.h"
#import "TeacherVO.h"

@interface TeacherJudgeViewController : BaseKeyboardViewController <UIAlertViewDelegate>

@property (strong, nonatomic) NSDictionary * tempDic;//提交按钮点击 通知字典

@end
