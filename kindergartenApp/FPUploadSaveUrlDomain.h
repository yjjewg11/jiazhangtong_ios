//
//  FPUploadSaveUrlDomain.h
//  kindergartenApp
//
//  Created by Mac on 16/2/1.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPUploadSaveUrlDomain : NSObject
@property (strong, nonatomic) NSString * uuid;
@property (strong, nonatomic) NSString * family_uuid;
@property (strong, nonatomic) NSString * localUrl;
//3.本地图片不存在，失败。
@property (assign, nonatomic) NSInteger status;

@property (strong, nonatomic) NSString * create_date;

@end
