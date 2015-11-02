//
//  TimetableItemTableViewCell.m
//  kindergartenApp
//
//  Created by You on 15/8/11.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "TimetableItemTableViewCell.h"
#import "KGHttpService.h"
#import "UIImageView+WebCache.h"
#import "UIButton+Extension.h"
#import "UIColor+Extension.h"
#import "KGDateUtil.h"
#import "MLEmojiLabel.h"
#import "Masonry.h"

#define defHeight  42

@implementation TimetableItemTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"TimetableItemTableViewCell";
    TimetableItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TimetableItemTableViewCell"  owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    UIButton * btn = nil;
    for(NSInteger i=Number_Eleven; i<=Number_Fifteen; i++) {
        btn = (UIButton *)[self viewWithTag:i];
        [btn setTextColor:[UIColor whiteColor] sel:[UIColor whiteColor]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)resetTimetable:(TimetableItemVO *)timetableVO {
    timetableItemVO = timetableVO;
    lastIndex = timetableItemVO.weekday + Number_Ten;
    _selWeekday = timetableItemVO.weekday;
    
    [self loadTimetable:timetableItemVO.weekday];
    UIButton * btn = (UIButton *)[self viewWithTag:lastIndex];
    btn.selected = YES;
    
    [headImageView sd_setImageWithURL:[NSURL URLWithString:timetableItemVO.headUrl] placeholderImage:[UIImage imageNamed:@"head_def"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [headImageView setBorderWithWidth:Number_Zero color:KGColorFrom16(0xE7E7EE) radian:headImageView.width / Number_Two];
    }];
}

//星期一到五按钮点击
- (IBAction)dateBtnClicked:(UIButton *)sender {
    sender.selected = YES;
    if(sender.tag != lastIndex) {
        
        _selWeekday = sender.tag - Number_Ten;
        
        if(self.TimetableItemCellBlock) {
            self.TimetableItemCellBlock(self);
        }
    }
}


- (void)loadTimetable:(NSInteger)index {
    BOOL judge = NO;
    for(TimetableDomain * domain in timetableItemVO.timetableMArray) {
        NSInteger weekday = [KGDateUtil weekdayStringFromDate:domain.plandate];
        _selWeekday = weekday;
        _selTimetableDomain = domain;
        if(weekday == index) {
            [self resetTimetableData:domain];
            judge = YES;
            break;
        }
    }
    
    if(!judge) {
        [self resetTimetableData:nil];
    }
}

- (void)resetTimetableData:(TimetableDomain *)domain {
    if(domain) {
        morningLabel.text = domain.morning;
        afternoonLabel.text = domain.afternoon;
        morningTextView.text = domain.morning;
        afternoonTextView.text = domain.afternoon;
//        [self resetContentFrame:domain];
    } else {
        morningLabel.text = String_DefValue_Empty;
        afternoonLabel.text = String_DefValue_Empty;
        morningTextView.text = String_DefValue_Empty;
        afternoonTextView.text = String_DefValue_Empty;
//        [self resetNoDataContentFrame];
    }
}


- (void)resetContentFrame:(TimetableDomain *)domain {
    CGFloat width = KGSCREEN.size.width - 93 - 16;
    CGFloat height = 90;
    CGSize size = [MLEmojiLabel boundingRectWithSize:domain.morning w:width font:APPUILABELFONTNO12];
//    morningLabel.height = size.height;
    morningLabel.width  = width;
    if(size.height > defHeight) {
        height += size.height - defHeight;
//        label2.y += size.height - defHeight;
        afternoonLabel.y = CGRectGetMaxY(label2.frame);
    }
    
    CGSize size2 = [MLEmojiLabel boundingRectWithSize:domain.afternoon w:width font:APPUILABELFONTNO12];
    afternoonLabel.height = size2.height;
    afternoonLabel.width  = width;
    if(size2.height > defHeight) {
        height += size2.height - defHeight;
    }
    
    label1.height = height;
    label3.y = height - Number_One;
    timetableContentView.height = height;
}


- (void)resetNoDataContentFrame {
    morningLabel.height = 42;
    afternoonLabel.height = 42;
}

@end
