//
//  EnrolStudentsSchoolDomain.h
//  kindergartenApp
//
//  Created by Mac on 15/12/2.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface EnrolStudentsSchoolDomain : KGBaseDomain

@property (strong, nonatomic) NSString * img;

@property (strong, nonatomic) NSString * brand_name;

@property (strong, nonatomic) NSString * link_tel;

@property (assign, nonatomic) NSInteger ct_stars;

@property (strong, nonatomic) NSString * address;

@property (strong, nonatomic) NSString * summary;

@property (strong, nonatomic) NSString * distance;

@property (assign, nonatomic) NSInteger ct_study_students;

@property (strong, nonatomic) NSString * map_point;

@end
