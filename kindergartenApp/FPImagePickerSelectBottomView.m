//
//  FPImagePickerSelectBottomView.m
//  kindergartenApp
//
//  Created by Mac on 16/1/29.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPImagePickerSelectBottomView.h"

@implementation FPImagePickerSelectBottomView


- (IBAction)btnClick:(id)sender
{
    
    [self.delegate submitOK];
//    
//    NSNotification * noti = [[NSNotification alloc] initWithName:@"endselect" object:nil userInfo:nil];
//    [[NSNotificationCenter defaultCenter] postNotification:noti];
}

@end
