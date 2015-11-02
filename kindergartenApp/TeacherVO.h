//
//  TeacherVO.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/28.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"
#import "DianZanDomain.h"
#import "ReplyPageDomain.h"

@interface TeacherVO : KGBaseDomain

@property (strong, nonatomic) NSString * teacher_uuid;//老师uuid,写信时填写用.
@property (strong, nonatomic) NSString * name;//老师名字
@property (strong, nonatomic) NSString * img; //老师头像
@property (strong, nonatomic) NSString * content;//点评内容，可为空
@property (strong, nonatomic) NSString * teacheruuid;//点评教师UUID
@property (assign, nonatomic) NSInteger type;//类型  1：满意 2：一般 3：不满意
@property (strong, nonatomic) DianZanDomain * dianzan;//点赞数据
@property (strong, nonatomic) ReplyPageDomain * replyPage; //帖子回复列表


@end
