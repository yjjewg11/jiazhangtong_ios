//
//  SPCourseTypeDomain.h
//  kindergartenApp
//
//  Created by Mac on 15/10/22.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface SPCourseTypeDomain : KGBaseDomain

@property (assign, nonatomic) NSInteger  datakey;
@property (strong, nonatomic) NSString * datavalue;     //分类名称
@property (strong, nonatomic) NSString * img;           //图标url全地址.

@end
