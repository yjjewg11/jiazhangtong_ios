//
//  EnrolStudentMySchoolWebCell.m
//  kindergartenApp
//
//  Created by Mac on 15/12/4.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "EnrolStudentMySchoolWebCell.h"
#import "KGHUD.h"

@interface EnrolStudentMySchoolWebCell() <UIWebViewDelegate,UIScrollViewDelegate>



@end

@implementation EnrolStudentMySchoolWebCell

- (void)awakeFromNib
{
    self.webView.delegate = self;
    
    self.webView.scrollView.delegate = self;
    
    self.webView.userInteractionEnabled = NO;
    
    self.webView.scalesPageToFit = YES;
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
    if(scrollView.contentOffset.y <= -60)
    {
        [self.delegate pullDownTopView];
    }
}

@end
