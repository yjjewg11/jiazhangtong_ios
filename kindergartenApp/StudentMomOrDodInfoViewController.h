//
//  StudentOtherInfoViewController.h
//  kindergartenApp
//  学生其他信息
//  Created by You on 15/7/24.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "BaseKeyboardViewController.h"
#import "KGUser.h"
#import "StudentInfoItemVO.h"

@interface StudentMomOrDodInfoViewController : BaseKeyboardViewController


@property (strong, nonatomic) KGUser * studentInfo;
@property (strong, nonatomic) StudentInfoItemVO * itemVO;
@property (nonatomic, copy) void (^StudentUpdateBlock)(KGUser * stidentObj);

@end
