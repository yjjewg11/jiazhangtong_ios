//
//  TimetableItemTableViewCell.h
//  kindergartenApp
//
//  Created by You on 15/8/11.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimetableItemVO.h"
#import "TimetableDomain.h"

@interface TimetableItemTableViewCell : UITableViewCell {
    
    IBOutlet UIImageView * headImageView;
    IBOutlet UILabel * morningLabel;
    IBOutlet UILabel * afternoonLabel;
    TimetableItemVO   * timetableItemVO;
    NSInteger   lastIndex;
}

@property (nonatomic, copy) void (^TimetableItemCellBlock)(TimetableDomain * domain);

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)resetTimetable:(NSArray *)timetableMArray;


- (IBAction)dateBtnClicked:(UIButton *)sender;

@end
