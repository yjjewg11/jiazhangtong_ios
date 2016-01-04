//
//  BrowseURLViewController.m
//  kindergartenApp
//
//  Created by You on 15/8/13.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "BrowseURLViewController.h"
#import "KGHttpService.h"

@interface BrowseURLViewController () <UIWebViewDelegate>
{
    IBOutlet UIWebView *myWebView;
}

@end

@implementation BrowseURLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.url == nil)
    {
        self.url = @"http://www.wenjienet.com";
    }
    
    self.title = @"我的收藏";
    
    myWebView.hidden = YES;
    [self showLoadView];
    
    myWebView.delegate = self;
    if (self.useCookie)
    {
        NSMutableDictionary * cookieDic = [NSMutableDictionary dictionary];
        [cookieDic setObject:@"JSESSIONID" forKey:NSHTTPCookieName];
        [cookieDic setObject:[KGHttpService sharedService].loginRespDomain.JSESSIONID forKey:NSHTTPCookieValue];
        [cookieDic setObject:@"/" forKey:NSHTTPCookiePath];
        [cookieDic setObject:[self cutUrlDomain:self.url] forKey:NSHTTPCookieDomain];
        NSHTTPCookie * cookieUser = [NSHTTPCookie cookieWithProperties:cookieDic];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieUser];
        
        [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    }
    else
    {
        [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    }
}

- (NSString *)cutUrlDomain:(NSString *)url
{
    NSMutableString * tempurl = [[NSMutableString alloc] initWithString:url];
    
    NSString * myUrl = [tempurl componentsSeparatedByString:@"//"][1];
    NSString * secondUrl = [myUrl componentsSeparatedByString:@"/"][0];
    
    NSString * domain = nil;
    
    if ([secondUrl rangeOfString:@":"].location != NSNotFound)
    {
        domain = [secondUrl componentsSeparatedByString:@":"][0];
    }
    else
    {
        domain = secondUrl;
    }
    
    return domain;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hidenLoadView];
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        myWebView.hidden = NO;
    });
}

@end
