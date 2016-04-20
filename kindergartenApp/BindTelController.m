//
//  BindTelController.m
//  kindergartenApp
//
//  Created by liumingquan on 16/4/19.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "BindTelController.h"
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
@interface BindTelController ()
{
    
    IBOutlet KGTextField * phoneTextField;
    
    IBOutlet KGTextField * valCodeTextField;
    
 
    IBOutlet UIButton    * valCodeBtn;
    IBOutlet UIButton    * submitBtn;
    BOOL                   isCountDowning;           //是否倒计时中
    NSTimer              * timer;
    NSInteger              timeCount;
    KGUser               * user;
}
@end

@implementation BindTelController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [valCodeBtn setBorderWithWidth:0 color:[UIColor clearColor] radian:5.0];
    
    [self registerBtnEnable:YES alpha:Number_ViewAlpha_Ten];
    
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
    
    
    [valCodeTextField setTextFielType:KGTextFielType_Empty];
    [valCodeTextField setMessageStr:@"验证码不能为空"];
    [textFieldMArray addObject:valCodeTextField];
}


- (void)setViewParame {
    return;
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
        
        [[KGHttpService sharedService] getPhoneVlCode:phoneTextField.text type:3 success:^(NSString *msgStr) {
            [self registerBtnEnable:YES alpha:Number_ViewAlpha_Ten];
        } faild:^(NSString *errorMsg) {
            [self stopTime];
           
            [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
        }];
    }
}


- (IBAction)submitBtnClicked:(UIButton *)sender {
    self.tel=phoneTextField.text;
    self.smsCode=valCodeTextField.text;

    if([self validateInputInView])
    {
       	
        
       [self submitFindPwd];    }
}

- (void)submitFindPwd {
    
    
    NSDictionary *  dic=@{@"tel":self.tel,	@"smsCode":self.smsCode,@"type":self.type};
    NSString * url=[NSString stringWithFormat:@"%@%@", [KGHttpUrl getBaseServiceURL], @"rest/userinfo/bindTel.json"];
    [[KGHUD sharedHud] show:self.view];
    
    [[KGHttpService sharedService] postByDicByParams:url param:dic success:^(id success) {
        
        
          UIWindow* window = [UIApplication sharedApplication].keyWindow;
        [window switchRootViewController];
        
    } failed:^(NSString *errorMsg) {
        [[KGHUD sharedHud] hide:self.view];
       
        [MBProgressHUD showError:errorMsg];
    }];
}

//验证手机号
- (BOOL)vaildPhoneAndPwd{
    return NO;
    //    NSString * phone = [phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    if(phone.length == Number_Zero || ![KGFormVerify validateMobile:phone]){
    //        [self notificationMessage:String_Verify_Phone];
    //        return YES;
    //    }
    //    return NO;
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
- (void)registerBtnEnable:(BOOL)enable alpha:(CGFloat)alpha
{
    [submitBtn setEnabled:enable];
    [submitBtn setAlpha:alpha];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
