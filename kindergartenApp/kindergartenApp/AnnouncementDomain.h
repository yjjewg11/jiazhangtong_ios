//
//  AnnouncementDomain.h
//  kindergartenApp
//  公告
//  Created by You on 15/7/21.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface AnnouncementDomain : KGBaseDomain

@property (strong, nonatomic) NSString * groupuuid; //关联学校id,需要转换成学校
@property (strong, nonatomic) NSString * title; 	//标题
@property (strong, nonatomic) NSString * content;	     //HTML	内容
@property (strong, nonatomic) NSString * create_user;	 //创建人名
@property (strong, nonatomic) NSString * create_useruuid;//创建人uuid
@property (strong, nonatomic) NSString * create_time;	 //创建时间
@property (assign, nonatomic) NSInteger  count;	         //浏览总数

@end
