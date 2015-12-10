//
//  MineHomeChildrenCell.h
//  kindergartenApp
//
//  Created by Mac on 15/12/8.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MineHomeChildrenCellDelegate <NSObject>

- (void)pushToEditStudentInfo:(UIButton *)btn;

@end

@interface MineHomeChildrenCell : UICollectionViewCell

@property (weak, nonatomic) id<MineHomeChildrenCellDelegate> delegate;

@end
