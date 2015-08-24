//
//  RegViewController.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/18.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "RegViewController.h"
#import "UIView+Extension.h"
#import "UIColor+Extension.h"
#import "KGTextField.h"
#import "KGNSStringUtil.h"
#import "KGFormVerify.h"
#import "UIButton+Extension.h"
#import "KGHttpService.h"
#import "KGHUD.h"
#import "KGUser.h"
#import "UIView+Extension.h"

@interface RegViewController () {
    
    IBOutlet KGTextField * phoneTextField;
    IBOutlet KGTextField * pwdTextField;
    IBOutlet KGTextField * valPwdTextField;
    IBOutlet KGTextField * valCodeTextField;
    
    IBOutlet UILabel     * pwdLabel;
    IBOutlet UIButton    * valCodeBtn;
    IBOutlet UIButton    * submitBtn;
    BOOL                   isCountDowning;           //是否倒计时中
    NSTimer              * timer;
    NSInteger              timeCount;
    KGUser               * user;
}

@end

@implementation RegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.type == Number_One) {
        self.title = @"用户注册";
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"zhuche4"] forState:UIControlStateNormal];
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"zhuche3"] forState:UIControlStateHighlighted];
    } else {
        self.title = @"找回密码";
        pwdLabel.text = @"旧密码";
    }
    
//    [self setViewParame];
    [valCodeBtn setBorderWithWidth:0 color:[UIColor clearColor] radian:5.0];
    [self registerBtnEnable:NO alpha:Number_ViewAlpha_Three];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


/**
 *  添加输入框到array统一管理验证
 */
- (void)addTextFieldToMArray
{
    [phoneTextField setTextFielType:KGTextFielType_Phone];
    [phoneTextField setMessageStr:@"请输入正确的电话号码"];
    [textFieldMArray addObject:phoneTextField];
    
    [pwdTextField setTextFielType:KGTextFielType_Empty];
    [pwdTextField setMessageStr:@"密码不能为空"];
    [textFieldMArray addObject:pwdTextField];
    
    [valPwdTextField setTextFielType:KGTextFielType_Empty];
    [valPwdTextField setMessageStr:@"确认密码不能为空"];
    [textFieldMArray addObject:valPwdTextField];
    
    [valCodeTextField setTextFielType:KGTextFielType_Empty];
    [valCodeTextField setMessageStr:@"验证码不能为空"];
    [textFieldMArray addObject:valCodeTextField];
}


- (void)setViewParame {
    UIView * view = nil;
    for(NSInteger i=10; i<16; i++) {
        view = [self.contentView viewWithTag:i];
        [view setBorderWithWidth:Number_One color:[UIColor themeColorBtnBg] radian:Number_Three];
    }
}


- (IBAction)valCodeBtnClicked:(UIButton *)sender {
    if(![self vaildPhoneAndPwd]){
        //request
        [self starDownTime];
        
        [[KGHttpService sharedService] getPhoneVlCode:phoneTextField.text type:_type success:^(NSString *msgStr) {
            [self registerBtnEnable:YES alpha:Number_ViewAlpha_Ten];
        } faild:^(NSString *errorMsg) {
            [self stopTime];
            [self registerBtnEnable:NO alpha:Number_ViewAlpha_Three];
            [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
        }];
    }
}


- (IBAction)submitBtnClicked:(UIButton *)sender {
    
    if([self validateInputInView]) {
        NSString * phone = [KGNSStringUtil trimString:phoneTextField.text];
        NSString * pwd = [KGNSStringUtil trimString:pwdTextField.text];
        NSString * valPwd = [KGNSStringUtil trimString:valPwdTextField.text];
        NSString * valCode = [KGNSStringUtil trimString:valCodeTextField.text];
        
        if(![pwd isEqualToString:valPwd]) {
            //密码不一致
            [self notificationMessage:@"两次密码不一致"];
            return;
        }
        
        if(!user) {
            user = [[KGUser alloc] init];
        }
        
        user.tel         = phone;
        user.oldpassowrd = pwd;
        [user setUserPassword:[KGNSStringUtil trimString:valPwd]];
        user.type        = _type;
        user.smscode     = valCode;
        
        if(self.type == Number_One) {
            [self submitReg];
        } else if(self.type == Number_Two) {
            [self submitFindPwd];
        } else {
            
        }
    }
}


- (void)submitReg {
    
    [[KGHttpService sharedService] reg:user success:^(NSString *msgStr) {
        [[KGHUD sharedHud] show:self.view onlyMsg:msgStr];
        [self.navigationController popViewControllerAnimated:YES];
    } faild:^(NSString *errorMsg) {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}


- (void)submitFindPwd {
    
    [[KGHttpService sharedService] updatePwd:user success:^(NSString *msgStr) {
        [[KGHUD sharedHud] show:self.view onlyMsg:msgStr];
        [self.navigationController popViewControllerAnimated:YES];
    } faild:^(NSString *errorMsg) {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}

//验证手机号
- (BOOL)vaildPhoneAndPwd{
    NSString * phone = [phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(phone.length == Number_Zero || ![KGFormVerify validateMobile:phone]){
        [self notificationMessage:String_Verify_Phone];
        return YES;
    }
    return NO;
}


-(void)starDownTime{
    if(!isCountDowning){
        isCountDowning = YES;
        valCodeBtn.userInteractionEnabled = NO;
        if(!timer){
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setDownTime) userInfo:nil repeats:YES];
        }
        timeCount = Number_Ten * Number_Three;
        [timer setFireDate:[NSDate distantPast]];//开启
    }
}

- (void)setDownTime{
    timeCount--;
    if(timeCount >= Number_Zero){
        [valCodeBtn setText:[NSString stringWithFormat:@"%lds",(long)timeCount]];
    }else{
        [self stopTime];
    }
}

- (void)stopTime{
    [timer setFireDate:[NSDate distantFuture]];//暂停
    [valCodeBtn setText:@"获取"];
    valCodeBtn.userInteractionEnabled = YES;
    isCountDowning = NO;
    if(timeCount == Number_Zero){
        [self registerBtnEnable:YES alpha:Number_ViewAlpha_Ten];
    }
}


//注册提交按钮不可用
- (void)registerBtnEnable:(BOOL)enable alpha:(CGFloat)alpha{
    [submitBtn setEnabled:enable];
    [submitBtn setAlpha:alpha];
}


@end
