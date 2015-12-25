//
//  UUInputFunctionView.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUInputFunctionView.h"
//#import "Mp3Recorder.h"
#import "UUProgressHUD.h"
#import "ACMacros.h"
#import "KGEmojiManage.h"

@interface UUInputFunctionView ()<UITextViewDelegate>
{
    BOOL isbeginVoiceRecord;
//    Mp3Recorder *MP3;
    NSInteger playTime;
    NSTimer *playTimer;
}
@end

@implementation UUInputFunctionView

- (id)initWithSuperVC:(UIViewController *)superVC isShow:(BOOL)isShow
{
    self.superVC = superVC;
    CGFloat y = isShow ? Main_Screen_Height-40-64 : Main_Screen_Height;
    CGRect frame = CGRectMake(0, y, Main_Screen_Width, 40);
    
    self = [super initWithFrame:frame];
    if (self) {
//        MP3 = [[Mp3Recorder alloc]initWithDelegate:self];
        self.backgroundColor = [UIColor whiteColor];
        //发送消息
        self.btnSendMessage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnSendMessage.frame = CGRectMake(Main_Screen_Width-40, 5, 30, 30);
        self.isAbleToSendTextMessage = NO;
//        [self.btnSendMessage setTitle:@"send" forState:UIControlStateNormal];
//        [self.btnSendMessage setBackgroundImage:[UIImage imageNamed:@"Chat_take_picture"] forState:UIControlStateNormal];
//        [self.btnSendMessage setBackgroundImage:[UIImage imageNamed:@"fasong"] forState:UIControlStateNormal];
        [self.btnSendMessage setImage:[UIImage imageNamed:@"fasong"] forState:UIControlStateNormal];
        self.btnSendMessage.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.btnSendMessage addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnSendMessage];
        
        //改变状态（语音、文字）
        self.btnChangeVoiceState = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnChangeVoiceState.frame = CGRectMake(5, 5, 30, 30);
        isbeginVoiceRecord = NO;
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"biaoqing"] forState:UIControlStateNormal];//chat_voice_record
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"jianpan"] forState:UIControlStateSelected];//chat_ipunt_message
        self.btnChangeVoiceState.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.btnChangeVoiceState addTarget:self action:@selector(textEmojiRecord:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnChangeVoiceState];

        //语音录入键
//        self.btnVoiceRecord = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.btnVoiceRecord.frame = CGRectMake(70, 5, Main_Screen_Width-70*2, 30);
//        self.btnVoiceRecord.hidden = YES;
//        [self.btnVoiceRecord setBackgroundImage:[UIImage imageNamed:@"chat_message_back"] forState:UIControlStateNormal];
//        [self.btnVoiceRecord setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        [self.btnVoiceRecord setTitleColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
//        [self.btnVoiceRecord setTitle:@"Hold to Talk" forState:UIControlStateNormal];
//        [self.btnVoiceRecord setTitle:@"Release to Send" forState:UIControlStateHighlighted];
//        [self.btnVoiceRecord addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
//        [self.btnVoiceRecord addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
//        [self.btnVoiceRecord addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
//        [self.btnVoiceRecord addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
//        [self.btnVoiceRecord addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
//        [self addSubview:self.btnVoiceRecord];
        
        //输入框
        self.TextViewInput = [[KGTextView alloc]initWithFrame:CGRectMake(45, 5, Main_Screen_Width-2*45, 30)];
        self.TextViewInput.textColor = [UIColor blackColor];
        self.TextViewInput.placeholder = @"说点什么吧";
        self.TextViewInput.layer.cornerRadius = 4;
        self.TextViewInput.layer.masksToBounds = YES;
        self.TextViewInput.delegate = self;
        self.TextViewInput.layer.borderWidth = 1;
        self.TextViewInput.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        [self addSubview:self.TextViewInput];
        
        //分割线
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
        
        //添加通知
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidEndEditing:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

#pragma mark - 录音touch事件
- (void)beginRecordVoice:(UIButton *)button
{
//    [MP3 startRecord];
    playTime = 0;
    playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
    [UUProgressHUD show];
}

- (void)endRecordVoice:(UIButton *)button
{
    if (playTimer) {
//        [MP3 stopRecord];
        [playTimer invalidate];
        playTimer = nil;
    }
}

- (void)cancelRecordVoice:(UIButton *)button
{
    if (playTimer) {
//        [MP3 cancelRecord];
        [playTimer invalidate];
        playTimer = nil;
    }
    [UUProgressHUD dismissWithError:@"Cancel"];
}

- (void)RemindDragExit:(UIButton *)button
{
    [UUProgressHUD changeSubTitle:@"Release to cancel"];
}

- (void)RemindDragEnter:(UIButton *)button
{
    [UUProgressHUD changeSubTitle:@"Slide up to cancel"];
}


- (void)countVoiceTime
{
    playTime ++;
    if (playTime>=60) {
        [self endRecordVoice:nil];
    }
}

#pragma mark - Mp3RecorderDelegate

//回调录音资料
- (void)endConvertWithData:(NSData *)voiceData
{
    [self.delegate UUInputFunctionView:self sendVoice:voiceData time:playTime+1];
    [UUProgressHUD dismissWithSuccess:@"Success"];
   
    //缓冲消失时间 (最好有block回调消失完成)
//    self.btnVoiceRecord.enabled = NO;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.btnVoiceRecord.enabled = YES;
//    });
}

- (void)failRecord
{
    [UUProgressHUD dismissWithSuccess:@"Too short"];
    
    //缓冲消失时间 (最好有block回调消失完成)
//    self.btnVoiceRecord.enabled = NO;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.btnVoiceRecord.enabled = YES;
//    });
}

