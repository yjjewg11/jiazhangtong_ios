//
//  NoNetView.m
//  kindergartenApp
//
//  Created by Mac on 15/11/27.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "NoNetView.h"

@interface NoNetView()

@property (weak, nonatomic) IBOutlet UIButton *tryAgBtn;

@end


@implementation NoNetView

- (void)awakeFromNib
{
    self.tryAgBtn.layer.borderWidth = 1;
    self.tryAgBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.tryAgBtn.layer.cornerRadius = 5;
}

- (IBAction)tyrAgBtnClick:(UIButton *)sender
{
    [self.delegate tryBtnClicked];
}

@end
