//
//  SPCourseDetailDomain.h
//  kindergartenApp
//
//  Created by Mac on 15/10/29.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface SPCourseDetailDomain : KGBaseDomain

@property (strong, nonatomic) NSString * groupuuid;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * context;
@property (strong, nonatomic) NSString * type;
@property (assign, nonatomic) double fees;
@property (assign, nonatomic) double discountfees;
@property (strong, nonatomic) NSString * subtype;
@property (strong, nonatomic) NSString * schedule;
@property (assign, nonatomic) NSInteger ct_stars;
@property (assign, nonatomic) NSInteger ct_study_students;
@property (assign, nonatomic) BOOL isFavor;
@property (assign, nonatomic) NSString * share_url;
@property (strong, nonatomic) NSString * address;

@property (strong, nonatomic) NSString * age_min_max;
@property (strong, nonatomic) NSString * obj_url;

@end
