//
//  TopicTableViewCell.h
//  MYAPP
//  互动Cell
//  Created by Moyun on 15/7/1.
//  Copyright (c) 2015年 Moyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBVLinkedTextView.h"
#import "KGTextField.h"
#import "TopicInteractionView.h"
#import "MLEmojiLabel.h"

@class TopicFrame;

@interface TopicTableViewCell : UITableViewCell {
    NSMutableArray * imagesMArray;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong) TopicFrame * topicFrame;


/** 用户信息 */
@property (nonatomic,weak) UIView * userView;
/** 用户头像 */
@property (nonatomic,weak) UIImageView * headImageView;
///** 用户名称 */
@property (nonatomic,weak) UILabel * nameLab;
/** 标题 */
@property (nonatomic,weak) UILabel * titleLab;

/** 内容 文本表情 */
@property (nonatomic, weak) MLEmojiLabel  * topicTextView;

/** 内容 图片 */
@property (nonatomic, weak) UIView  * topicImgsView;

/** 帖子互动视图 */
@property (nonatomic, weak) TopicInteractionView  * topicInteractionView;

/** 分割线 */
@property (nonatomic,weak) UILabel * levelab;

@end
