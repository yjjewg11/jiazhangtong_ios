//
//  EnrolStudentSchoolDetailLayout.h
//  kindergartenApp
//
//  Created by Mac on 15/12/3.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnrolStudentSchoolDetailLayout : UICollectionViewFlowLayout

@property (strong, nonatomic) NSMutableArray * commentsCellHeights;

@property (assign, nonatomic) BOOL isCommentCell;

@property (assign, nonatomic) BOOL haveSummary;



@end
