//
//  MySPCourseEndedView.m
//  kindergartenApp
//
//  Created by Mac on 15/11/23.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "MySPCourseEndedView.h"
#import "UIImageView+WebCache.h"

@interface MySPCourseEndedView()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *courseNameLbl;

@property (weak, nonatomic) IBOutlet UILabel *studentNameLbl;

@property (weak, nonatomic) IBOutlet UILabel *classNameLbl;

@property (weak, nonatomic) IBOutlet UILabel *schoolNameLbl;

@property (weak, nonatomic) IBOutlet UILabel *courseTimeLbl;

@end

@implementation MySPCourseEndedView

- (void)setData:(MySPCourseDomain *)domain
{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:domain.logo] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    
    self.courseNameLbl.text = domain.course_title;
    
    self.studentNameLbl.text = domain.student_name;
    
    self.classNameLbl.text = domain.class_name;
    
    self.schoolNameLbl.text = domain.group_name;
    
    self.courseTimeLbl.text = domain.disable_time;
}

@end
