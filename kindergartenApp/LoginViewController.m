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

@interface LoginViewController () <UITextFieldDelegate>
{
    IBOutlet UIImageView * headImageView;
    IBOutlet UIImageView * savePwdImageView;
//    IBOutlet UIButton * savePwdBtn;
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
    [self.view setBackgroundColor:[UIColor colorWithHexCode:@"#FF6666"]];
    [headImageView setBorderWithWidth:Number_Zero color:[UIColor clearColor] radian:headImageView.width / Number_Two];
    NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:UserNameKey];
    NSString * password = [[NSUserDefaults standardUserDefaults] objectForKey:PasswordKey];
    _userNameTextField.text = userName;
    _userNameTextField.delegate = self;
    _userPwdTextField.text = password;
    _userPwdTextField.delegate = self;
    
//    if (userName != nil && password != nil)
//    {
//        savePwdBtn.selected = YES;
//        savePwdImageView.image = [UIImage imageNamed:savePwdBtn.selected ? @"jizhu" : @"bujizhu"];
//    }
    
    //注册键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
//    [self showAlertBindTelView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)savePwdBtnClicked:(UIButton *)sender
{
//    savePwdBtn.selected = !sender.selected;
//    savePwdImageView.image = [UIImage imageNamed:savePwdBtn.selected ? @"jizhu" : @"bujizhu"];
    if (YES) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserNameKey];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:PasswordKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (IBAction)findPwdBtnClicked:(UIButton *)sender
{
    [currentOperationField resignFirstResponder];
    
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
    
    if([self validateInputInView])
    {
        //不勾选保存密码 也需要保存用户名
        [[NSUserDefaults standardUserDefaults] setObject:_userNameTextField.text forKey:UserNameKey];
        if (YES)
        {
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
            [MBProgressHUD showSuccess:@"登录成功"];
            
            if(YES)
            {
                [KGAccountTool saveAccount:user];
            }
//            else
//            {
//                [KGAccountTool delAccount];
//            }
            
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
        [GuidePageController firstLaunch];
    });
}



#pragma mark - 监听键盘事件
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (keyboardOn == NO)
    {
        [UIView animateWithDuration:0.2 animations:^
        {
            [self.view setOrigin:CGPointMake(self.view.frame.origin.x, self.view.frame.origin.y - (100 + 5))];
            keyboardOn = YES;
        }];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    if (keyboardOn == YES)
    {
        [UIView animateWithDuration:0.2 animations:^
        {
            [self.view setOrigin:CGPointMake(self.view.frame.origin.x, self.view.frame.origin.y + (100 + 5))];
            keyboardOn = NO;
        }];
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
- (IBAction)btn_touchInside_qq:(id)sender {
    
    NSString *platformName = [UMSocialSnsPlatformManager getSnsPlatformString:UMSocialSnsTypeMobileQQ];
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
   
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
       
        NSLog(@"login response is %@",response);
     
        //获取微博用户名、uid、token等
       
        if (response.responseCode == UMSResponseCodeSuccess) {
          
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
          
            NSLog(@"username is %@, uid is %@, token is %@,iconUrl is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
        NSDictionary * dic = @{@"appid" : ShareKey_TencentWB,
                               @"access_token": snsAccount.accessToken,
                               @"openid":snsAccount.openId};
                   [self userThirdLoginQQ_access_token:dic];
        
       }
        

        
       	
    });
}
- (IBAction)btn_touchInside_wenxin:(id)sender {

    	
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //  获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            NSDictionary * dic = @{@"appid" : ShareKey_WeChat,
                                   @"access_token": snsAccount.accessToken,
                                   @"openid":		snsAccount.openId};
            [self userThirdLoginWenXin_access_token:dic];

            
            NSLog(@"username is %@, uid is %@, token is %@ iconUrl is %@,openId=%@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL,snsAccount.openId);
        }
    });
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

//- (void)thrid_bindAccount{
//    
//    NSString * url=[NSString stringWithFormat:@"%@%@", [KGHttpUrl getBaseServiceURL], @"/rest/userinfo/bindAccount.json"];
//    
//    [[KGHttpService sharedService] postByDomainBodyJson:url params:self.domain success:^(KGBaseDomain *baseDomain) {
//        [self hidenLoadView];
//        [MBProgressHUD showSuccess:baseDomain.ResMsg.message];
//    } faild:^(NSString *errorMessage) {
//        [self hidenLoadView];
//        [MBProgressHUD showError:errorMessage];
//    }];
//    
//    
//}
//
- (void)userThirdLoginQQ_access_token: (NSDictionary * ) dic{
    
    NSString * url=[NSString stringWithFormat:@"%@%@", [KGHttpUrl getBaseServiceURL], @"rest/userThirdLoginQQ/access_token.json"];
        [[KGHUD sharedHud] show:self.view msg:@"登录中..."];
    
    [[KGHttpService sharedService] getByDicByParams:url param:dic success:^(id success) {
        [[KGHUD sharedHud] hide:self.view];
        
        NSDictionary * responseDic=success;
        ;
           self.type=@"qq";
        
        self.access_token=[dic objectForKey:@"access_token"];
        NSLog(@"needBindTel=%@",[responseDic objectForKey:@"needBindTel"]);
        if([@"0"  isEqualToString:[responseDic objectForKey:@"needBindTel"]]){//不需绑定
            [self userinfo_thirdLogin:self.access_token type:self.type];
        }else{
            [self showAlertBindTelView];
            
        }

//        [MBProgressHUD showSuccess:baseDomain.ResMsg.message];
    } failed:^(NSString *errorMsg) {
        [[KGHUD sharedHud] hide:self.view];

        [MBProgressHUD showError:errorMsg];
    }];
    
    
    
}

