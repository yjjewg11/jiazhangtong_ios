//
//  FPMoive4QDomain.h
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/3/27.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface FPMoive4QDomain : KGBaseDomain
@property (copy, nonatomic) NSString * title;
@property (copy, nonatomic) NSString * herald;
@property (assign, nonatomic) NSInteger  photo_count;
@property (copy, nonatomic) NSString * create_useruuid;
@property (copy, nonatomic) NSString * create_username;
@property (assign, nonatomic) NSInteger status;
@property (copy, nonatomic) NSString * create_time;
@property (assign, nonatomic) NSInteger reply_count;
@property (copy, nonatomic) id dianZan;


@end
