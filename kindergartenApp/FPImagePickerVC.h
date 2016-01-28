//
//  FPImagePickerVC.h
//  kindergartenApp
//
//  Created by Mac on 16/1/28.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "BaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface FPImagePickerVC : BaseViewController

@property (nonatomic , strong) NSMutableArray * groups;

@property (nonatomic , strong) ALAssetsLibrary * library;

+ (ALAssetsLibrary *)defaultAssetsLibrary;

@end