- (void)userThirdLoginWenXin_access_token: (NSDictionary * ) dic{
    
    NSString * url=[NSString stringWithFormat:@"%@%@", [KGHttpUrl getBaseServiceURL], @"rest/userThirdLoginWenXin/access_token.json"];
    [[KGHUD sharedHud] show:self.view msg:@"验证..."];
    
    [[KGHttpService sharedService] getByDicByParams:url param:dic success:^(id success) {
        [[KGHUD sharedHud] hide:self.view];
        
        NSDictionary * responseDic=success;
        ;
        self.type=@"weixin";
        self.access_token=[dic objectForKey:@"access_token"];
        if([@"0"  isEqualToString:[responseDic objectForKey:@"needBindTel"]]){//不需绑定
            [self userinfo_thirdLogin:self.access_token type:self.type];
        }else{
            [self showAlertBindTelView];
            
        }
        //        [MBProgressHUD showSuccess:baseDomain.ResMsg.message];
    } failed:^(NSString *errorMsg) {
        [[KGHUD sharedHud] hide:self.view];
        
        [MBProgressHUD showError:errorMsg];
    }];
       
    
    
    
}

/**
 access_token
 String
 是
 票据
 type
 String
 是
 取值:qq, weixin
 */
- (void)userinfo_thirdLogin: (NSString *)access_token type:(NSString *)type{
    
    NSDictionary *  dic=@{@"access_token":access_token,@"type":type};
    NSString * url=[NSString stringWithFormat:@"%@%@", [KGHttpUrl getBaseServiceURL], @"rest/userinfo/thirdLogin.json"];
    [[KGHUD sharedHud] show:self.view msg:@"登录中..."];
    
    [[KGHttpService sharedService] postByDicByParams:url param:dic success:^(id success) {
        [[KGHUD sharedHud] hide:self.view];
        LoginRespDomain *loginRespDomain = [LoginRespDomain objectWithKeyValues:success];
       [KGHttpService sharedService].loginRespDomain = loginRespDomain;
        [KGHttpService sharedService].userinfo=loginRespDomain.userinfo;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:loginRespDomain.JSESSIONID forKey:Key_loginJessionID];
         [defaults setObject:type forKey:KEY_thirdLogin_type];
         [defaults setObject:access_token forKey:KEY_thirdLogin_access_token];
        [defaults synchronize];
        [self loginSuccess];
     
        
        
        
    } failed:^(NSString *errorMsg) {
        [[KGHUD sharedHud] hide:self.view];
        
        [MBProgressHUD showError:errorMsg];
    }];
    

    
    
}
//弹出 提示绑定手机也没
-(void)showAlertBindTelView{
    NSLog(@"showAlertBindTelView");
    AlertBindTelView *alert= [[[NSBundle mainBundle] loadNibNamed:@"AlertBindTelView" owner:nil options:nil] firstObject];
//    [alert setFrame:CGRectMake(0, 0,APPWINDOWWIDTH, APPWINDOWHEIGHT)];
//    alert.backgroundColor = KGColorFrom16(0xF54B68);
    CGRect frame = alert.frame;
    NSLog(@"frame1=%f,%f,%f,%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    frame = self.view.frame;
    NSLog(@"frame2=%f,%f,%f,%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);

    
    [self.view addSubview:alert];
    
    
    
    // 防止block中的循环引用
    __weak typeof(self) weakSelf = self;
    // 初始化view并设置背景
    UIView *view = alert;
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
  
    // 使用mas_makeConstraints添加约束
    [view mas_makeConstraints:^(MASConstraintMaker * make) {
        // 添加大	小约束（make就是要添加约束的控件view）
        make.size.mas_equalTo(CGSizeMake(APPWINDOWWIDTH-100, APPWINDOWHEIGHT-100));
        
        // 添加居中约束（居中方式与self相同）
        make.center.equalTo(weakSelf.view); }];
  

//    return;
    alert.bindTelBtn=^{
        BindTelController * regVC = [[BindTelController alloc] init];
        regVC.type=self.type;
        regVC.access_token= self.access_token;
        [self.navigationController pushViewController:regVC animated:YES];
         [alert removeFromSuperview];

    };
    
    alert.cancelBtn=^{
        [self userinfo_thirdLogin:self.access_token type:self.type];
//         [self loginSuccess];
        [alert removeFromSuperview];
       
    };
    
}

@end
