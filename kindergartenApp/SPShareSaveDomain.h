//
//  SPShareSaveDomain.h
//  kindergartenApp
//
//  Created by Mac on 15/11/7.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface SPShareSaveDomain : KGBaseDomain

@property (assign, nonatomic) BOOL isFavor;

@property (strong, nonatomic) NSString * share_url;

@property (strong, nonatomic) NSString * link_tel;

@end
