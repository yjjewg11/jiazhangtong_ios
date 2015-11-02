//
//  SPCourseListDomain.h
//  kindergartenApp
//
//  Created by Mac on 15/10/26.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface SPDataListVO : KGBaseDomain

@property (assign, nonatomic) NSInteger pageSize; //每页显示限制.
@property (assign, nonatomic) NSInteger pageNo;   //当前页数

@end
