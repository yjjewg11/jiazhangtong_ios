//
//  TopicInteractionFrame.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/16.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "TopicInteractionFrame.h"
#import "ReplyDomain.h"
#import "ReplyPageDomain.h"
#import "KGRange.h"
#import "MLEmojiLabel.h"

#define CELLWIDTH KGSCREEN.size.width

@implementation TopicInteractionFrame

- (void)setTopicInteractionDomain:(TopicInteractionDomain *)topicInteractionDomain {
    _topicInteractionDomain = topicInteractionDomain;
    
    // cell的宽度
    CGFloat cellW = CELLWIDTH;
    
    _funViewF = CGRectMake(CELLPADDING, Number_Zero, CELLCONTENTWIDTH, CELLPADDING);
    
    /* cell的高度 */
    self.topicInteractHeight = CGRectGetMaxY(_funViewF);
    
    if(_topicInteractionDomain.borwseType == Number_One) {
        _dateLabelF = CGRectMake(Number_Zero, Number_Three, 100, Number_Ten);
    } else if(_topicInteractionDomain.borwseType == Number_Two) {
        _browseCountImageViewF = CGRectMake(Number_Zero, Number_Three, 12, Number_Ten);
        _browseCountLabelF = CGRectMake(20, Number_Three, 100, Number_Ten);
    }
    
    
    //回复按钮
    CGSize funBtnSize = CGSizeMake(31, 16);
    CGFloat replyBtnX = cellW - funBtnSize.width - CELLPADDING - CELLPADDING;
    CGFloat replyBtnY = 0;
    
    //点赞按钮
    CGFloat dzBtnX = replyBtnX - 15 - funBtnSize.width;
    
    _dianzanBtnF = CGRectMake(replyBtnX, replyBtnY, funBtnSize.width, funBtnSize.height);
    _replyBtnF   = CGRectMake(dzBtnX, replyBtnY, funBtnSize.width, funBtnSize.height);
    
    /* 点赞列表 */
    _dianzanViewF = CGRectMake(Number_Zero, self.topicInteractHeight + TopicCellBorderW, CELLCONTENTWIDTH, TopicCellBorderW);
    _dianzanIconImgF = CGRectMake(CELLPADDING, Number_Zero, Number_Ten, Number_Ten);
    
    //点赞列表
    CGFloat dzLabelX = CGRectGetMaxX(_dianzanIconImgF) + Number_Ten;
    CGFloat dzLabelW = cellW - dzLabelX - CELLPADDING;
    
    _dianzanLabelF = CGRectMake(dzLabelX, Number_Zero, dzLabelW, Number_Ten);
    
    /* cell的高度 */
    self.topicInteractHeight = CGRectGetMaxY(_dianzanViewF);

    [self addReplyViewFrame];
    
    /* 回复输入框 */
    _replyTextFieldF = CGRectMake(CELLPADDING, self.topicInteractHeight + Number_Ten, CELLCONTENTWIDTH, 30);
    
    /* cell的高度 */
    self.topicInteractHeight = CGRectGetMaxY(_replyTextFieldF);
}


- (void)addReplyViewFrame {
    ReplyPageDomain * replyPage = _topicInteractionDomain.replyPage;
    if(replyPage.data && [replyPage.data count]>Number_Zero) {
        
        NSMutableString  * replyStr = [[NSMutableString alloc] init];
//        NSMutableArray   * attributedStrArray = [[NSMutableArray alloc] init];
        NSInteger count = Number_Zero;
        for(ReplyDomain * reply in replyPage.data) {
            if(count < Number_Five) {
                [replyStr appendFormat:@"%@:%@ \n", reply.create_user, reply.content ? reply.content : @""];
                
//                NSRange  range = [replyStr rangeOfString:reply.create_user];
//                KGRange * tempRange = [KGRange new];
//                tempRange.location = range.location;
//                tempRange.length   = range.length;
//                
//                [attributedStrArray addObject:tempRange];
            }
            count++;
        }
        
        CGSize size = [MLEmojiLabel boundingRectWithSize:replyStr w:CELLWIDTH font:APPUILABELFONTNO14];
        
        _replyViewF = CGRectMake(CELLPADDING, CGRectGetMaxY(_dianzanViewF) + TopicCellBorderW
                                      , CELLCONTENTWIDTH, size.height);
        
        /* cell的高度 */
        self.topicInteractHeight = CGRectGetMaxY(_replyViewF);
        
        [self loadMoreBtnFrame];
    }
}

//加载显示更多
- (void)loadMoreBtnFrame {
    ReplyPageDomain * replyPage = _topicInteractionDomain.replyPage;
    
    if(replyPage.totalCount > replyPage.pageSize) {
        CGFloat w = 50;
        CGFloat x = CELLWIDTH - w  - CELLPADDING;
        _moreBtnF = CGRectMake(x, CGRectGetMaxY(self.replyViewF), w, 20);
        
        /* cell的高度 */
        self.topicInteractHeight = CGRectGetMaxY(_moreBtnF);
    }
}

@end
