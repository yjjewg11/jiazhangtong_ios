//
//  BaseReplyDomain.h
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/3/31.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KGBaseDomain.h"

@interface BaseReplyDomain: KGBaseDomain

@property (strong, nonatomic) NSString * content;
@property (strong, nonatomic) NSString * rel_uuid;

@property (assign, nonatomic) KGTopicType type;

@property (strong, nonatomic) NSString * to_useruuid;   //标题
@property (strong, nonatomic) NSString * create_user;   //创建人名
@property (strong, nonatomic) NSString * create_useruuid;//创建人uuid
@property (strong, nonatomic) NSString * create_img;      //创建人头像
@property (strong, nonatomic) NSString * create_time;    //创建时间


@end
