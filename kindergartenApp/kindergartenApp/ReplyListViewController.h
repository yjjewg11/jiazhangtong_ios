//
//  ReplyListViewController.h
//  kindergartenApp
//
//  Created by You on 15/8/6.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "BaseKeyboardViewController.h"

@interface ReplyListViewController : BaseKeyboardViewController

@property (strong, nonatomic) NSString * topicUUID;

- (IBAction)sendBtnClicked:(UIButton *)sender;


@end
