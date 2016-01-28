//
//  FPFamilyPhotoNormalDomain.h
//  kindergartenApp
//
//  Created by Mac on 16/1/22.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface FPFamilyPhotoNormalDomain : KGBaseDomain

@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSString *family_uuid;
@property (nullable, nonatomic, retain) NSString *create_time;
@property (nullable, nonatomic, retain) NSString *photo_time;
@property (nullable, nonatomic, retain) NSString *create_useruuid;
@property (nullable, nonatomic, retain) NSString *path;
@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *note;
@property (nullable, nonatomic, retain) NSString *md5;

@end
