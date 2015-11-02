//
//  CardInfoDomain.h
//  kindergartenApp
//
//  Created by You on 15/8/13.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface CardInfoDomain : KGBaseDomain

@property (strong, nonatomic) NSString * cardid;  //	卡号
@property (strong, nonatomic) NSString * name;  //	显示卡使用者
@property (strong, nonatomic) NSString * note;  //	备注
@property (strong, nonatomic) NSString * createtime;  //	绑定时间

@end