//改变文本和表情输入状态
- (void)textEmojiRecord:(UIButton *)sender
{
//    self.btnVoiceRecord.hidden = !self.btnVoiceRecord.hidden;
//    self.TextViewInput.hidden  = !self.TextViewInput.hidden;
//    isbeginVoiceRecord = !isbeginVoiceRecord;
//    if (isbeginVoiceRecord) {
//        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"chat_ipunt_message"] forState:UIControlStateNormal];
//        [self.TextViewInput resignFirstResponder];
//    }else{
//        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"chat_voice_record"] forState:UIControlStateNormal];
//        [self.TextViewInput becomeFirstResponder];
//    }
    [KGEmojiManage sharedManage].isChatEmoji = YES;
    sender.selected = !sender.selected;
    
    [KGEmojiManage sharedManage].isSwitchEmoji = YES;
    [self.TextViewInput resignFirstResponder];
    
    if (!_faceBoard) {
        _faceBoard = [[FaceBoard alloc] init];
        _faceBoard.inputTextView = self.TextViewInput;
        
        __weak UUInputFunctionView * __self = self;
        _faceBoard.FaceBoardInputedBlock = ^(NSString * emojiStr){
            [__self changeSendBtnWithPhoto:emojiStr.length>0?NO:YES];
        };
    }
    
    if(sender.selected) {
        self.TextViewInput.inputView = _faceBoard;
    } else {
        self.TextViewInput.inputView = nil;
    }
    
    [self.TextViewInput becomeFirstResponder];
}

//发送消息（文字图片）
- (void)sendMessage:(UIButton *)sender
{
//    if (self.isAbleToSendTextMessage) {
        NSString *resultStr = [self.TextViewInput.text stringByReplacingOccurrencesOfString:@"   " withString:@""];
        [self.delegate UUInputFunctionView:self sendMessage:resultStr];
        [self.TextViewInput resignFirstResponder];
//    }
//    else{
//        [self.TextViewInput resignFirstResponder];
//        UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Images",nil];
//        [actionSheet showInView:self.window];
//    }
}

#pragma mark - 获取字符串中所有指定字符出现的range
- (NSMutableArray *)getSubStringShowNumsInStringBy:(NSString*)string andSubstring:(NSString*)Substring
{
    int count =0;
    NSMutableArray * array = [[NSMutableArray alloc] init];
    NSRange range = [string rangeOfString:Substring];
    if(range.length>0)
    {
        count++;
        [array addObject:[NSValue valueWithRange:range]];
        while (range.length>0) {
            NSInteger startIndex = range.location+range.length;
            NSInteger endIndex = string.length -startIndex;
            string= [string substringWithRange:NSMakeRange(startIndex, endIndex)];
            range = [string rangeOfString:Substring];
            if(range.length>0) 
            { 
                [array addObject:[NSValue valueWithRange:range]];
            } 
        } 
    } 
    return array;
}

#pragma mark - TextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString * inputString = textView.text;
    NSString * tempStr = [inputString substringFromIndex:range.location];
    if ([@"]" isEqualToString:tempStr]) {
        NSString * ss = [[KGEmojiManage sharedManage] keyboardBack:textView.text];
        textView.text = [NSString stringWithFormat:@"%@]", ss];
    }
    
//    if (text.length == 0) {
//        NSDictionary * dic = [KGEmojiManage sharedManage].emojiMDict;
//        
//        NSMutableArray * array = [[NSMutableArray alloc] init];
//        NSMutableArray * tempArray;
//        for (NSString *key in dic.allKeys) {
//            tempArray = [self getSubStringShowNumsInStringBy:textView.text andSubstring:key];
//            if (tempArray.count != 0) {
//                [array addObjectsFromArray:tempArray];
//            }
//        }
//        
//        for (NSValue * value in array) {
//            NSRange tempRange = [value rangeValue];
//            if (range.location >= tempRange.location && range.location <= tempRange.location + tempRange.length) {
//                textView.text = [textView.text stringByReplacingCharactersInRange:tempRange withString:@""];
//                return NO;
//            }
//        }
//    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{

}

- (void)textViewDidChange:(UITextView *)textView
{
    [self changeSendBtnWithPhoto:textView.text.length>0?NO:YES];
}

- (void)changeSendBtnWithPhoto:(BOOL)isPhoto
{
    self.isAbleToSendTextMessage = YES;
//    self.isAbleToSendTextMessage = !isPhoto;
//    [self.btnSendMessage setTitle:isPhoto?@"":@"send" forState:UIControlStateNormal];
//    self.btnSendMessage.frame = RECT_CHANGE_width(self.btnSendMessage, isPhoto?30:35);
//    UIImage *image = [UIImage imageNamed:isPhoto?@"Chat_take_picture":@"chat_send_message"];
//    [self.btnSendMessage setBackgroundImage:image forState:UIControlStateNormal];
}

//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    NSLog(@"te");
//}


#pragma mark - Add Picture
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self addCarema];
    }else if (buttonIndex == 1){
        [self openPicLibrary];
    }
}

-(void)addCarema{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.superVC presentViewController:picker animated:YES completion:^{}];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Your device don't have camera" delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)openPicLibrary{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.superVC presentViewController:picker animated:YES completion:^{
        }];
    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.superVC dismissViewControllerAnimated:YES completion:^{
        [self.delegate UUInputFunctionView:self sendPicture:editImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.superVC dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//重置文本和表情输入状态
- (void)resetTextEmojiInput {
    self.btnChangeVoiceState.selected = YES;
    [self textEmojiRecord:self.btnChangeVoiceState];
}

@end
