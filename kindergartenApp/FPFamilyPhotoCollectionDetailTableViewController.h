//
//  FPFamilyPhotoCollectionDetailTableViewController.h
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/3/22.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "FPHomeVC.h"
#import "VPImageCropperViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface FPFamilyPhotoCollectionDetailTableViewController : BaseViewController<VPImageCropperDelegate>
- (void)loadLoadByUuid:( NSString *) uuid;
@end
