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
    
    IBOutlet UIView *timetableContentView;
    IBOutlet UIImageView * headImageView;
    IBOutlet UILabel * morningLabel;
    IBOutlet UILabel * afternoonLabel;
    IBOutlet UITextView *morningTextView;
    IBOutlet UITextView *afternoonTextView;
    IBOutlet UILabel *label1;
    IBOutlet UILabel *label2;
    IBOutlet UILabel *label3;
    TimetableItemVO   * timetableItemVO;
    NSInteger   lastIndex;
}

@property (strong, nonatomic) TimetableDomain * selTimetableDomain;
@property (assign, nonatomic) NSInteger         selWeekday;
@property (nonatomic, copy) void (^TimetableItemCellBlock)(TimetableItemTableViewCell * timetableItemTableViewCell);

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)resetTimetable:(NSArray *)timetableMArray;


- (IBAction)dateBtnClicked:(UIButton *)sender;

@end
