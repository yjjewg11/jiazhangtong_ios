//
//  FPFamilyInfoDomain.h
//  kindergartenApp
//
//  Created by Mac on 16/1/26.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface FPFamilyInfoDomain : KGBaseDomain

@property (strong, nonatomic) NSString * family_uuid;
@property (strong, nonatomic) NSString * maxTime;
@property (strong, nonatomic) NSString * minTime;
@property (strong, nonatomic) NSString * updateTime;

@end
