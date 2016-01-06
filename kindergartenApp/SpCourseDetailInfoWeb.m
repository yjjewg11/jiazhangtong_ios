//
//  SpCourseDetailInfoWeb.m
//  kindergartenApp
//
//  Created by Mac on 16/1/6.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "SpCourseDetailInfoWeb.h"

@interface SpCourseDetailInfoWeb() <UIScrollViewDelegate, UIWebViewDelegate>


@end

@implementation SpCourseDetailInfoWeb

- (void)awakeFromNib
{
    self.webview.delegate = self;
    
    self.webview.scrollView.delegate = self;
    
    self.webview.scrollView.bounces = NO;
    
    self.webview.scrollView.scrollEnabled = NO;
    
    self.webview.scrollView.showsVerticalScrollIndicator = NO;
    
    self.webview.scalesPageToFit = YES;
    
    self.webview.scrollView.delaysContentTouches = YES;
    
    self.webview.scrollView.canCancelContentTouches = NO;
    
    self.height = APPWINDOWHEIGHT - 64 - 30 - 48;
}

- (void)setData:(NSString *)url
{
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y <= 0)
    {
        [self.delegate pullDownTopView];
    }
}

@end
