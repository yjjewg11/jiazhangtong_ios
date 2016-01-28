//
//  FPFamilyPhotoLastTimeDomain.h
//  kindergartenApp
//
//  Created by Mac on 16/1/21.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface FPFamilyPhotoLastTimeDomain : KGBaseDomain

@property (strong, nonatomic) NSString * family_uuid;
@property (strong, nonatomic) NSString * photo_time;
@property (strong, nonatomic) NSString * create_useruuid;
@property (strong, nonatomic) NSString * path;
@property (strong, nonatomic) NSString * address;
@property (strong, nonatomic) NSString * note;
@property (strong, nonatomic) NSString * md5;

@end
