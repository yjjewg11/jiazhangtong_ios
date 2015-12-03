//
//  EnrolStudentSchoolDetailDomain.m
//  kindergartenApp
//
//  Created by Mac on 15/12/2.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "EnrolStudentSchoolDetailDomain.h"
#import "MJExtension.h"

@implementation EnrolStudentSchoolDetailDomain

//属性名映射
+(void)initialize{
    [super initialize];
    [self setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"descriptionDetail":@"description",
                 };
    }];
}

@end
