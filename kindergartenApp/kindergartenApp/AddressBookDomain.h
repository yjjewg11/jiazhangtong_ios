//
//  AddressBookDomain.h
//  kindergartenApp
//  通讯录
//  Created by You on 15/8/4.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface AddressBookDomain : KGBaseDomain

@property (strong, nonatomic) NSString * teacher_uuid; //老师uuid,写信时填写用.
@property (strong, nonatomic) NSString * name; //老师名字
@property (strong, nonatomic) NSString * img;  //老师头像
@property (strong, nonatomic) NSString * tel;  //电话号码.  园长没有电话
@property (assign, nonatomic) BOOL       type;  //是否是老师

@end
