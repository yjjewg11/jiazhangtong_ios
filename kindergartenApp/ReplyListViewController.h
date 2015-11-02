//
//  ReplyListViewController.h
//  kindergartenApp
//
//  Created by You on 15/8/6.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "BaseTopicInteractViewController.h"

@interface ReplyListViewController : BaseTopicInteractViewController

@property (strong, nonatomic) NSString * topicUUID;
@property (assign, nonatomic) KGTopicType topicType;
@property (strong, nonatomic) IBOutlet UIButton *replyBtn;

- (IBAction)writeReplyBtnClicked:(UIButton *)sender;


@end
