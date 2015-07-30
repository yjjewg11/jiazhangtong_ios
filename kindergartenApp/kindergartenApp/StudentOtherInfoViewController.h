//
//  StudentOtherInfoViewController.h
//  kindergartenApp
//
//  Created by You on 15/7/24.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "BaseKeyboardViewController.h"
#import "KGUser.h"

@interface StudentOtherInfoViewController : BaseKeyboardViewController


@property (strong, nonatomic) KGUser * studentInfo;
@property (strong, nonatomic) NSMutableArray * dataSource;
@property (assign, nonatomic) NSInteger  index;
@property (nonatomic, copy) void (^StudentUpdateBlock)(KGUser * stidentObj);

@end
