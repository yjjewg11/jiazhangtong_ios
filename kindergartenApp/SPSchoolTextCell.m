//
//  SPSchoolTextCell.m
//  kindergartenApp
//
//  Created by Mac on 15/11/4.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SPSchoolTextCell.h"

@interface SPSchoolTextCell()

@property (strong, nonatomic) SpCourseDetailTableVC * tableVC;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeight;

@end

@implementation SPSchoolTextCell

- (void)setContext:(NSString *)context withTableVC:(SpCourseDetailTableVC *)tableVC
{
    _tableVC = tableVC;
    
    [self setContent:context];
}

- (void)setContent:(NSString *)content
{
    _content = content;
    
    self.webViewHeight.constant = self.tableVC.schollRowHeight;
    
    self.webView.scrollView.scrollEnabled = NO;
    
    [self.webView loadHTMLString:_content baseURL:nil];
}

@end
