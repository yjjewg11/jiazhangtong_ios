//
//  HomeMenuBtn.h
//  kindergartenApp
//
//  Created by liumingquan on 16/6/2.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeMenuBtn : NSObject
@property (strong, nonatomic) NSString * name;    //菜单名

@property (strong, nonatomic) NSString * iconUrl; //图标

@property (assign, nonatomic) NSInteger  tag;     //tag


- (instancetype)initData:(NSString * )name iconUrl:(NSString * )iconUrl  tag:(NSInteger )tag ;
@end
