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
    [self getSchoolData];
}

#pragma mark - 请求学校介绍url
- (void)getSchoolData
{
    [[KGHUD sharedHud] show:self];
    
    [[KGHttpService sharedService] getSPSchoolInfoShareUrl:self.groupuuid success:^(NSString *url)
    {
        [[KGHUD sharedHud] hide:self];
        
        if (url != nil || ![url isEqualToString:@""])
        {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        }
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self onlyMsg:errorMsg];
    }];
}

@end
