//
//  MessageTableViewCell.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/28.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReFreshBaseCell.h"

@interface MessageTableViewCell : ReFreshBaseCell

@property (strong, nonatomic) IBOutlet UIImageView * headImageView;
@property (strong, nonatomic) IBOutlet UILabel * titleLabel;
@property (strong, nonatomic) IBOutlet UILabel * subTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel * groupLabel;
@property (strong, nonatomic) IBOutlet UILabel * timeLabel;


@end
