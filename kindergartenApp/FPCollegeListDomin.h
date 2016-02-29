//
//  FPCollegeListDomin.h
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/2/29.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface FPCollegeListDomin : KGBaseDomain

@property (assign, nonatomic) int pageSize;

@property (assign, nonatomic) int pageNo;

@property (strong, nonatomic) NSArray * data;



@end
