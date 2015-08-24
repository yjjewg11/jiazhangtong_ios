//
//  UUMessage.h
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-26.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WriteVO.h"

typedef NS_ENUM(NSInteger, MessageType) {
    UUMessageTypeText     = 0 , // 文字
    UUMessageTypePicture  = 1 , // 图片
    UUMessageTypeVoice    = 2   // 语音
};


typedef NS_ENUM(NSInteger, MessageFrom) {
    UUMessageFromMe    = 0,   // 自己发的
    UUMessageFromOther = 1    // 别人发得
};


@interface UUMessage : NSObject

@property (nonatomic, copy) NSString *strIcon;
@property (nonatomic, copy) NSString *strId;
@property (nonatomic, copy) NSString *strTime;
@property (nonatomic, copy) NSString *strName;

@property (nonatomic, copy) NSString *requestContent;
@property (nonatomic, copy) NSString *strContent;
@property (nonatomic, copy) UIImage  *picture;
@property (nonatomic, copy) NSData   *voice;
@property (nonatomic, copy) NSString *strVoiceTime;
@property (nonatomic, assign) BOOL isNewMsg; //上方新消息 =YES 需要显示hud
@property (nonatomic, assign) MessageType type;
@property (nonatomic, assign) MessageFrom from;

@property (nonatomic, assign) BOOL showDateLabel;
@property (nonatomic, strong) WriteVO * writeVO;

- (void)setWithDict:(NSDictionary *)dict;

- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end;

@end
