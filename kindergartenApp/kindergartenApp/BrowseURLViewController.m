//
//  BrowseURLViewController.m
//  kindergartenApp
//
//  Created by You on 15/8/13.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "BrowseURLViewController.h"

@interface BrowseURLViewController () {
    
    IBOutlet UIWebView *myWebView;
}

@end

@implementation BrowseURLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    myWebView.backgroundColor = [UIColor clearColor];
    myWebView.opaque = NO;
    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
