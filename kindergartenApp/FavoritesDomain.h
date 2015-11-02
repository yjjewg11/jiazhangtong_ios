//
//  CollectDomain.h
//  kindergartenApp
//  收藏
//  Created by You on 15/8/13.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface FavoritesDomain : KGBaseDomain

@property (strong, nonatomic) NSString * user_uuid;   //创建人uuid
@property (strong, nonatomic) NSString * title;   //收藏标题名
@property (assign, nonatomic) KGTopicType  type;   //模块类型
@property (strong, nonatomic) NSString * reluuid;   //与type配合确定某个模块的详细的uuid.用于跳转到该模块的详细显示.
@property (strong, nonatomic) NSString * url;   //Type=10的时候,有效.
@property (strong, nonatomic) NSString * createtime;   //创建时间
@property (strong, nonatomic) NSString * show_name;//发布者姓名
@property (strong, nonatomic) NSString * show_img;//发布者头像
@property (strong, nonatomic) NSString * show_uuid;//

@end
