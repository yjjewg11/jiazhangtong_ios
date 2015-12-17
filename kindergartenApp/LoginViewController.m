//
//  LoginViewController.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/14.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "LoginViewController.h"
#import "RegViewController.h"
#import "AppDelegate.h"
#import "UIWindow+Extension.h"
#import "KGAccountTool.h"
#import "KGUser.h"
#import "KGHttpService.h"
#import "KGNSStringUtil.h"
#import "KGHUD.h"
#import "MBProgressHUD+HM.h"

#define UserNameKey @"UserName"
#define PasswordKey @"Password"

@interface LoginViewController () <UITextFieldDelegate> {
    
    IBOutlet UIImageView * headImageView;
    IBOutlet UIImageView * savePwdImageView;
    IBOutlet UIButton * savePwdBtn;
    IBOutlet UIButton * loginBtn;
    IBOutlet UIButton * regBtn;
    KGUser * user;
    BOOL     isSaveUserInfo;
    BOOL     keyboardOn;
    
    UITextField * currentOperationField;
}

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    keyboardOn = NO;
    
    [headImageView setBorderWithWidth:Number_Zero color:[UIColor clearColor] radian:headImageView.width / Number_Two];
    NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:UserNameKey];
    NSString * password = [[NSUserDefaults standardUserDefaults] objectForKey:PasswordKey];
    _userNameTextField.text = userName;
    _userNameTextField.delegate = self;
    _userPwdTextField.text = password;
    _userPwdTextField.delegate = self;
    
    if (userName != nil && password != nil)
    {
        savePwdBtn.selected = YES;
        savePwdImageView.image = [UIImage imageNamed:savePwdBtn.selected ? @"jizhu" : @"bujizhu"];
    }
    
    //注册键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)savePwdBtnClicked:(UIButton *)sender {
    savePwdBtn.selected = !sender.selected;
    savePwdImageView.image = [UIImage imageNamed:savePwdBtn.selected ? @"jizhu" : @"bujizhu"];
    if (!savePwdBtn.selected) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserNameKey];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:PasswordKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (IBAction)findPwdBtnClicked:(UIButton *)sender {
    RegViewController * regVC = [[RegViewController alloc] init];
    regVC.type = Number_Two;
    [self.navigationController pushViewController:regVC animated:YES];
}

- (BOOL)validateInputInView
{
    if ([_userNameTextField.text isEqualToString:@""])
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:@"啊咧,没有输入用户名哦"];
        
        return NO;
    }
    
    if ([_userPwdTextField.text isEqualToString:@""])
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:@"啊咧,没有输入密码哦"];
        
        return NO;
    }
    
    return YES;
}

- (IBAction)loginBtnClicked:(UIButton *)sender {
    
    if([self validateInputInView]) {
        //不勾选保存密码 也需要保存用户名
        [[NSUserDefaults standardUserDefaults] setObject:_userNameTextField.text forKey:UserNameKey];
        if (savePwdBtn.selected) {
            
            [[NSUserDefaults standardUserDefaults] setObject:_userPwdTextField.text forKey:PasswordKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        [[KGHUD sharedHud] show:self.view msg:@"登录中..."];
        
        if (!user) {
            user = [[KGUser alloc] init];
        }
        user.loginname = [KGNSStringUtil trimString:_userNameTextField.text];
        [user setUserPassword:[KGNSStringUtil trimString:_userPwdTextField.text]];
        
        [[KGHttpService sharedService] login:user success:^(NSString *msgStr) {
            
            [[KGHUD sharedHud] hide:self.view];
            [MBProgressHUD showSuccess:msgStr];
            
            if(savePwdBtn.selected) {
                [KGAccountTool saveAccount:user];
            } else { 
                [KGAccountTool delAccount];
            }
            
            [self loginSuccess];
            
        } faild:^(NSString *errorMsg)
        {
            [[KGHUD sharedHud] hide:self.view];
            [MBProgressHUD showError:errorMsg];
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

#pragma mark - 监听键盘事件
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (keyboardOn == NO)
    {
        [self.view setOrigin:CGPointMake(self.view.frame.origin.x, self.view.frame.origin.y - (100 + 5))];
        keyboardOn = YES;
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    if (keyboardOn == YES)
    {
        [self.view setOrigin:CGPointMake(self.view.frame.origin.x, self.view.frame.origin.y + (100 + 5))];
        keyboardOn = NO;
    }
}

#pragma mark - textField Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentOperationField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![currentOperationField isExclusiveTouch])
    {
        [currentOperationField resignFirstResponder];
    }
}

@end
