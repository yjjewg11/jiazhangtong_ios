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
#import "GuidePageController.h"
#import "UMSocial.h"
#import "SystemShareKey.h"

#import "AlertBindTelView.h"
#import "BindTelController.h"
#import "Masonry.h"
@interface LoginViewController : BaseViewController
@property(strong, nonatomic) NSString * type;
@property(strong, nonatomic) NSString * access_token;
@property(strong, nonatomic) IBOutlet UITextField * userNameTextField;
@property(strong, nonatomic) IBOutlet UITextField * userPwdTextField;

- (IBAction)savePwdBtnClicked:(UIButton *)sender;

- (IBAction)findPwdBtnClicked:(UIButton *)sender;

- (IBAction)loginBtnClicked:(UIButton *)sender;

- (IBAction)regBtnClicked:(UIButton *)sender;



@end
