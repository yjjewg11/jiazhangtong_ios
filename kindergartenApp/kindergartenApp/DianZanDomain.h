//
//  DianZanDomain.h
//  kindergartenApp
//
//  Created by You on 15/7/27.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface DianZanDomain : KGBaseDomain

@property (assign, nonatomic) NSInteger count; //点赞总数
@property (strong, nonatomic) NSString * names;//显示点赞人姓名,多个逗号分割.
@property (assign, nonatomic) BOOL canDianzan;//True表示可以点赞,false表示点赞过了.可以取消点赞.

@end
