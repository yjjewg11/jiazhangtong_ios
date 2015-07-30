//
//  PostTopicViewController.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/25.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "BaseKeyboardViewController.h"

@interface PostTopicViewController : BaseKeyboardViewController

@property (strong, nonatomic) NSString * topicUUID;
@property (assign, nonatomic) KGTopicType topicType;

- (IBAction)addImgBtnClicked:(UIButton *)sender;

@end
