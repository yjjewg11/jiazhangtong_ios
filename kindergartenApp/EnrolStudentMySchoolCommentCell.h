//
//  EnrolStudentMySchoolCommentCell.h
//  kindergartenApp
//
//  Created by Mac on 15/12/4.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySPCommentDomain.h"

@interface EnrolStudentMySchoolCommentCell : UICollectionViewCell

- (void)noCommentFun;

- (void)haveCommentFun:(MySPCommentDomain *)domain;

@property (strong, nonatomic) NSString * uuid;

@end
