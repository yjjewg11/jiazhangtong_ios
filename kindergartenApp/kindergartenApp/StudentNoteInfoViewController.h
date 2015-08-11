//
//  StudentNoteInfoViewController.h
//  kindergartenApp
//  学生
//  Created by You on 15/7/24.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "BaseKeyboardViewController.h"
#import "KGUser.h"

@interface StudentNoteInfoViewController : BaseKeyboardViewController

@property (strong, nonatomic) KGUser * studentInfo;
@property (nonatomic, copy) void (^StudentUpdateBlock)(KGUser * stidentObj);

@end
