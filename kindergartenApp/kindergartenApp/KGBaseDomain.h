//
//  FuniBaseDomain.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/5/30.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResMsgDomain.h"
#import "PageInfoDomain.h"

@interface KGBaseDomain : NSObject

@property (strong, nonatomic) NSString       * uuid;
@property (strong, nonatomic) ResMsgDomain   * ResMsg;


@property (strong, nonatomic) id  data;


@end
