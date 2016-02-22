//
//  FPTimeLineDetailMoreView.m
//  kindergartenApp
//
//  Created by Mac on 16/2/19.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPTimeLineDetailMoreView.h"

@implementation FPTimeLineDetailMoreView

- (IBAction)deleteBtnClick:(id)sender
{
    [self.delegate deleteBtn];
}

- (IBAction)bianjiBtnClick:(id)sender
{
    [self.delegate modifyBtn];
}


@end
