//
//  EnrolStudentSchoolDetailFullScreenLayout.h
//  kindergartenApp
//
//  Created by Mac on 15/12/3.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnrolStudentSchoolDetailFullScreenLayout : UICollectionViewFlowLayout

@property (assign, nonatomic) BOOL isCommentCell;

@property (strong, nonatomic) NSMutableArray * commentsCellHeights;

@property (assign, nonatomic) BOOL haveSummary;

@end
