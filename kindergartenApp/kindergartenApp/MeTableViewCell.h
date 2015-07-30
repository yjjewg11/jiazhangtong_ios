//
//  MeTableViewCell.h
//  kindergartenApp
//
//  Created by You on 15/7/23.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGUser.h"

@interface MeTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView * headImageView;
@property (strong, nonatomic) IBOutlet UILabel     * nameLabel;
@property (strong, nonatomic) IBOutlet UILabel     * otherInfoLabel;


- (void)resetCellParam:(KGUser *)user;

@end
