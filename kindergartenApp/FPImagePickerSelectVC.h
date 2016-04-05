//
//  FPImagePickerSelectVC.h
//  kindergartenApp
//
//  Created by Mac on 16/1/28.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "BaseViewController.h"
#import "FPImagePickerVC.h"
#import "FPImagePickerGroupDomain.h"

//本地选择照片上传服务器
@interface FPImagePickerSelectVC : BaseViewController

@property (strong, nonatomic) ALAssetsGroup * group;

@property (assign, nonatomic) NSInteger totalCount;

@end
