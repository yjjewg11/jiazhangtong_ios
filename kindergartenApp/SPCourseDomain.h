//
//  SPCourseDomain.h
//  kindergartenApp
//
//  Created by Mac on 15/10/26.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface SPCourseDomain : KGBaseDomain

@property (strong, nonatomic) NSString * logo;
@property (strong, nonatomic) NSString * group_name;
@property (strong, nonatomic) NSString * address;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * type;
@property (strong, nonatomic) NSString * subtype;
@property (strong, nonatomic) NSString * distance;
@property (assign, nonatomic) NSInteger ct_stars;
@property (assign, nonatomic) NSInteger ct_study_students;

@end
