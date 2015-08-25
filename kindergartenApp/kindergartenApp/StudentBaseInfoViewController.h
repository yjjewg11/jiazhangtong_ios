//
//  StudentBaseInfoViewController.h
//  kindergartenApp
//  学生基本信息
//  Created by You on 15/7/23.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "BaseKeyboardViewController.h"
#import "KGUser.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "VPImageCropperViewController.h"

@interface StudentBaseInfoViewController : BaseKeyboardViewController <VPImageCropperDelegate>

@property (strong, nonatomic) KGUser * studentInfo;
@property (nonatomic, copy) void (^StudentUpdateBlock)(KGUser * stidentObj);

- (IBAction)changeHeadImgBtnClicked:(UIButton *)sender;

- (IBAction)sexBtnClicked:(UIButton *)sender;
- (IBAction)birthdayBtnClicked:(UIButton *)sender;

@end
