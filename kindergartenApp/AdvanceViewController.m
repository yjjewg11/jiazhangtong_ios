//
//  AdvanceViewController.m
//  kindergartenApp
//
//  Created by CxDtreeg on 15/8/13.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "AdvanceViewController.h"
#import "ACMacros.h"
#import "UMFeedback.h"
#import "KGHUD.h"

@interface AdvanceViewController ()

@end

@implementation AdvanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    _bgView.layer.borderWidth = 0.5;
    _bgView.layer.borderColor = RGBACOLOR(195, 195, 195, 1).CGColor;
    _bgView.layer.cornerRadius = 5;
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(handleCommit)];
    [rightItem setTintColor:[UIColor whiteColor]];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)handleCommit{
    [[KGHUD sharedHud] show:self.view];
    [[UMFeedback sharedInstance] post:@{@"content":_advanceTextView.text} completion:^(NSError *error) {
        [[KGHUD sharedHud] show:self.view onlyMsg:error==nil?@"提交反馈成功,感谢您的支持":error.localizedDescription];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
