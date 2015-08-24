//
//  TopicFrame.m
//  MYAPP
//
//  Created by Moyun on 15/7/1.
//  Copyright (c) 2015年 Moyun. All rights reserved.
//

#import "TopicFrame.h"
#import "TopicDomain.h"
#import "MLEmojiLabel.h"
#import "TopicInteractionDomain.h"

@implementation TopicFrame


-(void)setTopic:(TopicDomain *)topic{
    
    _topic = topic;
    
    // cell的宽度
    CGFloat cellW = KGSCREEN.size.width;
    
    //用户信息整体
    CGFloat uviewW = cellW;
    CGFloat uviewH = 66;
    CGFloat ux = 0;
    CGFloat uy = 0;
    self.userViewF = CGRectMake(ux, uy, uviewW, uviewH);
    
    /* cell的高度 */
    self.cellHeight = CGRectGetMaxY(self.userViewF);
    
    //头像
    CGFloat headWH = 45;
    CGFloat headX  = CELLPADDING;
    CGFloat headY  = 15;
    self.headImageViewF = CGRectMake(headX, headY, headWH, headWH);
    
    //名称
    CGFloat nameX = CGRectGetMaxX(self.headImageViewF) + TopicCellBorderW;
    CGFloat nameY = headY;
    CGFloat nameW = cellW - CELLPADDING - nameX;
    CGFloat nameH = APPUILABELFONTNO14;
    self.nameLabF = CGRectMake(nameX, nameY, nameW, nameH);
    
    
    //title
    if (self.topic.title && ![self.topic.title isEqualToString:String_DefValue_Empty]) {
        CGFloat titleX = nameX;
        CGFloat titleY = CGRectGetMaxY(self.nameLabF) + 8;
        CGFloat titleH = APPUILABELFONTNO13;
        self.titleLabF = CGRectMake(titleX, titleY, nameW, titleH);
    }
    
    //内容
    CGFloat topicContentW = cellW - nameX - CELLPADDING;
    CGFloat topicContentX = nameX;
    CGFloat topicTextViewY = CGRectGetMaxY(self.userViewF) + TopicCellBorderW;
    
    if(_topic.content && ![_topic.content isEqualToString:String_DefValue_Empty]) {
        //内容 文本+表情
        CGSize size = [MLEmojiLabel boundingRectWithSize:_topic.content w:topicContentW font:APPUILABELFONTNO14];
        
        self.topicTextViewF = CGRectMake(topicContentX, topicTextViewY, topicContentW, size.height + 5);
        /* cell的高度 */
        self.cellHeight = CGRectGetMaxY(self.topicTextViewF);
    }
    
    
    if(_topic.imgs && ![_topic.imgs isEqualToString:String_DefValue_Empty]) {
        //内容 图片
        CGFloat topicImgsViewY = self.cellHeight + TopicCellBorderW;
        CGFloat topicImgsViewH = Number_Zero;
        NSArray * imgArray = [_topic.imgs componentsSeparatedByString:String_DefValue_SpliteStr];
        
        //图片=1 根据图片实际大小决定高度
        //图片>3 换行
        CGFloat imgCellH = (topicContentW - Number_Ten) / Number_Three;
        topicImgsViewH = imgCellH;
        
        if([imgArray count] > Number_Three) {
            //大于三张图片需要换行
            NSInteger page = ([imgArray count] + Number_Three - Number_One) / Number_Three;
            
            topicImgsViewH = page * imgCellH;
        }
//        else if ([imgArray count] == Number_One) {
//            topicImgsViewH = topicContentW;
//        }
        
        self.topicImgsViewF = CGRectMake(topicContentX, topicImgsViewY, topicContentW, topicImgsViewH);
        
        self.cellHeight = CGRectGetMaxY(self.topicImgsViewF);
    }
    
    //帖子互动
    [self setTopicInterActionRect];
    
    self.levelabF = CGRectMake(0, self.cellHeight + TopicCellBorderW, cellW, 0.5);
    
    self.cellHeight = CGRectGetMaxY(self.levelabF) + TopicCellBorderW;
}

//点赞回复的rect
- (void)setTopicInterActionRect {
    TopicInteractionDomain * domain = [TopicInteractionDomain new];
    domain.dianzan = _topic.dianzan;
    domain.replyPage = _topic.replyPage;
    domain.topicType = Topic_Interact;
    domain.topicUUID = _topic.uuid;
    domain.borwseType = BrowseType_Time;
    domain.createTime = _topic.create_time;
    
    self.topicInteractionFrame = [TopicInteractionFrame new];
    self.topicInteractionFrame.topicInteractionDomain  = domain;
    
    self.topicInteractionViewF = CGRectMake(Number_Zero, self.cellHeight + TopicCellBorderW, KGSCREEN.size.width, self.topicInteractionFrame.topicInteractHeight);
    
    self.cellHeight = CGRectGetMaxY(self.topicInteractionViewF);
}


@end
