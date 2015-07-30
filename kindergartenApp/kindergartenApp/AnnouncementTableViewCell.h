//
//  AnnouncementTableViewCell.h
//  kindergartenApp
//  公告cell
//  Created by You on 15/7/28.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReFreshBaseCell.h"

@interface AnnouncementTableViewCell : ReFreshBaseCell {
    
    IBOutlet UIImageView * headImageView;
    IBOutlet UILabel * titleLabel;
    IBOutlet UILabel * subTitleLabel;
    IBOutlet UILabel * groupLabel;
    IBOutlet UILabel * timeLabel;
}

@end
