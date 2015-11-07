//
//  SPTextCell.h
//  kindergartenApp
//
//  Created by Mac on 15/11/2.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpCourseDetailTableVC.h"


@interface SPTextCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSString * content;

- (void)setContext:(NSString *)context withTableVC:(SpCourseDetailTableVC *)tableVC;


@end
