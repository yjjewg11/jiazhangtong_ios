//
//  FPLocalDBPhotoPickerVC.h
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/3/25.
//  Copyright © 2016年 funi. All rights reserved.
//
#import "BaseViewController.h"
#import <UIKit/UIKit.h>
//家庭照片选择器，获取本地数据库数据生成。
@interface FPLocalDBPhotoPickerVC : BaseViewController

//选中的照片集合
@property (strong, nonatomic) NSMutableSet * selectIndexPath;
@end
