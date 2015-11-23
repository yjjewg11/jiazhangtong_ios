//
//  SPCourseDetailScrollInfoWebView.m
//  kindergartenApp
//
//  Created by Mac on 15/11/20.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SPCourseDetailScrollInfoWebView.h"

@interface SPCourseDetailScrollInfoWebView()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SPCourseDetailScrollInfoWebView

- (void)setData:(NSString *)url
{
    
    self.webView.scrollView.showsHorizontalScrollIndicator = YES;
    self.webView.scrollView.showsVerticalScrollIndicator = YES;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
