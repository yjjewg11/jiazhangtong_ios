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

@protocol FPLocalDBPhotoPickerVCDelegate <NSObject>

//提交选择数据
- (void)submitSelectMap: (NSMutableDictionary *) selectDomainMap;

@end
@interface FPLocalDBPhotoPickerVC : BaseViewController

//选中的照片集合,uuid
//@property (strong, nonatomic) NSMutableSet * selectIndexPath;
@property (strong, nonatomic) NSMutableDictionary * selectDomainMap;

//选中的照片集合,uuid
@property (strong, nonatomic) id<FPLocalDBPhotoPickerVCDelegate> delegate;

@end
