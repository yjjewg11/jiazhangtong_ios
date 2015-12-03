//
//  EnrolStudentSchoolCommentDomain.h
//  kindergartenApp
//
//  Created by Mac on 15/12/3.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface EnrolStudentSchoolCommentDomain : KGBaseDomain

@property (strong, nonatomic) NSString * create_time;

@property (strong, nonatomic) NSString * content;

@property (strong, nonatomic) NSString * create_user;

@property (assign, nonatomic) NSInteger type;

@property (strong, nonatomic) NSString * score;

@end
