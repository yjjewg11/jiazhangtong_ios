//
//  MeFunTableViewCell.h
//  kindergartenApp
//
//  Created by You on 15/7/23.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeFunTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *cellImageView;
@property (strong, nonatomic) IBOutlet UILabel *funTextLabel;

- (void)resetCellParam:(NSString *)funText img:(NSString *)funImg;

@end
