//
//  GiftwareArticlesTableViewCell.h
//  kindergartenApp
//  精品文章Cell
//  Created by You on 15/7/31.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReFreshBaseCell.h"
#import "AnnouncementDomain.h"

@interface GiftwareArticlesTableViewCell : ReFreshBaseCell {
    
    IBOutlet UILabel * teacherLabel;
    IBOutlet UILabel * titleLabel;
    IBOutlet UILabel * contentLabel;
    IBOutlet UILabel * timeLabel;
    IBOutlet UIImageView * dzImageView;
    IBOutlet UILabel * dzCountLabel;
}

@property (strong, nonatomic) AnnouncementDomain * announcementDomain;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
