//
//  SpCourseHomeCourseTypesCell.h
//  kindergartenApp
//
//  Created by Mac on 15/11/26.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SpCourseHomeCourseTypesCell;

@protocol SpCourseHomeCourseTypesCellDelegate <NSObject>

- (void)pushToVC:(UIButton *)btn;
- (void)pushToHotCourseVC;

@end

@interface SpCourseHomeCourseTypesCell : UICollectionViewCell

- (void)setData:(NSMutableArray *)datas;

@property (weak, nonatomic) id<SpCourseHomeCourseTypesCellDelegate> delegate;

@end
