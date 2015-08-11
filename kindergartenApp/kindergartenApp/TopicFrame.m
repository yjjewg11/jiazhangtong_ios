//
//  TopicFrame.m
//  MYAPP
//
//  Created by Moyun on 15/7/1.
//  Copyright (c) 2015年 Moyun. All rights reserved.
//

#import "TopicFrame.h"
#import "TopicDomain.h"
#import "TQRichTextView.h"

@implementation TopicFrame


-(void)setTopic:(TopicDomain *)topic{
    
    _topic = topic;
    
    // cell的宽度
    CGFloat cellW = KGSCREEN.size.width;
    //内容 x Y 提前定义，坐标变化
//    CGFloat contentX = 27;
    CGFloat contentY = 0;
    
    //用户信息整体
    CGFloat uviewW = cellW;
    CGFloat uviewH = 66;
    CGFloat ux = 0;
    CGFloat uy = 0;
    self.userViewF = CGRectMake(ux, uy, uviewW, uviewH);
    //第一次设置contentY
    contentY = CGRectGetMaxY(self.userViewF) + TopicCellBorderW;
    
    //头像
    CGFloat headWH = 45;
    CGFloat headX  = CELLPADDING;
    CGFloat headY  = 15;
    self.headImageViewF = CGRectMake(headX, headY, headWH, headWH);
    
    //名称
    CGFloat nameX = CGRectGetMaxX(self.headImageViewF) + TopicCellBorderW;
    CGFloat nameY = 20;
    CGSize nameSize =[topic.create_user sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:TopicCellNameFont,NSFontAttributeName, nil]];
    self.nameLabF = (CGRect){{nameX, nameY}, nameSize};
    
    
    //title
    if (self.topic.title && ![self.topic.title isEqualToString:String_DefValue_Empty]) {
        CGFloat titleX = nameX;
        CGFloat titleY = CGRectGetMaxY(self.nameLabF) + 8;
        CGSize titleSize =[topic.title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:TopicCellNameFont,NSFontAttributeName, nil]];
        self.titleLabF = (CGRect){{titleX, titleY}, titleSize};
        
        /* cell的高度 */
        self.cellHeight = CGRectGetMaxY(self.titleLabF);
        //如果有title得情况 设置content Y
        contentY = CGRectGetMaxY(self.titleLabF) + 15;
    }
    
    //内容
    CGFloat topicContentW = cellW - nameX - CELLPADDING;
    CGFloat topicContentH = Number_Zero;
    CGFloat topicContentX = Number_Zero;
    
    if(_topic.content && ![_topic.content isEqualToString:String_DefValue_Empty]) {
        //内容 文本+表情
        CGFloat topicTextViewY = TopicCellBorderW;
        CGRect rect = [TQRichTextView boundingRectWithSize:CGSizeMake(topicContentW, 500) font:[UIFont systemFontOfSize:12] string:_topic.title lineSpace:1.0f];
        
        self.topicTextViewF = CGRectMake(topicContentX, topicTextViewY, topicContentW, rect.size.height);
        topicContentH = CGRectGetMaxY(self.topicTextViewF);
        
        contentY += CGRectGetMaxY(self.topicTextViewF);
    }
    
    
    if(_topic.imgs && ![_topic.imgs isEqualToString:String_DefValue_Empty]) {
        //内容 图片
        CGFloat topicImgsViewY = topicContentH + TopicCellBorderW;
        CGFloat topicImgsViewH = Number_Zero;
        NSArray * imgArray = [_topic.imgs componentsSeparatedByString:@","];
        
        //图片=1 根据图片实际大小决定高度
        //图片>3 换行
        if([imgArray count] > Number_One) {
            //大于三张图片需要换行
            NSInteger page = ([imgArray count] + Number_Three - Number_One) / Number_Three;
            CGFloat imgCellH = topicContentW / Number_Three;
            topicImgsViewH = page * imgCellH;
        } else {
            topicImgsViewH = topicContentW;
        }
        
        self.topicImgsViewF = CGRectMake(topicContentX, topicImgsViewY, topicContentW, topicImgsViewH);
        topicContentH += topicImgsViewH;
        
        contentY += CGRectGetMaxY(self.topicImgsViewF);
    }
    
    self.topicContentViewF = CGRectMake(nameX, CGRectGetMaxY(self.titleLabF), topicContentW, topicContentH);
    
    /* cell的高度 */
    self.cellHeight = CGRectGetMaxY(self.topicContentViewF);
    
    //帖子互动
    [self setTopicInterActionRect];
    
    self.levelabF = CGRectMake(0, self.cellHeight + TopicCellBorderW, cellW, 0.5);
    
    self.cellHeight = CGRectGetMaxY(self.levelabF) + TopicCellBorderW;
}

//计算点赞回复的rect
- (void)setTopicInterActionRect {
    // cell的宽度
    CGFloat cellW = KGSCREEN.size.width;
    CGFloat height = Number_Zero;
    
    //点赞回复功能H
    height += CELLPADDING;
    
    //点赞列表
    if(_topic.dianzan) {
        height += TopicCellBorderW + TopicCellBorderW;
    }
    
    if(_topic.replyPage && _topic.replyPage.data && [_topic.replyPage.data count]>Number_Zero) {
        NSMutableString * replyStr       = [[NSMutableString alloc] init];
        
        for(ReplyDomain * reply in _topic.replyPage.data) {
            [replyStr appendFormat:@"%@:%@ \n", reply.create_user, reply.content ? reply.title : @""];
        }
        
        CGSize size = [replyStr sizeWithFont:[UIFont systemFontOfSize:APPUILABELFONTNO12]
                           constrainedToSize:CGSizeMake(CELLCONTENTWIDTH, 2000)
                               lineBreakMode:NSLineBreakByWordWrapping];
        
        height += (size.height + TopicCellBorderW);
    }
    
    //回复输入框
    height += 30 + TopicCellBorderW;
    
    
    self.topicInteractionViewF = CGRectMake(Number_Zero, self.cellHeight + TopicCellBorderW, cellW, height);
    
    /* cell的高度 */
    self.cellHeight = CGRectGetMaxY(self.topicInteractionViewF);
}


@end
