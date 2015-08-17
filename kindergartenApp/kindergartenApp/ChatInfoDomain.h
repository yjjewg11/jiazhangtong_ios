//
//  chatInfoDomain.h
//  kindergartenApp
//  服务器返回的信息对象
//  Created by You on 15/8/4.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface ChatInfoDomain : KGBaseDomain

@property (strong, nonatomic) NSString * message;  //内容
@property (strong, nonatomic) NSString * send_user;  //发送人名
@property (strong, nonatomic) NSString * send_useruuid;  //发送人uuid
@property (strong, nonatomic) NSString * revice_user;  //接收人名
@property (strong, nonatomic) NSString * revice_useruuid;  //接收人uuid
@property (strong, nonatomic) NSString * create_time;  //创建时间
@property (assign, nonatomic) BOOL       isread	;  //0;未读,1:已读
@property (strong, nonatomic) NSString * group_name;
@property (strong, nonatomic) NSString * group_uuid;
@property (assign, nonatomic) BOOL isdelete;
@property (strong, nonatomic) NSString * title;

@end
