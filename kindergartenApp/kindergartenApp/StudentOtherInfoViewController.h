//
//  StudentOtherInfoViewController.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/13.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "BaseKeyboardViewController.h"
#import "KGUser.h"
#import "StudentInfoItemVO.h"

@interface StudentOtherInfoViewController : BaseKeyboardViewController

@property (strong, nonatomic) KGUser * studentInfo;
@property (strong, nonatomic) StudentInfoItemVO * itemVO;
@property (nonatomic, copy) void (^StudentUpdateBlock)(KGUser * stidentObj);

@end
