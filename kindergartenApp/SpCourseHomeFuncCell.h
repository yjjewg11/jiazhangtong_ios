//
//  SpCourseHomeFuncCell.h
//  kindergartenApp
//
//  Created by Mac on 16/1/18.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SpCourseHomeFuncCell;
@protocol SpCourseHomeFuncCellDelegate <NSObject>

- (void)pushToVC:(UIButton *)btn;
- (void)pushToHotCourseVC;

@end


@interface SpCourseHomeFuncCell : UITableViewCell

@property (weak, nonatomic) id<SpCourseHomeFuncCellDelegate> delegate;

- (void)setData:(NSMutableArray *)datas;

@end
