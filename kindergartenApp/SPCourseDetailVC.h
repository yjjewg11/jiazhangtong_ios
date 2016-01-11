//
//  SpCourseDetailVC.h
//  kindergartenApp
//
//  Created by Mac on 16/1/4.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "BaseViewController.h"

@interface SpCourseDetailVC : BaseViewController

@property (strong, nonatomic) NSString * uuid;

//下面用于地图显示
@property (strong, nonatomic) NSString * map_point;

@property (strong, nonatomic) NSString * locationName;

@property (strong, nonatomic) NSString * schoolName;

@end
