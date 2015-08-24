//
//  KGUser.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/18.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface KGUser : KGBaseDomain


@property (strong, nonatomic) NSString * loginname;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * oldpassowrd;
@property (strong, nonatomic) NSString * password;
@property (strong, nonatomic) NSString * nickname;
@property (assign, nonatomic) BOOL       sex;
@property (strong, nonatomic) NSString * tel;
@property (strong, nonatomic) NSString * tel_verify;
@property (assign, nonatomic) BOOL       disable;
@property (strong, nonatomic) NSString * login_time;
@property (strong, nonatomic) NSString * create_time;
@property (strong, nonatomic) NSString * last_login_time;
@property (assign, nonatomic) NSInteger  type;
@property (strong, nonatomic) NSString * email;
@property (strong, nonatomic) NSString * headimg; ///uploadFile/getImgFile.json?uuid=
@property (strong, nonatomic) NSString * birthday;
@property (strong, nonatomic) NSString * ma_tel;
@property (strong, nonatomic) NSString * ba_tel;
@property (strong, nonatomic) NSString * nai_tel;
@property (strong, nonatomic) NSString * ye_tel;
@property (strong, nonatomic) NSString * waipo_tel;
@property (strong, nonatomic) NSString * waigong_tel;
@property (strong, nonatomic) NSString * other_tel;
@property (strong, nonatomic) NSString * groupuuid;
@property (strong, nonatomic) NSString * classuuid;
@property (strong, nonatomic) NSString * ma_name;
@property (strong, nonatomic) NSString * ba_name;
@property (strong, nonatomic) NSString * ye_name;
@property (strong, nonatomic) NSString * nai_name;
@property (strong, nonatomic) NSString * waig_name;
@property (strong, nonatomic) NSString * waipo_name;
@property (strong, nonatomic) NSString * address;
@property (strong, nonatomic) NSString * note;
@property (strong, nonatomic) NSString * ma_work;
@property (strong, nonatomic) NSString * ba_work;
@property (strong, nonatomic) NSString * idcard;

@property (strong, nonatomic) NSString * smscode;

- (void)setUserPassword:(NSString *)password;

@end
