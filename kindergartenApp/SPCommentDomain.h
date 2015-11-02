//
//  SPCommitDomain.h
//  kindergartenApp
//
//  Created by Mac on 15/11/1.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface SPCommentDomain : KGBaseDomain

@property (strong, nonatomic) NSString * create_time;
@property (strong, nonatomic) NSString * content;
@property (strong, nonatomic) NSString * create_user;
@property (strong, nonatomic) NSString * type;
@property (strong, nonatomic) NSString * score;

@end
