//
//  SPTimetableItemCell.m
//  kindergartenApp
//
//  Created by Mac on 15/10/19.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SPTimetableItemCell.h"
#import "UIImageView+WebCache.h"
#import "MySPCourseDomain.h"

@interface SPTimetableItemCell()

@property (strong, nonatomic) NSString * classuuid;

@end

@implementation SPTimetableItemCell


- (void)setSpTimetableDomain:(SPTimetableDomain *)spTimetableDomain
{
    if(_spTimetableDomain == nil)
    {
        _spTimetableDomain = spTimetableDomain;
        
        [headIcon sd_setImageWithURL:[NSURL URLWithString:_spTimetableDomain.student_headimg] placeholderImage:[UIImage imageNamed:@"head_def"]];
        
        schoolName.text = _spTimetableDomain.group_name;
        
        courseName.text = _spTimetableDomain.class_name;
        
        NSDate *currentDate = [[NSDate alloc] init];
        
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"YY-MM-dd HH:mm:ss";
        NSDate *date = [format dateFromString:_spTimetableDomain.plandate];
        format.dateFormat = @"yyyy-MM-dd";
        NSString * currentDateStr = [format stringFromDate:currentDate];
        NSString * dateStr = [format stringFromDate:date];
        if([currentDateStr isEqualToString:dateStr])
        {
            todayImage.image = [UIImage imageNamed:@"jinri2x"];
        }
        nextCourseDate.text = dateStr;

        courseNameText.text = _spTimetableDomain.name;
        courseDateText.text = _spTimetableDomain.plandate;
        courseLocationText.text = _spTimetableDomain.address;
        preparedItemsText.text = _spTimetableDomain.readyfor;
    }
}



- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [moreCourseBtn.layer setCornerRadius:10];
    
}


+ (instancetype)spCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"TimetableItemTableViewCell";
    SPTimetableItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SPTimetableItemCell"  owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (IBAction)moreCourseBtnClick:(id)sender
{
    MySPCourseDomain * domain = [[MySPCourseDomain alloc] init];
    
    domain.uuid = _spTimetableDomain.classuuid;
    
    domain.group_name = _spTimetableDomain.group_name;
    
    domain.course_title = _spTimetableDomain.name;
    
    domain.student_name = _spTimetableDomain.student_name;
    
    domain.class_name = _spTimetableDomain.class_name;
    
    domain.groupuuid = _spTimetableDomain.groupuuid;
    
    domain.courseuuid = _spTimetableDomain.courseuuid;
    
    domain.plandate = _spTimetableDomain.plandate;
    
    [self.delegate pushVCWithClassuuid:domain];
}


@end
