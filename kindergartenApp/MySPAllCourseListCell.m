//
//  MySPAllCourseListCell.m
//  kindergartenApp
//
//  Created by Mac on 15/11/18.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "NSDate+Utils.h"
#import "MySPAllCourseListCell.h"

@interface MySPAllCourseListCell()

@property (weak, nonatomic) IBOutlet UILabel *courseCountLbl;

@property (weak, nonatomic) IBOutlet UILabel *courseNameLbl;

@property (weak, nonatomic) IBOutlet UILabel *dateLbl;

@end

@implementation MySPAllCourseListCell

- (void)awakeFromNib
{
    
}

- (void)setData:(MySPAllCouseListDomain *)domain row:(NSInteger)row tableVC:(MySPCourseTimeListVC *)tableVC
{
    self.courseCountLbl.text = [NSString stringWithFormat:@"第 %ld 课",(long)(row + 1)];
    
    self.courseNameLbl.text = domain.name;
 
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * inputDate = [inputFormatter dateFromString:domain.plandate];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.dateLbl.text = [inputFormatter stringFromDate:inputDate];
}

- (void)setColor:(UIColor *)color
{
    self.courseCountLbl.textColor = color;
    
    self.courseNameLbl.textColor = color;
    
    self.dateLbl.textColor = color;
}

@end
