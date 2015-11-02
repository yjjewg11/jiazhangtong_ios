//
//  KGIntroductionViewController.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/19.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "IntroductionViewController.h"
#import "UIColor+Extension.h"
#import "KGHttpService.h"
#import "KGHttpUrl.h"
#import "UIButton+Extension.h"
#import "ItemTitleButton.h"

@interface IntroductionViewController () <UIGestureRecognizerDelegate> {
    
    IBOutlet UIWebView * introductionWebView;
    IBOutlet UIView    * topFunView;
    IBOutlet UIButton  * btn1;
    IBOutlet UIButton  * btn2;
    UIButton           * titleBtn;
}

@end

@implementation IntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    introductionWebView.backgroundColor = [UIColor clearColor];
    introductionWebView.opaque = NO;
    
    [self loadNavTitle];
    
    if(_isNoXYXG) {
        [self topFunBtnClicked:btn2];
    } else {
        [self topFunBtnClicked:btn1];
    }
    
    [self addGestureBtn];
}

//添加手势
- (void)addGestureBtn {
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    singleTapGesture.delegate = self;
    singleTapGesture.numberOfTapsRequired = Number_One;
    singleTapGesture.cancelsTouchesInView = NO;
    [self.contentView addGestureRecognizer:singleTapGesture];
}


//单击响应
- (void)singleTap{
    [UIView animateWithDuration:Number_AnimationTime_Five animations:^{
        topFunView.y = Number_Zero;
        titleBtn.selected = NO;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)loadNavTitle {
    titleBtn = [[ItemTitleButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [titleBtn setImage:@"xiajiantou" selImg:@"sjiantou"];
    
    // 设置图片和文字
    if(_isNoXYXG) {
        [titleBtn setText:@"校园介绍"];
    } else {
        [titleBtn setText:@"招生计划"];
    }

    // 监听标题点击
    [titleBtn addTarget:self
                 action:@selector(titleFunBtnClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
    
}

- (void)titleFunBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    CGFloat y = 64;
    if(!sender.selected) {
        y = Number_Zero;
        titleBtn.selected = NO;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        topFunView.y = y;
    }];
}


- (IBAction)topFunBtnClicked:(UIButton *)sender {
    
    if(sender.tag == btn1.tag) {
        btn1.selected = YES;
        btn2.selected = NO;
    } else {
        btn1.selected = NO;
        btn2.selected = YES;
    }
    
    NSString * webUrl = [KGHttpUrl getYQJSByGroupuuid:[KGHttpService sharedService].groupDomain.uuid];
    if(sender.tag != Number_Ten) {
        webUrl = [KGHttpUrl getZSJHURLByGroupuuid:[KGHttpService sharedService].groupDomain.uuid];
    }
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:webUrl]];
    [introductionWebView loadRequest:request];

    [titleBtn setText:sender.titleLabel.text];
}

@end
