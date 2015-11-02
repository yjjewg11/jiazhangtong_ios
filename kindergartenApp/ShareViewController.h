//
//  ShareViewController.h
//  kindergartenApp
//  分享
//  Created by You on 15/8/6.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "BaseViewController.h"
#import "AnnouncementDomain.h"

@interface ShareViewController : BaseViewController

@property (strong, nonatomic) AnnouncementDomain * announcementDomain;

- (IBAction)shareBtnClicked:(UIButton *)sender;


- (IBAction)cancelShareBtnClicked:(UIButton *)sender;

@end
