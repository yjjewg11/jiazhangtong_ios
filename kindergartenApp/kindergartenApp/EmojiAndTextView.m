//
//  EmojiAndTextView.m
//  kindergartenApp
//
//  Created by CxDtreeg on 15/8/17.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "EmojiAndTextView.h"
#import "UIButton+Extension.h"
#import "KGNSStringUtil.h"

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
        [sender setImage:@"jianpan" selImg:@"jianpan"];
        
    } else {
        _contentTextView.inputView = nil;
        [sender setImage:@"biaoqing1" selImg:@"biaoqing1"];
    }
    
    [_contentTextView becomeFirstResponder];
}

- (IBAction)postBtnPressed:(UIButton *)sender {
    NSString * replyText = [KGNSStringUtil trimString:_contentTextView.text];
    if(replyText && ![replyText isEqualToString:String_DefValue_Empty]) {
        NSDictionary *dic = @{Key_TopicTypeReplyText : replyText};
        [[NSNotificationCenter defaultCenter] postNotificationName:Key_Notification_TopicReply object:self userInfo:dic];
    }
}

@end
