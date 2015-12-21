//
//  ShareBtnView.m
//  kindergartenApp
//
//  Created by Mac on 15/12/21.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "ShareBtnView.h"

@interface ShareBtnView()

@end

@implementation ShareBtnView

- (IBAction)btnClicked:(id)sender
{
    [self.delegate openWeb:self.url];
}

@end
