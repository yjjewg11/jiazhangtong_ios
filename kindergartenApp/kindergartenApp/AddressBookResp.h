//
//  AddressBookResp.h
//  kindergartenApp
//
//  Created by You on 15/8/4.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface AddressBookResp : KGBaseDomain

@property (strong, nonatomic) NSArray * list;  //老师通讯录
@property (strong, nonatomic) NSArray * listKD;//园长通讯录

@end
