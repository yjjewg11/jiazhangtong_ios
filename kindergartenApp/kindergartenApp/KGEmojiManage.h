//
//  KGEmojiManage.h
//  kindergartenApp
//  表情管理
//  Created by You on 15/8/4.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGEmojiManage : NSObject

@property (strong, nonatomic) NSArray         * emojiArray;     //server表情对象集合
@property (strong, nonatomic) NSMutableDictionary  * emojiMDict;//locat表情字典  key=[name], value=locatpath
//@property (strong, nonatomic) NSMutableArray  * emojiNameArray; //所有的表情名称集合
@property (assign, nonatomic) BOOL              isSwitchEmoji;  //是否是切换表情键盘
@property (assign, nonatomic) BOOL              isChatEmoji;
@property (strong, nonatomic) NSMutableString * chatHTMLInfo;   //聊天消息


+ (KGEmojiManage *)sharedManage;

//在子线程中同步下载表情
- (void)downloadEmoji:(NSArray *)emojiArray;

@end
