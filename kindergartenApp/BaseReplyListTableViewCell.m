//
//  BaseReplyListTableViewCell.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/3.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "BaseReplyListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
#import "UIColor+Extension.h"
#import "KGDateUtil.h"
#import "KGNSStringUtil.h"
#import "KGHttpService.h"
#import "UIButton+Extension.h"
#import "KGHUD.h"



@implementation BaseReplyListTableViewCell


- (IBAction)deleteBtnClick:(id)sender {
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"删除" message:@"确定要删除吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark 窗口的代理方法，用户保存数据
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    //当点击了第二个按钮（OK）
    NSLog(@"%ld",buttonIndex);
    //基本信息修改
    if(buttonIndex ==1 )
    {
        
        [self.delegate baseReply_delete:baseReplyDomain.uuid];
    }
    
}
- (void)awakeFromNib {
    // Initialization code
    messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
    messageLabel.customEmojiRegex = String_DefValue_EmojiRegex;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  重置cell内容
 *
 *  @param baseDomain   cell需要的数据对象
 *  @param parameterDic 扩展字典
 */
- (void)resetValue:(id)baseDomain parame:(NSMutableDictionary *)parameterDic {
    baseReplyDomain = (BaseReplyDomain *)baseDomain;
    
    titleLabel.text = baseReplyDomain.create_user;
    messageLabel.text = baseReplyDomain.content;

    CGSize size=[MLEmojiLabel boundingRectWithSize:baseReplyDomain.content w:messageLabel.frame.size.width font: 13];
    [messageLabel setSize:size];
//
    NSDate * date = [KGDateUtil getDateByDateStr:baseReplyDomain.create_time format:dateFormatStr2];
    timeLabel.text = [KGNSStringUtil compareCurrentTime:date];
    
    [headImageView sd_setImageWithURL:[NSURL URLWithString:baseReplyDomain.create_img] placeholderImage:[UIImage imageNamed:@"head_def"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [headImageView setBorderWithWidth:Number_Zero color:KGColorFrom16(0xE7E7EE) radian:headImageView.width / Number_Two];
    }];
    CGSize cellSize=CGSizeMake(self.frame.size.width,  CGRectGetMaxY(messageLabel.frame)+2);
//    baseReplyDomain.frame=CGRectMake(cellframe.origin.x, CGRectGetMaxY(messageLabel.frame), cellframe.size.width, CGRectGetMaxY(messageLabel.frame)+2);
    [self setSize:cellSize];
    //[self setFrame:cellframe];
    
}

@end
