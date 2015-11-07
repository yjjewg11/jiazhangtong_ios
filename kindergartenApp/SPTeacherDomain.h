//
//  SPTeacherDomain.h
//  kindergartenApp
//
//  Created by Mac on 15/11/6.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface SPTeacherDomain : KGBaseDomain

@property (strong, nonatomic) NSString * name;

@property (strong, nonatomic) NSString * img;

@property (strong, nonatomic) NSString * summary;

@property (strong, nonatomic) NSString * course_title;

@property (assign, nonatomic) NSInteger ct_stars;

@end
