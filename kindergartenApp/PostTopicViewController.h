//
//  PostTopicViewController.h
//  kindergartenApp
//  发帖
//  Created by yangyangxun on 15/7/25.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "SelectClassCell.h"
#import "BaseTopicInteractViewController.h"
#import "TopicDomain.h"
#import "DoImagePickerController.h"
#import "PhotoVC.h"

@interface PostTopicViewController :BaseTopicInteractViewController  <UITableViewDataSource,UITableViewDelegate, DoImagePickerControllerDelegate>

@property (assign, nonatomic) KGTopicType topicType;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIButton *selectBtn;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (strong, nonatomic) UITableView * selectTableView;
@property (strong, nonatomic) IBOutlet UIView *topBgVIew;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnArray;

@property (nonatomic, copy) void (^PostTopicBlock)(TopicDomain * topicDomain);

@property (strong, nonatomic) IBOutlet UIScrollView *photoScrollView;//图片横向滚动
@property (strong, nonatomic) UIView *photoContentView;//图片内容视图
@property (strong, nonatomic) NSMutableArray * addPhotoBtnMArray;//图片按钮


@end
