//
//  EnrolStudentMySchoolCommentCell.m
//  kindergartenApp
//
//  Created by Mac on 15/12/4.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "EnrolStudentMySchoolCommentCell.h"
#import "UIColor+flat.h"
#import "KGHUD.h"
#import "KGHttpService.h"

@interface EnrolStudentMySchoolCommentCell() <UITextViewDelegate>
{
    BOOL commentEditable;
    
    NSInteger score; //评论分数
    
    NSInteger niming; //是否匿名
    
    NSString * content; //评价内容
}

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *nimingLbl;

@property (weak, nonatomic) IBOutlet UIView *starView;

@property (weak, nonatomic) IBOutlet UIButton *tijiaoBtn;

@property (weak, nonatomic) IBOutlet UIButton *nimingBtn;
@end

@implementation EnrolStudentMySchoolCommentCell

- (void)awakeFromNib
{
    self.nimingBtn.selected = YES;
    self.nimingLbl.textColor = [UIColor redColor];
    niming = 1;
    
    self.textView.delegate = self;
    
    [self setUpBtns];
}

- (IBAction)commitBtn:(id)sender
{
    if (commentEditable == YES)  //修改按钮点击了
    {
        self.tijiaoBtn.backgroundColor = [UIColor orangeColor];
        
        [self.tijiaoBtn setTitle:@"提交" forState:UIControlStateNormal];
        
        self.textView.backgroundColor = [UIColor colorWithHexCode:@"#FFF084"];
        
        //设置可以打分，可以修改文字，可以点击匿名
        self.starView.userInteractionEnabled = YES;
        self.textView.editable = YES;
        self.nimingBtn.userInteractionEnabled = YES;
        
        commentEditable = NO;
    }
    else // 提交按钮点击了
    {
        //设置完数据后，相应控件改变颜色，按钮显示可以修改
        self.tijiaoBtn.backgroundColor = [UIColor blueColor];
        
        [self.tijiaoBtn setTitle:@"修改评价" forState:UIControlStateNormal];
        
        self.textView.backgroundColor = [UIColor whiteColor];
        
        //设置按钮不可点击
        self.starView.userInteractionEnabled = NO;
        self.textView.editable = NO;
        self.nimingBtn.userInteractionEnabled = NO;
        
        commentEditable = YES;
        
        //保存到服务器
        [self saveComment];
    }
}

- (void)saveComment
{
    [[KGHUD sharedHud] show:self msg:@"提交评论中..."];
    
    [[KGHttpService sharedService] MySchoolSaveComment:self.uuid classuuid:@"" type:@"4" score:[NSString stringWithFormat:@"%ld",(long)score] content:content anonymous:[NSString stringWithFormat:@"%ld",(long)niming] success:^(NSString *mgr)
    {
        [[KGHUD sharedHud] hide:self];
        
        [[KGHUD sharedHud] show:self onlyMsg:@"评论成功!"];
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self onlyMsg:errorMsg];
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    content = self.textView.text;
}

- (IBAction)nimingBtn:(UIButton *)sender
{
    if (sender.selected == YES)
    {
        sender.selected = NO;
        self.nimingLbl.textColor = [UIColor blackColor];
        niming = 0;
    }
    else
    {
        sender.selected = YES;
        self.nimingLbl.textColor = [UIColor redColor];
        niming = 1;
    }
}

- (void)haveCommentFun:(MySPCommentDomain *)domain//有评论，调用这个方法，设置用户的评论数据
{
    score = [domain.score integerValue];
    
    commentEditable = YES;
    
    self.textView.text = domain.content;
    
    NSInteger intCount = (NSInteger)([domain.score integerValue] / 10);
    
    NSInteger halfCount = [domain.score integerValue] - intCount * 10;
    
    [self setUpStarts:intCount halfCount:halfCount];
    
    //设置完数据后，相应控件改变颜色，按钮显示可以修改
    self.tijiaoBtn.backgroundColor = [UIColor blueColor];
    
    [self.tijiaoBtn setTitle:@"修改评价" forState:UIControlStateNormal];
    
    self.textView.backgroundColor = [UIColor whiteColor];
    
    //设置按钮不可点击
    self.starView.userInteractionEnabled = NO;
    self.textView.editable = NO;
    self.nimingBtn.userInteractionEnabled = NO;
    
}

- (void)noCommentFun //没有评论，调用这个方法，让用户评论
{
    score = 50;
    
    commentEditable = NO;
    
    NSInteger intCount = (NSInteger)([@"50" integerValue] / 10);
    
    NSInteger halfCount = [@"50" integerValue] - intCount * 10;
    
    [self setUpStarts:intCount halfCount:halfCount];
}

- (void)setUpStarts:(NSInteger)intCount halfCount:(NSInteger)halfCount
{
    for (NSInteger i = 0; i < 5; i++)
    {
        for (UIButton * btn in self.starView.subviews)
        {
            if (btn.tag == i)
            {
                if (btn.tag < intCount)
                {
                    [btn setImage:[UIImage imageNamed:@"xing30"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"xing30"] forState:UIControlStateDisabled];
                }
                if (btn.tag == intCount)
                {
                    if (halfCount > 5)
                    {
                        [btn setImage:[UIImage imageNamed:@"xing30"] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:@"xing30"] forState:UIControlStateDisabled];
                    }
                    else if(halfCount > 0 && halfCount <=5)
                    {
                        [btn setImage:[UIImage imageNamed:@"bankexing30"] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:@"bankexing30"] forState:UIControlStateDisabled];
                    }
                    else
                    {
                        [btn setImage:[UIImage imageNamed:@"xing1"] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:@"xing1"] forState:UIControlStateDisabled];
                    }
                }
                if (btn.tag > intCount)
                {
                    [btn setImage:[UIImage imageNamed:@"xing1"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"xing1"] forState:UIControlStateDisabled];
                }
            }
        }
    }
}

- (void)setUpBtns
{
    for (NSInteger i=0; i<5; i++)
    {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(i * 30 + (i * 5), 0, 30, 30);
        
        btn.tag = i;
        
        [btn setImage:[UIImage imageNamed:@"xing1"] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.starView addSubview:btn];
    }
}

- (void)btnClick:(UIButton *)btn
{
    for (UIButton *btn in self.starView.subviews)
    {
        [btn setImage:[UIImage imageNamed:@"xing1"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"xing1"] forState:UIControlStateDisabled];
    }
    
    for (NSInteger i=0; i<btn.tag+1; i++)
    {
        [self.starView.subviews[i] setImage:[UIImage imageNamed:@"xing30"] forState:UIControlStateNormal];
        
        [self.starView.subviews[i] setImage:[UIImage imageNamed:@"xing30"] forState:UIControlStateDisabled];
    }
    
    score = (btn.tag + 1) * 10;
}

#pragma mark - UITextView Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
