//
//  HomeMenuBtn.m
//  kindergartenApp
//
//  Created by liumingquan on 16/6/2.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "HomeMenuBtn.h"

@implementation HomeMenuBtn
- (instancetype)initData:(NSString * )name iconUrl:(NSString * )iconUrl  tag:(NSInteger )tag {
    
    self.name=name;
    self.iconUrl=iconUrl;
    self.tag=tag;
    return self;
}
@end
