//
//  FPHomeTopView.m
//  kindergartenApp
//
//  Created by Mac on 16/1/18.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPHomeTopView.h"

@interface FPHomeTopView()
{
    __weak IBOutlet UILabel *timeLineLbl;
    __weak IBOutlet UIView *timeLineRedLine;
    
    __weak IBOutlet UILabel *giftwareLbl;
    __weak IBOutlet UIView *giftwareRedLine;
}

@end

@implementation FPHomeTopView

- (IBAction)timeLineBtn:(id)sender
{
    giftwareRedLine.backgroundColor = [UIColor whiteColor];
    timeLineRedLine.backgroundColor = [UIColor redColor];
    timeLineLbl.textColor = [UIColor redColor];
    giftwareLbl.textColor = [UIColor whiteColor];
}

- (IBAction)giftwarePhotos:(id)sender
{
    giftwareRedLine.backgroundColor = [UIColor redColor];
    timeLineRedLine.backgroundColor = [UIColor whiteColor];
    timeLineLbl.textColor = [UIColor whiteColor];
    giftwareLbl.textColor = [UIColor redColor];
}

@end
