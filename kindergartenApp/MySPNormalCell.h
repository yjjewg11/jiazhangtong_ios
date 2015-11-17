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

@interface MySPNormalCell : UITableViewCell

- (void)setData:(MySPCommentDomain *)domain;

- (void)setSchoolData:(MySPCommentDomain *)domain;


@property (weak, nonatomic) IBOutlet UILabel *teacherNameLbl;

@property (weak, nonatomic) IBOutlet UIView *starView;


@end
