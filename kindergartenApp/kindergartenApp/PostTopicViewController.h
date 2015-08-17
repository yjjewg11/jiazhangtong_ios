//
//  PostTopicViewController.h
//  kindergartenApp
//  发帖
//  Created by yangyangxun on 15/7/25.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "SelectClassCell.h"
#import "BaseTopicInteractViewController.h"

@interface PostTopicViewController :BaseTopicInteractViewController  <UITableViewDataSource,UITableViewDelegate>

//@property (strong, nonatomic) NSString * topicUUID;
//@property (assign, nonatomic) KGTopicType topicType;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIButton *selectBtn;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (strong, nonatomic) UITableView * selectTableView;
@property (strong, nonatomic) IBOutlet UIView *topBgVIew;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnArray;


- (IBAction)addImgBtnClicked:(UIButton *)sender;

@end
