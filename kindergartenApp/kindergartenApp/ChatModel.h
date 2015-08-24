//
//  ChatModel.h
//  UUChatTableView
//
//  Created by shake on 15/1/6.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatModel : NSObject

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (assign, nonatomic) BOOL isTeacher;//是否石老师

@property (nonatomic) BOOL isGroupChat;

- (void)populateRandomDataSource;

- (void)addChatInfosToDataSource:(NSArray *)chatsArray;

- (void)addRandomItemsToDataSource:(NSInteger)number;

- (void)addSpecifiedItem:(NSDictionary *)dic;

@end
