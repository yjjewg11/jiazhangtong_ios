//
//  FPTimeLineCommentDomain.h
//  kindergartenApp
//
//  Created by Mac on 16/2/22.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface FPTimeLineCommentDomain : KGBaseDomain

@property (strong, nonatomic) NSString * content;
@property (strong, nonatomic) NSString * create_user;
@property (strong, nonatomic) NSString * create_useruuid;
@property (strong, nonatomic) NSString * create_img;
@property (strong, nonatomic) NSString * to_useruuid;
@property (strong, nonatomic) NSString * to_user;
@property (strong, nonatomic) NSString * create_time;

@end
