//
//  LoginViewController.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/14.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "LoginViewController.h"
#import "TestViewController.h"
#import "RegViewController.h"
#import "AppDelegate.h"
#import "UIWindow+Extension.h"
#import "KGAccountTool.h"
#import "KGUser.h"
#import "KGHttpService.h"
#import "KGNSStringUtil.h"
#import "KGHUD.h"

@interface LoginViewController () <UITextFieldDelegate> {
    
    IBOutlet UIImageView * headImageView;
    IBOutlet UIImageView * savePwdImageView;
    IBOutlet UIButton * savePwdBtn;
    IBOutlet UIButton * loginBtn;
    IBOutlet UIButton * regBtn;
    KGUser * user;
    BOOL     isSaveUserInfo;
}

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


/**
 *  添加输入框到array统一管理验证
 */
- (void)addTextFieldToMArray
{
    [_userNameTextField setTextFielType:KGTextFielType_Phone];
    [_userNameTextField setMessageStr:@"请输入正确的电话号码"];
    _userNameTextField.delegate = self;
    [textFieldMArray addObject:_userNameTextField];
    
    [_userPwdTextField setTextFielType:KGTextFielType_Empty];
    [_userPwdTextField setMessageStr:@"密码不能为空"];
    [textFieldMArray addObject:_userPwdTextField];
}


- (IBAction)testBtnClicked:(UIButton *)sender {
    TestViewController *testVC = [[TestViewController alloc] init];
    [self.navigationController pushViewController:testVC animated:YES];
}


- (IBAction)savePwdBtnClicked:(UIButton *)sender {
    savePwdBtn.selected = !sender.selected;
    savePwdImageView.image = [UIImage imageNamed:savePwdBtn.selected ? @"jizhu" : @"bujizhu"];
//    savePwdBtn.backgroundColor = [UIColor clearColor];
}


- (IBAction)findPwdBtnClicked:(UIButton *)sender {
    RegViewController * regVC = [[RegViewController alloc] init];
    regVC.type = Number_Two;
    [self.navigationController pushViewController:regVC animated:YES];
}


- (IBAction)loginBtnClicked:(UIButton *)sender {
    
//    [self loginSuccess];
//    return;
    
    if([self validateInputInView]) {
        [[KGHUD sharedHud] show:self.view msg:@"登录中..."];
        
        if (!user) {
            user = [[KGUser alloc] init];
        }
        user.loginname = [KGNSStringUtil trimString:_userNameTextField.text];
        [user setUserPassword:[KGNSStringUtil trimString:_userPwdTextField.text]];
        
        [[KGHttpService sharedService] login:user success:^(NSString *msgStr) {
            
            [[KGHUD sharedHud] show:self.view onlyMsg:msgStr];
            
            if(savePwdBtn.selected) {
                [KGAccountTool saveAccount:user];
            } else {
                [KGAccountTool delAccount];
            }
            
            [self loginSuccess];
            
        } faild:^(NSString *errorMsg) {
            [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
        }];
    }
}


- (IBAction)regBtnClicked:(UIButton *)sender {
    RegViewController * regVC = [[RegViewController alloc] init];
    regVC.type = Number_One;
    [self.navigationController pushViewController:regVC animated:YES];
}


- (void)loginSuccess {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = [[KGTabBarViewController alloc] init];
    });
}


@end
