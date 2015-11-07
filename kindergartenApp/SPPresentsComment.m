//
//  SPPresentsComment.m
//  kindergartenApp
//
//  Created by Mac on 15/11/2.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SPPresentsComment.h"

@interface SPPresentsComment()

@property (weak, nonatomic) IBOutlet UILabel *personName;

@property (weak, nonatomic) IBOutlet UILabel *contentLbl;

@property (weak, nonatomic) IBOutlet UILabel *dateLbl;

@property (weak, nonatomic) IBOutlet UIView *starView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfContentLbl;

@end

@implementation SPPresentsComment

- (void)awakeFromNib
{
    self.rowHeight = 123;
}


@end
