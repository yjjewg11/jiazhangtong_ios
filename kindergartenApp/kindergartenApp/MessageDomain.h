//
//  MessageDomain.h
//  kindergartenApp
//
//  Created by You on 15/7/28.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface MessageDomain : KGBaseDomain

@property (strong, nonatomic) NSString * title;  //标题
@property (strong, nonatomic) NSString * message; //内容
@property (strong, nonatomic) NSString * group_uuid; //幼儿园uuid
@property (strong, nonatomic) NSString * send_user; //发送人名
@property (strong, nonatomic) NSString * send_useruuid; //	发送人uuid
@property (strong, nonatomic) NSString * revice_user; //	接收人名
@property (strong, nonatomic) NSString * revice_useruuid; //	接收人uuid
@property (strong, nonatomic) NSString * create_time; //	创建时间
@property (assign, nonatomic) BOOL       isread; //	0;未读,1:已读
@property (assign, nonatomic) NSInteger  type; //模块类型.0:公告,3:精品文章.4:招生计划.5:课程表.6:食谱.99:班级互动.10:html类型,直接去url地址,调用浏览器显示.
@property (strong, nonatomic) NSString * rel_uuid; //与type配合确定某个模块的详细的uuid.用于跳转到该模块的详细显示.
@property (strong, nonatomic) NSString * url;

@end
