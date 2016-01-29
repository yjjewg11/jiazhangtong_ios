//
//  FPFamilyPhotoUploadDomain.h
//  kindergartenApp
//
//  Created by Mac on 16/1/29.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPFamilyPhotoUploadDomain : NSObject

@property (assign, nonatomic) NSInteger status; //1 等待上传,2上传中.3:上传失败.0:上传成功.

@property (strong, nonatomic) NSURL * localurl;

@property (strong, nonatomic) UIImage * suoluetu;

@end
