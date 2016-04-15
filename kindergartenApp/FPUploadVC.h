//
//  FPUploadVC.h
//  kindergartenApp
//
//  Created by Mac on 16/1/20.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "BaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "KGUUID.h"
#import "Reachability.h"
#import "UploadPhotoToRemoteService.h"
#import "MBProgressHUD+HM.h"
@interface FPUploadVC : BaseViewController

@property (nonatomic , strong) ALAssetsLibrary * library;

+ (ALAssetsLibrary *)defaultAssetsLibrary;
@property (assign, nonatomic) BOOL pushToSelectImageVC;

@property (strong, nonatomic) NSString * family_uuid;

@property (assign, nonatomic) BOOL isJumpTwoPages;
@end
