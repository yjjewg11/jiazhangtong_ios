//
//  SPContactCell.h
//  WXOpenIMSampleDev
//
//  Created by Jai Chen on 15/10/13.
//  Copyright © 2015年 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPContactCell : UITableViewCell

- (void)configureWithAvatar:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle;


@property (nonatomic, copy) NSString *identifier;

@end
