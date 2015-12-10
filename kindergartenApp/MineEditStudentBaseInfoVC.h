//
//  MineEditStudentBaseInfoVC.h
//  kindergartenApp
//
//  Created by Mac on 15/12/10.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "BaseViewController.h"
#import "KGUser.h"

@interface MineEditStudentBaseInfoVC : BaseViewController

@property (strong, nonatomic) KGUser * student;

@property (nonatomic, copy) void (^StudentUpdateBlock)(KGUser * stidentObj);

@end
