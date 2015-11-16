//
//  MySPCommentDomain.h
//  kindergartenApp
//
//  Created by Mac on 15/11/16.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface MySPCommentDomain : KGBaseDomain

@property (strong, nonatomic) NSString * create_time;

@property (strong, nonatomic) NSString * content;

@property (strong, nonatomic) NSString * create_user;

@property (strong, nonatomic) NSString * ext_uuid;

@property (assign, nonatomic) NSInteger type;

@property (strong, nonatomic) NSString * score;

@end
