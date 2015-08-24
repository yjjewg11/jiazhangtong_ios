//
//  ReplyTableViewCell.h
//  kindergartenApp
//
//  Created by You on 15/8/6.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReFreshBaseCell.h"
#import "MLEmojiLabel.h"

@interface ReplyTableViewCell : ReFreshBaseCell {
    
    IBOutlet UIImageView * headImageView;
    IBOutlet UILabel * timeLabel;
    IBOutlet UILabel * titleLabel;
    IBOutlet MLEmojiLabel * messageLabel;
    IBOutlet UIImageView * dzImageView;
    IBOutlet UILabel * dzCountLabel;
}

@end
