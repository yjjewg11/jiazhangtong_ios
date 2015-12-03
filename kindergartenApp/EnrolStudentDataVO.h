//
//  EnrolStudentDataVO.h
//  kindergartenApp
//
//  Created by Mac on 15/12/2.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface EnrolStudentDataVO : KGBaseDomain

@property (assign, nonatomic) BOOL isFavor;

@property (strong, nonatomic) NSString * obj_url;

@property (strong, nonatomic) NSString * share_url;

@property (strong, nonatomic) NSString * recruit_url; //招生地址

@property (strong, nonatomic) NSString * distance;

@end
