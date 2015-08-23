//
//  MyCollectionViewController.h
//  kindergartenApp
//
//  Created by CxDtreeg on 15/8/15.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "BaseViewController.h"

#import "UIColor+Extension.h"
#import "ACMacros.h"
#import "CollectNoticeTableViewCell.h"
#import "KGHttpService.h"
#import "MJRefresh.h"
#import "KGHUD.h"
#import "FavoritesDomain.h"
#import "GiftwareArticlesInfoViewController.h"
#import "AnnouncementInfoViewController.h"
#import "IntroductionViewController.h"

@interface MyCollectionViewController : BaseViewController

@property (strong, nonatomic) UITableView * tableView;
@property (assign, nonatomic) NSInteger pageIndex;//数据页数

@end
