//
//  WriteVO.h
//  kindergartenApp
//  提交保存发给老师或者园长的信息对象
//  Created by You on 15/8/4.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface WriteVO : KGBaseDomain

@property (assign, nonatomic) BOOL isTeacher;  //是否是给老师写信   YES=老师,NO=园长
@property (strong, nonatomic) NSString * revice_useruuid; //老师uuid
@property (strong, nonatomic) NSString * message; //内容<html>

@end
