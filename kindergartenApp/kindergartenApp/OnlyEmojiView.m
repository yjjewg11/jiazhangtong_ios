//
//  OnlyEmojiView.m
//  kindergartenApp
//
//  Created by CxDtreeg on 15/8/16.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "OnlyEmojiView.h"
#import "UIButton+Extension.h"

@implementation OnlyEmojiView


- (IBAction)emojiBtnPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(sender.selected) {
        [sender setImage:@"chat_ipunt_message" selImg:@"chat_ipunt_message"];
        
    } else {
        [sender setImage:@"biaoqing1" selImg:@"biaoqing1"];
    }
    if (_pressedBlock) {
        _pressedBlock(sender);
    }
}

@end
