//
//  EnrolStudentWebViewCell.m
//  kindergartenApp
//
//  Created by Mac on 15/12/3.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "EnrolStudentWebViewCell.h"
#import "KGHUD.h"

@interface EnrolStudentWebViewCell() <UIWebViewDelegate,UIScrollViewDelegate>

@end


@implementation EnrolStudentWebViewCell

- (void)awakeFromNib
{
    self.webView.delegate = self;

    self.webView.scrollView.delegate = self;
    
    self.webView.scrollView.bounces = NO;
    
    self.webView.scrollView.scrollEnabled = NO;

    self.webView.scalesPageToFit = YES;
    
    self.webView.scrollView.delaysContentTouches = YES;
    self.webView.scrollView.canCancelContentTouches = NO;
    
    [[KGHUD sharedHud] hide:self.webView];
    
    //添加手势
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [self addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    
    [self addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    
    [self addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    
    [self addGestureRecognizer:recognizer];
}

#pragma mark - 手势触发方法
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown)
    {
        if (self.webView.scrollView.contentOffset.y <= 1)
        {
            [self.delegate pullDownTopView];
        }
    }
}


- (void)setData:(NSString *)url
{
    [[KGHUD sharedHud] show:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[KGHUD sharedHud] hide:self.webView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //当currentOffset与maximumOffset的值相等时，说明scrollview已经滑到底部了。也可以根据这两个值的差来让他做点其他的什么事情
    if(scrollView.contentOffset.y <= 0)
    {
        [self.delegate pullDownTopView];
    }
}


@end
