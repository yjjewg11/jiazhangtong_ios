//
//  AlertBindTelView.m
//  kindergartenApp
//
//  Created by liumingquan on 16/4/19.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "AlertBindTelView.h"

@implementation AlertBindTelView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)btn_touchInside_bindTel:(id)sender {
    self.bindTelBtn();
}
- (IBAction)btn_touchInside_cancel:(id)sender {
    self.cancelBtn();
}

@end
