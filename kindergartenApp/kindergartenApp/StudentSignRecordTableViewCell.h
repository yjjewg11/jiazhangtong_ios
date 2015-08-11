//
//  StudentSignRecordTableViewCell.h
//  kindergartenApp
//  签到记录Cell
//  Created by yangyangxun on 15/8/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReFreshBaseCell.h"

@interface StudentSignRecordTableViewCell : ReFreshBaseCell {
    
    
    IBOutlet UIImageView * headImageView;
    IBOutlet UILabel * nameLabel;
    IBOutlet UILabel * timeLabel;
    IBOutlet UILabel * addressLabel;
    IBOutlet UILabel * signNameLabel;
    IBOutlet UILabel * typeLabel;
    
}

@end
