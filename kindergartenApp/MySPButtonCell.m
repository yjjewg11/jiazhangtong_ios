//
//  MySPButtonCell.m
//  kindergartenApp
//
//  Created by Mac on 15/11/16.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "MySPButtonCell.h"

@interface MySPButtonCell()


@end

@implementation MySPButtonCell

- (IBAction)btnClick:(UIButton *)sender
{
    [self.delegate saveComments:self];
}

@end
