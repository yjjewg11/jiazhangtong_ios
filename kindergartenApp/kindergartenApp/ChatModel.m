//
//  ChatModel.m
//  UUChatTableView
//
//  Created by shake on 15/1/6.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "ChatModel.h"
#import "ChatInfoDomain.h"
#import "UUMessage.h"
#import "UUMessageFrame.h"
#import "KGHttpService.h"

@implementation ChatModel

- (NSMutableArray *)dataSource {
    if(!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    
    return _dataSource;
}


- (void)addChatInfosToDataSource:(NSArray *)chatsArray {
   
    for (int i=0; i<[chatsArray count]; i++) {
        
        NSDictionary * dataDic = [self getChatDic:[chatsArray objectAtIndex:i]];
        UUMessageFrame * messageFrame = [[UUMessageFrame alloc]init];
        UUMessage *message = [[UUMessage alloc] init];
        [message setWithDict:dataDic];
        [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
        messageFrame.showTime = message.showDateLabel;
        [messageFrame setMessage:message];
        
        if (message.showDateLabel) {
            previousTime = dataDic[@"strTime"];
        }
//        [self.dataSource addObject:messageFrame];
        [self.dataSource insertObject:messageFrame atIndex:0];
    }
}


- (NSMutableDictionary *)getChatDic:(ChatInfoDomain *)domain {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:domain.message forKey:@"strContent"];
    
    if([domain.send_useruuid isEqualToString:[KGHttpService sharedService].loginRespDomain.userinfo.uuid]) {
        //判断发送者id是否=login的用户id  相等者发送为自己
        [dictionary setObject:@(UUMessageFromMe) forKey:@"from"];
        [dictionary setObject:@"head_def" forKey:@"strIcon"];
    } else {
        //别人发送
        [dictionary setObject:@(UUMessageFromOther) forKey:@"from"];
        [dictionary setObject:_isTeacher?@"head_def":@"group_head_def" forKey:@"strIcon"];
    }
    [dictionary setObject:@(UUMessageTypeText) forKey:@"type"];
    [dictionary setObject:[domain.create_time description] forKey:@"strTime"];
    
    [dictionary setObject:domain.send_user forKey:@"strName"];
    if ([KGHttpService sharedService].loginRespDomain.userinfo.headimg) {
        [dictionary setObject:[KGHttpService sharedService].loginRespDomain.userinfo.headimg forKey:@"strIcon"];
    }
    return dictionary;
}


// 添加自己的item
- (void)addSpecifiedItem:(NSDictionary *)dic
{
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
    UUMessage *message = [[UUMessage alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSString *URLStr = [KGHttpService sharedService].loginRespDomain.userinfo.headimg;
    if(!URLStr) {
        URLStr = @"head_def";
    }
    [dataDic setObject:@(UUMessageFromMe) forKey:@"from"];
    [dataDic setObject:[[NSDate date] description] forKey:@"strTime"];
//    [dataDic setObject:[KGHttpService sharedService].loginRespDomain.userinfo.name forKey:@"strName"];
    [dataDic setObject:URLStr forKey:@"strIcon"];
    
    [message setWithDict:dataDic];
    [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    
    if (message.showDateLabel) {
        previousTime = dataDic[@"strTime"];
    }
    [self.dataSource addObject:messageFrame];
}

// 添加聊天item（一个cell内容）
static NSString *previousTime = nil;


@end
