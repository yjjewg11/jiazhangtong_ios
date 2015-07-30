//
//  LoginViewController.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/14.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseKeyboardViewController.h"
#import "KGTextField.h"

@interface LoginViewController : BaseKeyboardViewController

@property(strong, nonatomic) IBOutlet KGTextField * userNameTextField;
@property(strong, nonatomic) IBOutlet KGTextField * userPwdTextField;

- (IBAction)testBtnClicked:(UIButton *)sender;

- (IBAction)savePwdBtnClicked:(UIButton *)sender;

- (IBAction)findPwdBtnClicked:(UIButton *)sender;

- (IBAction)loginBtnClicked:(UIButton *)sender;

- (IBAction)regBtnClicked:(UIButton *)sender;



@end
