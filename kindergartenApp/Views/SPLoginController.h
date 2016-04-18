//
//  SPLoginController.h
//  WXOpenIMSampleDev
//
//  Created by huanglei on 15/4/12.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SPLoginAutoLoginCompletion)(void);

@interface SPLoginController : UIViewController

+ (void)getLastUserID:(NSString **)aUserID lastPassword:(NSString **)aPassword;

@end
