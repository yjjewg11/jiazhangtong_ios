//
//  MySPNormalCell.h
//  kindergartenApp
//
//  Created by Mac on 15/11/16.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySPCommentDomain.h"
#import "MySPCourseTeacherList.h"

@protocol  MySPNormalCellDelegate<NSObject>

- (void)saveSchoolScore:(NSString *)score;

@end

@interface MySPNormalCell : UITableViewCell

- (void)setSchoolData:(MySPCommentDomain *)domain;

@property (weak, nonatomic) IBOutlet UILabel *teacherNameLbl;

@property (weak, nonatomic) IBOutlet UIView *starView;

@property (strong, nonatomic) NSString * userscore;

@property (weak, nonatomic) id<MySPNormalCellDelegate> delegate;

- (void)initNoCommentData;

@end
