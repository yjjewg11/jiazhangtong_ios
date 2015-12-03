//
//  EnrolStudentButtonCell.h
//  kindergartenApp
//
//  Created by Mac on 15/12/3.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EnrolStudentButtonCellDelegate <NSObject>

- (void)funcBtnClick:(UIButton *)btn;

@end

@interface EnrolStudentButtonCell : UICollectionViewCell

@property (weak, nonatomic) id<EnrolStudentButtonCellDelegate> delegate;

@end
