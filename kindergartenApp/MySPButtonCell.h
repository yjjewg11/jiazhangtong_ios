//
//  MySPButtonCell.h
//  kindergartenApp
//
//  Created by Mac on 15/11/16.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MySPButtonCell;
@protocol MySPButtonCellDelegate <NSObject>

- (void)saveComments:(MySPButtonCell *)cell;

@end

@interface MySPButtonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) id<MySPButtonCellDelegate> delegate;

@end
