//
//  UUMessageCell.h
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUMessageContentButton.h"
#import "MLEmojiLabel.h"

@class UUMessageFrame;
@class UUMessageCell;

@protocol UUMessageCellDelegate <NSObject>
@optional
- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSString *)userId;
- (void)cellContentDidClick:(UUMessageCell *)cell image:(UIImage *)contentImage;
@end


@interface UUMessageCell : UITableViewCell

@property (nonatomic, retain)UILabel *labelTime;
//@property (nonatomic, retain)UILabel *labelNum;
@property (nonatomic, retain)UIButton *btnHeadImage;

@property (nonatomic, retain)UUMessageContentButton *btnContent;
@property (nonatomic, strong) MLEmojiLabel * contentTextView;
@property (nonatomic, strong) UIButton     * contentTransparentBtn;
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicatorView;
@property (nonatomic, strong) UIImageView * sendErrorImageView;
@property (nonatomic, retain)UUMessageFrame *messageFrame;
@property (nonatomic, assign) BOOL isSendError;
@property (nonatomic, assign)id<UUMessageCellDelegate>delegate;

@end

