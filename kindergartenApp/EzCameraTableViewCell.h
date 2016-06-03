//
//  EzCameraTableViewCell.h
//  kindergartenApp
//
//  Created by liumingquan on 16/6/1.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZCamrea.h"
@interface EzCameraTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong,nonatomic) EZCamrea *  domain;

- (void)setDomainToView:(EZCamrea * )domain;
@end
