//
//  GiftwareArticlesInfoViewController.h
//  kindergartenApp
//  精品文章详情
//  Created by You on 15/7/31.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "BaseViewController.h"
#import "AnnouncementDomain.h"

@interface GiftwareArticlesInfoViewController : BaseViewController

@property (strong, nonatomic) NSString * annuuid;

- (IBAction)articlesFunBtnClicked:(UIButton *)sender;

@end
