//
//  RegViewController.h
//  kindergartenApp
//  注册
//  Created by yangyangxun on 15/7/18.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "BaseKeyboardViewController.h"

@interface RegViewController : BaseKeyboardViewController


// 1:注册; 2:找回密码; 3:修改密码
@property (assign, nonatomic) NSInteger type;


- (IBAction)valCodeBtnClicked:(UIButton *)sender;

- (IBAction)submitBtnClicked:(UIButton *)sender;

@end
