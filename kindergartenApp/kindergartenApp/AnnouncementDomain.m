//
//  AnnouncementDomain.m
//  kindergartenApp
//
//  Created by You on 15/7/21.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "AnnouncementDomain.h"
#import "MJExtension.h"

@implementation AnnouncementDomain

//属性名映射
//+(void)initialize{
//    [super initialize];
//    
//    [self setupObjectClassInArray:^NSDictionary *{
//        return @{@"\"share_url\""       : @"shareUrl"};
//    }];
//}

- (void)setType:(NSInteger)type {
    _type = type;
    
    if(type == Number_Zero) {
        self.topicType = Topic_XYGG;
    } else {
        self.topicType = Topic_Announcement;
    }
}

@end
