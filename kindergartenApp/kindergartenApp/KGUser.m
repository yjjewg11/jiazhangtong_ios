//
//  KGUser.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/18.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGUser.h"
#import "MJExtension.h"
#import "KGNSStringUtil.h"

@implementation KGUser

MJCodingImplementation

- (void)setUserPassword:(NSString *)password {
    _password = [KGNSStringUtil md5:password];
}


- (void)setOldpassowrd:(NSString *)oldpassowrd {
    _oldpassowrd = [KGNSStringUtil md5:oldpassowrd];
}

@end
