//
//  FPImagePickerImageDomain.h
//  kindergartenApp
//
//  Created by Mac on 16/1/28.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPImagePickerImageDomain : NSObject
@property (strong, nonatomic) NSString * uuid;
@property (strong, nonatomic) NSURL * localUrl;
@property (nullable, nonatomic, retain) NSString * note;
@property (assign, nonatomic) BOOL isUpload;

@property (strong, nonatomic) NSString * dateStr;

@property (strong, nonatomic) UIImage * suoluetu;

@property (assign, nonatomic) BOOL isSelect;

@property (assign, nonatomic) BOOL isOlnyShowImg;

@end
