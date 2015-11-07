//
//  SPSchoolDomain.h
//  kindergartenApp
//
//  Created by Mac on 15/10/28.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface SPSchoolDomain : KGBaseDomain

@property (strong, nonatomic) NSString * img;

@property (strong, nonatomic) NSString * brand_name;

@property (strong, nonatomic) NSString * link_tel;

@property (strong, nonatomic) NSString * map_point;

@property (strong, nonatomic) NSString * createtime; //绑定时间

@property (assign, nonatomic) NSInteger ct_stars;

@property (assign, nonatomic) NSInteger ct_study_students;

@property (strong, nonatomic) NSString * address;

@property (strong, nonatomic) NSString * distance;

@property (strong, nonatomic) NSString * summary;

@property (strong, nonatomic) NSString * groupDescription;

@property (assign, nonatomic) BOOL isFavor;


@end
