//
//  BindTelController.h
//  kindergartenApp
//
//  Created by liumingquan on 16/4/19.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "BaseKeyboardViewController.h"
#import "MBProgressHUD+HM.h"
@interface BindTelController : BaseKeyboardViewController
@property(strong, nonatomic) NSString * tel;
@property(strong, nonatomic) NSString * type;
@property(strong, nonatomic) NSString * smsCode;
@property(strong, nonatomic) NSString * access_token;
@end
