//
//  FPFamilyPhotoUploadDomain.h
//  kindergartenApp
//
//  Created by Mac on 16/1/29.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <Foundation/Foundation.h>
//上传相片进度照片，级上传标示
@interface FPFamilyPhotoUploadDomain : NSObject
@property (strong, nonatomic) NSString * family_uuid; //上传的家庭相册uuid
@property (assign, nonatomic) NSInteger status; //1 等待上传,2上传中.3:上传失败.0:上传成功.

@property (strong, nonatomic) NSURL * localurl;

@property (strong, nonatomic) UIImage * suoluetu;

@end
