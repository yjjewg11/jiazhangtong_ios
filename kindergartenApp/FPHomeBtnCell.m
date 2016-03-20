//
//  FPHomeBtnCell.m
//  kindergartenApp
//
//  Created by Mac on 16/1/20.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPHomeBtnCell.h"

@interface FPHomeBtnCell()
{
    __weak IBOutlet UILabel *timeLineLbl;
    __weak IBOutlet UIView *timeLineRedLine;
    
    __weak IBOutlet UILabel *giftwareLbl;
    __weak IBOutlet UIView *giftwareRedLine;
}

@end

@implementation FPHomeBtnCell

- (IBAction)timeLineBtn:(id)sender
{
    
    //时光轴。下划线
    giftwareRedLine.backgroundColor = [UIColor whiteColor];
    
    timeLineRedLine.backgroundColor = [UIColor redColor];
    
    timeLineLbl.textColor = [UIColor redColor];
    giftwareLbl.textColor = [UIColor blackColor];
}

- (IBAction)giftwarePhotos:(id)sender
{
    giftwareRedLine.backgroundColor = [UIColor redColor];
    timeLineRedLine.backgroundColor = [UIColor whiteColor];
    timeLineLbl.textColor = [UIColor blackColor];
    giftwareLbl.textColor = [UIColor redColor];
}
@end
