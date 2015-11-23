//
//  MySPCourseTimeListVC.h
//  kindergartenApp
//
//  Created by Mac on 15/11/18.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySPCourseTimeListVC : UITableViewController

@property (strong, nonatomic) NSString * classuuid;

@property (assign, nonatomic) CGRect tableFrame;

@property (strong, nonatomic) NSMutableArray * listDatas;

@property (assign, nonatomic) NSInteger colorCount;

@end
