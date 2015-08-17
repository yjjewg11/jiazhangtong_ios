//
//  AnnouncementDomain.h
//  kindergartenApp
//  公告
//  Created by You on 15/7/21.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"
#import "DianZanDomain.h"
#import "ReplyPageDomain.h"

@interface AnnouncementDomain : KGBaseDomain

@property (strong, nonatomic) NSString * groupuuid; //关联学校id,需要转换成学校
@property (strong, nonatomic) NSString * title; 	//标题
@property (strong, nonatomic) NSString * message;	     //HTML	内容
@property (strong, nonatomic) NSString * create_user;	 //创建人名
@property (strong, nonatomic) NSString * create_useruuid;//创建人uuid
@property (strong, nonatomic) NSString * create_time;	 //创建时间
@property (assign, nonatomic) NSInteger  count;	         //浏览总数
@property (strong, nonatomic) NSString * share_url;      //用于分享的地址.全路径.
@property (assign, nonatomic) BOOL       isimportant;
@property (assign, nonatomic) BOOL       isFavor; //是否收藏
@property (assign, nonatomic) NSInteger  type; //公告类型  0=校园公告  ！=0 老师公告
@property (assign, nonatomic) KGTopicType  topicType;

@property (strong, nonatomic) DianZanDomain * dianzan;//点赞数据
@property (strong, nonatomic) ReplyPageDomain * replyPage; //帖子回复列表

@end
