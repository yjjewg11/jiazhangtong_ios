//
//  SPTextCell.m
//  kindergartenApp
//
//  Created by Mac on 15/11/2.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SPTextCell.h"
#import "KGNSStringUtil.h"

@interface SPTextCell() <UIWebViewDelegate>

@property (strong, nonatomic) SpCourseDetailTableVC * tableVC;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeight;

@end

@implementation SPTextCell


- (void)setContext:(NSString *)context withTableVC:(SpCourseDetailTableVC *)tableVC
{
    _tableVC = tableVC;
    
    [self setContent:context];
}

- (void)setContent:(NSString *)content
{
    if (content == nil)
    {
        _content = @"暂无数据";
    }
    else
    {
        _content = content;
    }
    
    self.webViewHeight.constant = self.tableVC.courseRowHeight + 20;
    
    self.webView.scrollView.scrollEnabled = NO;
    
    [self.webView loadHTMLString:_content baseURL:nil];
}


@end
