//
//  StudentNoteInfoViewController.m
//  kindergartenApp
//
//  Created by You on 15/7/24.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "StudentNoteInfoViewController.h"
#import "UIView+Extension.h"
#import "KGNSStringUtil.h"
#import "KGHttpService.h"
#import "KGHUD.h"
#import "KGTextView.h"

@interface StudentNoteInfoViewController () <UITextViewDelegate> {
    IBOutlet KGTextView * noteTextView;
}

@end

@implementation StudentNoteInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详细信息";
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveStudentBaseInfo)];
    [rightBarItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [noteTextView setBorderWithWidth:Number_One color:[UIColor grayColor] radian:5.0];
    noteTextView.text = _studentInfo.note;
    noteTextView.placeholder = @"说点什么吧...";
    noteTextView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



//保存按钮点击
- (void)saveStudentBaseInfo {
    if([self validateInputInView]) {
        
        _studentInfo.note = [KGNSStringUtil trimString:noteTextView.text];
        
        //提交数据
        [[KGHttpService sharedService] saveStudentInfo:_studentInfo success:^(NSString *msgStr) {
            
            [[KGHUD sharedHud] show:self.contentView onlyMsg:msgStr];
            
            if(_StudentUpdateBlock) {
                _StudentUpdateBlock(_studentInfo);
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        } faild:^(NSString *errorMsg) {
            [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
        }];
    }
}

//验证输入框
- (BOOL)validateInputInView {
    BOOL judge = YES;
    NSString * noteStr = [KGNSStringUtil trimString:noteTextView.text];
    if(noteStr.length == Number_Zero) {
        judge = NO;
        NSDictionary * dic = [NSDictionary dictionaryWithObject:@"备注不能为空" forKey:Key_Notification_MessageText];
        [[NSNotificationCenter defaultCenter]postNotificationName:Key_Notification_Message object:self userInfo:dic];
    }
    
    return judge;
}

#pragma UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
#define MY_MAX 300
    if ((textView.text.length - range.length + text.length) > MY_MAX)
    {
        NSString *substring = [text substringToIndex:MY_MAX - (textView.text.length - range.length)];
        NSMutableString *lastString = [textView.text mutableCopy];
        [lastString replaceCharactersInRange:range withString:substring];
        textView.text = [lastString copy];
        return NO;
    }
    else
    {
        return YES;
    }
}

@end
