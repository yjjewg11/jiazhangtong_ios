//
//  FPFamilyMembers.h
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/3/22.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

/*
 
 uuid	String	主键
 family_uuid	String	关联家庭uuid
 create_time	String	创建时间
 user_uuid	String	关联人uuid
 tel	String	电话号码。
 family_name	String	家庭称呼.爸爸,妈妈,20限制
 */
@interface FPFamilyMembers : KGBaseDomain
@property (nonatomic, strong) NSString * family_uuid;
@property (nonatomic, strong) NSString * user_uuid;
@property (nonatomic, strong) NSString * tel ;
@property (nonatomic, strong) NSString * family_name;
@end
