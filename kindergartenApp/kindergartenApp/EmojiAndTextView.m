//
//  EmojiAndTextView.m
//  kindergartenApp
//
//  Created by CxDtreeg on 15/8/17.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "EmojiAndTextView.h"
#import "UIButton+Extension.h"

@implementation EmojiAndTextView

- (IBAction)emojiBtnPressed:(UIButton *)sender {
//    if (_pressedBlock) {
//        _pressedBlock(sender);
//    }
    [KGEmojiManage sharedManage].isChatEmoji = YES;
    sender.selected = !sender.selected;
    
    [KGEmojiManage sharedManage].isSwitchEmoji = YES;
    [_contentTextView resignFirstResponder];
    
    if (!_faceBoard) {
        _faceBoard = [[FaceBoard alloc] init];
        _faceBoard.inputTextView = _contentTextView;
    }
    
    if(sender.selected) {
        _contentTextView.inputView = _faceBoard;
        [sender setImage:@"chat_ipunt_message" selImg:@"chat_ipunt_message"];
        
    } else {
        _contentTextView.inputView = nil;
        [sender setImage:@"biaoqing1" selImg:@"biaoqing1"];
    }
    
    [_contentTextView becomeFirstResponder];
}

- (IBAction)postBtnPressed:(UIButton *)sender {
    
}

@end
