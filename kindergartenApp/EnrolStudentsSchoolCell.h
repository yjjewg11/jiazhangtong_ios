//
//  EnrolStudentsSchoolCell.h
//  kindergartenApp
//
//  Created by Mac on 15/12/2.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnrolStudentsSchoolDomain.h"

@interface EnrolStudentsSchoolCell : UICollectionViewCell

- (void)setData:(EnrolStudentsSchoolDomain *)domain;

@property (assign, nonatomic) NSInteger summaryCount;

@end
