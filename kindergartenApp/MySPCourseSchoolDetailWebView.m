//
//  MySPCourseSchoolDetailWebView.m
//  kindergartenApp
//
//  Created by Mac on 15/11/21.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "MySPCourseSchoolDetailWebView.h"
#import "KGHUD.h"
#import "KGHttpService.h"

@interface MySPCourseSchoolDetailWebView()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end


@implementation MySPCourseSchoolDetailWebView

- (void)awakeFromNib
{
    //请求数据
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

@end
