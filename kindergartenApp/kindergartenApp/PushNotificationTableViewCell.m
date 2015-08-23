//
//  PushNotificationTableViewCell.m
//  kindergartenApp
//
//  Created by CxDtreeg on 15/8/13.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "PushNotificationTableViewCell.h"

#define NewMessageKey @"newMessage"
#define VoiceKey @"voice"
#define ShakeKey @"shake"

@implementation PushNotificationTableViewCell

- (void)awakeFromNib {
    [_mySwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    _dic = @{@"新消息":NewMessageKey,@"声音":VoiceKey,@"震动":ShakeKey};
}

#pragma mark - 开关点击
- (void)switchChange:(UISwitch *)sender{
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:[_dic objectForKey:_flagTitleLabel.text]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
