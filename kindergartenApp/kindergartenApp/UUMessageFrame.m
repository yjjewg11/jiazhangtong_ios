//
//  UUMessageFrame.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-26.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUMessageFrame.h"
#import "UUMessage.h"
#import "MLEmojiLabel.h"

@implementation UUMessageFrame

- (void)setMessage:(UUMessage *)message{
    
    _message = message;
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    // 1、计算时间的位置
    if (_showTime){
        CGFloat timeY = ChatMargin;
        CGSize timeSize = [_message.strTime sizeWithFont:ChatTimeFont constrainedToSize:CGSizeMake(300, 100) lineBreakMode:NSLineBreakByWordWrapping];

        CGFloat timeX = (screenW - timeSize.width) / 2;
        _timeF = CGRectMake(timeX, timeY, timeSize.width + ChatTimeMarginW, timeSize.height + ChatTimeMarginH);
    }
    
    
    // 2、计算头像位置
    CGFloat iconX = ChatMargin;
    if (_message.from == UUMessageFromMe) {
        iconX = screenW - ChatMargin - ChatIconWH;
    }
    CGFloat iconY = CGRectGetMaxY(_timeF) + ChatMargin;
    _iconF = CGRectMake(iconX, iconY, ChatIconWH, ChatIconWH);
    
    // 3、计算ID位置
    _nameF = CGRectMake(iconX, iconY+ChatIconWH, ChatIconWH, 20);
    
    // 4、计算内容位置
    CGFloat contentX = CGRectGetMaxX(_iconF)+ChatMargin;
    CGFloat contentY = iconY;
   
    //根据种类分
    CGSize contentSize;
    switch (_message.type) {
        case UUMessageTypeText:
//            contentSize = [_message.strContent sizeWithFont:ChatContentFont  constrainedToSize:CGSizeMake(ChatContentW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        
            contentSize = [MLEmojiLabel boundingRectWithSize:_message.strContent w:ChatContentW font:14];
            break;
        case UUMessageTypePicture:
            contentSize = CGSizeMake(ChatPicWH, ChatPicWH);
            break;
        case UUMessageTypeVoice:
            contentSize = CGSizeMake(120, 20);
            break;
        default:
            break;
    }
    
    CGFloat contentTextViewX = contentX + 20;
    if (_message.from == UUMessageFromMe) {
        contentX = iconX - contentSize.width - ChatContentLeft - ChatContentRight - ChatMargin;
        contentTextViewX = contentX + 5;
    }
    
    
//    _contentF = CGRectMake(contentX, contentY, contentSize.width + ChatContentLeft + ChatContentRight, contentSize.height + ChatContentTop + ChatContentBottom);
    
    _contentF = CGRectMake(contentX, contentY, contentSize.width + ChatContentLeft, contentSize.height + 20);
    
    _contentTextViewF = CGRectMake(contentTextViewX, contentY+ChatMargin, contentSize.width, contentSize.height);
    
    _cellHeight = MAX(CGRectGetMaxY(_contentF), CGRectGetMaxY(_nameF))  + ChatMargin;
    
}

@end
