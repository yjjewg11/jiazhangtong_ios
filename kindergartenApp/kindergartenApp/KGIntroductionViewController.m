//
//  KGIntroductionViewController.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/19.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGIntroductionViewController.h"

@interface KGIntroductionViewController () {
    
    IBOutlet UIWebView *introductionWebView;
}

@end

@implementation KGIntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [introductionWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
