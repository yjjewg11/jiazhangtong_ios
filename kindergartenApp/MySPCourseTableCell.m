//
//  MySPCourseCell.m
//  kindergartenApp
//
//  Created by Mac on 15/11/11.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "MySPCourseTableCell.h"
#import "UIImageView+WebCache.h"

@interface MySPCourseTableCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *courseNameLbl;

@property (weak, nonatomic) IBOutlet UILabel *studentLbl;

@property (weak, nonatomic) IBOutlet UILabel *classLbl;

@property (weak, nonatomic) IBOutlet UILabel *schoolLbl;

@property (weak, nonatomic) IBOutlet UILabel *studyTimeLbl;


@end


@implementation MySPCourseTableCell

- (void)setData:(MySPCourseDomain *)domain
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:domain.logo] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    
    self.courseNameLbl.text = domain.course_title;
    
    self.studentLbl.text = domain.student_name;
    
    self.classLbl.text = domain.class_name;
    
    self.schoolLbl.text = domain.group_name;
    
    self.studyTimeLbl.text = domain.plandate;
}

@end
