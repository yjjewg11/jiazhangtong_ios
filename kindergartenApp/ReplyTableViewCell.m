//
//  ReplyTableViewCell.m
//  kindergartenApp
//
//  Created by You on 15/8/6.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "ReplyTableViewCell.h"
#import "ReplyDomain.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
#import "UIColor+Extension.h"
#import "KGDateUtil.h"
#import "KGNSStringUtil.h"
#import "KGHttpService.h"
#import "UIButton+Extension.h"
#import "KGHUD.h"

@implementation ReplyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
    messageLabel.customEmojiRegex = String_DefValue_EmojiRegex;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

/**
 *  重置cell内容
 *
 *  @param baseDomain   cell需要的数据对象
 *  @param parameterDic 扩展字典
 */
- (void)resetValue:(id)baseDomain parame:(NSMutableDictionary *)parameterDic {
    replyDomain = (ReplyDomain *)baseDomain;
    
    titleLabel.text = replyDomain.title;
    messageLabel.text = replyDomain.content;
    if(replyDomain.dianzan) {
        dzBtn.selected = !replyDomain.dianzan.canDianzan;
        dzCountLabel.text = [NSString stringWithFormat:@"%ld", (long)replyDomain.dianzan.count];
    }
    
    NSDate * date = [KGDateUtil getDateByDateStr:replyDomain.create_time format:dateFormatStr2];
    timeLabel.text = [KGNSStringUtil compareCurrentTime:date];
    
    [headImageView sd_setImageWithURL:[NSURL URLWithString:replyDomain.create_img] placeholderImage:[UIImage imageNamed:@"head_def"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [headImageView setBorderWithWidth:Number_Zero color:KGColorFrom16(0xE7E7EE) radian:headImageView.width / Number_Two];
    }];
}

- (IBAction)dzBtnClicked:(UIButton *)sender {
    
    if(sender.selected) {
        [[KGHttpService sharedService] delDZ:replyDomain.uuid success:^(NSString *msgStr) {
            sender.selected = NO;
            if(replyDomain.dianzan.count > Number_Zero); {
                replyDomain.dianzan.count--;
            }
            dzCountLabel.text = [NSString stringWithFormat:@"%ld", (long)replyDomain.dianzan.count];
            [self messageNotification:msgStr];
        } faild:^(NSString *errorMsg) {
            [self messageNotification:errorMsg];
        }];
    } else {
        [[KGHttpService sharedService] saveDZ:replyDomain.uuid type:replyDomain.type success:^(NSString *msgStr) {
            sender.selected = YES;
            replyDomain.dianzan.count++;
            dzCountLabel.text = [NSString stringWithFormat:@"%ld", (long)replyDomain.dianzan.count];
            [self messageNotification:msgStr];
        } faild:^(NSString *errorMsg) {
            [self messageNotification:errorMsg];
        }];
    }
}

- (void)messageNotification:(NSString *)message {
    NSDictionary * dic = [NSDictionary dictionaryWithObject:message forKey:Key_Notification_MessageText];
    [[NSNotificationCenter defaultCenter]postNotificationName:Key_Notification_Message object:self userInfo:dic];
}

@end
