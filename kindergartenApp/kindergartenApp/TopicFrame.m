//
//  TopicFrame.m
//  MYAPP
//
//  Created by Moyun on 15/7/1.
//  Copyright (c) 2015年 Moyun. All rights reserved.
//

#import "TopicFrame.h"
#import "TopicDomain.h"

@implementation TopicFrame


-(void)setTopic:(TopicDomain *)topic{
    
    _topic = topic;
    
    // cell的宽度
    CGFloat cellW = KGSCREEN.size.width;
    //内容 x Y 提前定义，坐标变化
    CGFloat contentX = 27;
    CGFloat contentY = 0;
    
    //用户信息整体
    CGFloat uviewW = cellW;
    CGFloat uviewH = 66;
    CGFloat ux = 0;
    CGFloat uy = 0;
    self.userViewF = CGRectMake(ux, uy, uviewW, uviewH);
    //第一次设置contentY
    contentY = CGRectGetMaxY(self.userViewF) + MYTopicCellBorderW;
    
    //头像
    CGFloat headWH = 45;
    CGFloat headX  = CELLPADDING;
    CGFloat headY  = 15;
    self.headImageViewF = CGRectMake(headX, headY, headWH, headWH);
    
    //名称
    CGFloat nameX = CGRectGetMaxX(self.headImageViewF) + MYTopicCellBorderW;
    CGFloat nameY = 20;
    CGSize nameSize =[topic.create_user sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MYTopicCellNameFont,NSFontAttributeName, nil]];
    self.nameLabF = (CGRect){{nameX, nameY}, nameSize};
    
    
    //title
    if (self.topic.title && ![self.topic.title isEqualToString:@""]) {
        CGFloat titleX = nameX;
        CGFloat titleY = CGRectGetMaxY(self.nameLabF) + 8;
        CGSize titleSize =[topic.title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MYTopicCellNameFont,NSFontAttributeName, nil]];
        self.titleLabF = (CGRect){{titleX, titleY}, titleSize};
        
        /* cell的高度 */
        self.cellHeight = CGRectGetMaxY(self.titleLabF);
        //如果有title得情况 设置content Y
        contentY = CGRectGetMaxY(self.titleLabF) + 15;
    }
    
    //内容HTML
    CGFloat contentWebWH = cellW - nameX - CELLPADDING;
    self.contentWebViewF = CGRectMake(nameX, contentY, contentWebWH, contentWebWH);
    
    /* cell的高度 */
    self.cellHeight = CGRectGetMaxY(self.contentWebViewF);
    
    //功能视图
    CGFloat funViewY = CGRectGetMaxY(self.contentWebViewF) + MYTopicCellBorderW;
    CGFloat funViewH = CELLPADDING;
    self.funViewF = CGRectMake(CELLPADDING, funViewY, CELLCONTENTWIDTH, funViewH);
    
    /* cell的高度 */
    self.cellHeight = CGRectGetMaxY(self.funViewF);
    
    //时间
    CGSize dateSize =CGSizeMake(100, 10);
    CGFloat dateX = 0;
    CGFloat dateY = 3;
    self.dateLabelF = (CGRect){{dateX, dateY}, dateSize};
   
    //回复按钮
    CGSize funBtnSize = CGSizeMake(31, 16);
    CGFloat replyBtnX = cellW - funBtnSize.width - CELLPADDING - CELLPADDING;
    CGFloat replyBtnY = 0;
    self.replyBtnF = (CGRect){{replyBtnX, replyBtnY}, funBtnSize};
    
    //点赞按钮
    CGFloat dzBtnX = replyBtnX - 15 - funBtnSize.width;
    self.dianzanBtnF = (CGRect){{dzBtnX, replyBtnY}, funBtnSize};

    //点赞列表
    self.dianzanViewF = CGRectMake(0, self.cellHeight + MYTopicCellBorderW, CELLCONTENTWIDTH, MYTopicCellBorderW);
    
    /* cell的高度 */
//    self.cellHeight = CGRectGetMaxY(self.dianzanViewF);
    
    //点赞ICON
    self.dianzanIconImgF = CGRectMake(CELLPADDING, Number_Zero, Number_Ten, Number_Ten);
    
    //点赞列表
    CGFloat dzLabelX = CGRectGetMaxX(self.dianzanIconImgF) + Number_Ten;
    CGFloat dzLabelW = cellW - dzLabelX - CELLPADDING;
    
    self.dianzanLabelF = CGRectMake(dzLabelX, Number_Zero, dzLabelW, Number_Ten);
    
    
    //回复视图
    
    //回复输入框
    self.replyTextFieldF = CGRectMake(CELLPADDING, self.cellHeight + MYTopicCellBorderW, CELLCONTENTWIDTH, 30);
    
    self.cellHeight = CGRectGetMaxY(self.replyTextFieldF);
    
    self.levelabF = CGRectMake(0, self.cellHeight + MYTopicCellBorderW, cellW, 0.5);
    
    self.cellHeight = CGRectGetMaxY(self.levelabF) + MYTopicCellBorderW;
}


@end
