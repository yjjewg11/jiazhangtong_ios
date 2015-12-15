//
//  LoginViewController.h
//  kindergartenApp
//  登录
//  Created by yangyangxun on 15/7/14.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseKeyboardViewController.h"
#import "KGTextField.h"

@interface LoginViewController : BaseViewController

@property(strong, nonatomic) IBOutlet UITextField * userNameTextField;
@property(strong, nonatomic) IBOutlet UITextField * userPwdTextField;

- (IBAction)savePwdBtnClicked:(UIButton *)sender;

- (IBAction)findPwdBtnClicked:(UIButton *)sender;

- (IBAction)loginBtnClicked:(UIButton *)sender;

- (IBAction)regBtnClicked:(UIButton *)sender;



@end
