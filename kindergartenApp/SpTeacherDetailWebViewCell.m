//
//  SpTeacherDetailWebViewCell.m
//  kindergartenApp
//
//  Created by Mac on 15/12/1.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SpTeacherDetailWebViewCell.h"

@interface SpTeacherDetailWebViewCell()

@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation SpTeacherDetailWebViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setData:(NSString *)content
{
    [self.webview loadHTMLString:content baseURL:nil];
}

@end
