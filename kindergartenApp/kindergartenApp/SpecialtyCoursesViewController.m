//
//  SpecialtyCoursesViewController.m
//  kindergartenApp
//
//  Created by You on 15/7/31.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "SpecialtyCoursesViewController.h"
#import "KGHttpUrl.h"

@interface SpecialtyCoursesViewController () {
    
    IBOutlet UIWebView * myWebView;
}

@end

@implementation SpecialtyCoursesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"特长课程";
    
    myWebView.backgroundColor = [UIColor clearColor];
    myWebView.opaque = NO;
    [myWebView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[KGHttpUrl getSpecialtyCoursesUrl]]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
