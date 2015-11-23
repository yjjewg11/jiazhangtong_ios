//
//  MySPCourseListCourseDetailCell.m
//  kindergartenApp
//
//  Created by Mac on 15/11/19.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "MySPCourseListCourseDetailCell.h"

@interface MySPCourseListCourseDetailCell()

@property (weak, nonatomic) IBOutlet UITextField *couserName;

@property (weak, nonatomic) IBOutlet UITextField *couresTime;

@property (weak, nonatomic) IBOutlet UITextField *courseLocation;

@property (weak, nonatomic) IBOutlet UITextField *rdyGood;

@end

@implementation MySPCourseListCourseDetailCell

- (void)setData:(MySPAllCouseListDomain *) domain
{
    self.couserName.text = domain.name;
    
    self.couresTime.text = domain.plandate;
    
    self.courseLocation.text = domain.address;
    
    self.rdyGood.text = domain.readyfor;
}

- (void)awakeFromNib
{
    
}


@end
