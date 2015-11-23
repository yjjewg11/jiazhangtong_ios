//
//  MySPAllCourseListCell.h
//  kindergartenApp
//
//  Created by Mac on 15/11/18.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySPAllCouseListDomain.h"
#import "MySPCourseTimeListVC.h"

@interface MySPAllCourseListCell : UITableViewCell

- (void)setData:(MySPAllCouseListDomain *)domain row:(NSInteger)row tableVC:(MySPCourseTimeListVC *)tableVC;
- (void)setColor:(UIColor *)color;

@end
