//
//  SPCourseDetailVO.h
//  kindergartenApp
//
//  Created by Mac on 15/11/20.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface SPCourseDetailVO : KGBaseDomain

@property (strong, nonatomic) NSString * share_url;

@property (strong, nonatomic) NSString * link_tel;

@property (strong, nonatomic) NSString * obj_url;

@property (strong, nonatomic) NSString * age_min_max;

@property (assign, nonatomic) BOOL isFavor;

@end
