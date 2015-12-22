//
//  BrowseURLViewController.m
//  kindergartenApp
//
//  Created by You on 15/8/13.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "BrowseURLViewController.h"

@interface BrowseURLViewController () <UIWebViewDelegate>
{
    
    IBOutlet UIWebView *myWebView;
}

@end

@implementation BrowseURLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    myWebView.delegate = self;
    myWebView.backgroundColor = [UIColor clearColor];
    myWebView.opaque = NO;
    
    if (self.useCookie)
    {
        // 寻找URL为HOST的相关cookie，不用担心，步骤2已经自动为cookie设置好了相关的URL信息
        NSArray * nCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        
        // 设置header，通过遍历cookies来一个一个的设置header
        for (NSHTTPCookie *cookie in nCookies)
        {
            NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:cookie.properties];
            
            [dict setValue:@"/" forKey:@"Path"];
            [dict setValue:@".wenjienet.com" forKey:@"Domain"];
            
            NSHTTPCookie * ck = [NSHTTPCookie cookieWithProperties:dict];
            
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:@[ck]
                                                               forURL:[NSURL URLWithString:_url]
                                                      mainDocumentURL:nil];
        }
        
        [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    }
    else
    {
        [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    }
    
}

@end
