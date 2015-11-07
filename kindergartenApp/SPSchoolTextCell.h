//
//  SPSchoolTextCell.h
//  kindergartenApp
//
//  Created by Mac on 15/11/4.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpCourseDetailTableVC.h"


@interface SPSchoolTextCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSString * content;

- (void)setContext:(NSString *)context withTableVC:(SpCourseDetailTableVC *)tableVC;


@end
