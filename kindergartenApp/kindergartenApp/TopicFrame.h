//
//  TopicFrame.h
//  MYAPP
//
//  Created by Moyun on 15/7/1.
//  Copyright (c) 2015年 Moyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TopicDomain.h"

@interface TopicFrame : NSObject

@property (nonatomic,strong) TopicDomain * topic;

/** 用户信息 */
@property (nonatomic,assign) CGRect userViewF;
/** 用户信息 */
@property (nonatomic,assign) CGRect headImageViewF;
///** 用户名称 */
@property (nonatomic,assign) CGRect nameLabF;
/** 标题 */
@property (nonatomic,assign) CGRect titleLabF;

/** 内容 */
@property (nonatomic,assign) CGRect topicContentViewF;

/** 内容 文本表情 */
@property (nonatomic,assign) CGRect topicTextViewF;

/** 内容 图片 */
@property (nonatomic,assign) CGRect topicImgsViewF;

/** 帖子互动视图 */
@property (nonatomic,assign) CGRect topicInteractionViewF;

/** 分割线 */
@property (nonatomic,assign) CGRect levelabF;


/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;


@end
