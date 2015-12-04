//
//  EnrolStudentMySchoolBtnCell.h
//  kindergartenApp
//
//  Created by Mac on 15/12/4.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EnrolStudentMySchoolBtnCellDelegate <NSObject>

- (void)funcBtnClick:(UIButton *)btn;

@end

@interface EnrolStudentMySchoolBtnCell : UICollectionViewCell

@property (weak, nonatomic) id<EnrolStudentMySchoolBtnCellDelegate> delegate;

@end
