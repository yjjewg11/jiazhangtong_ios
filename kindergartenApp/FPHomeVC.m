//
//  FPHomeVC.m
//  kindergartenApp
//
//  Created by Mac on 16/1/13.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPHomeVC.h"
#import "ParallaxHeaderView.h"
#import "FPHomeTopView.h"
#import "FPHomeSonView.h"
#import "JFImagePickerController.h"
#import "FPHomeSelectView.h"

@interface FPHomeVC () <UITableViewDataSource,UITableViewDelegate,JFImagePickerDelegate,FPHomeSelectViewDelegate>
{
    UITableView * tableView;
    FPHomeSonView * sonView;
}


@end

@implementation FPHomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showLoadView];
    
    [self initTableView];
    
    [self createBarItems];
}

- (void)initTableView
{
    //自定义的headerview
    FPHomeTopView * view = [[[NSBundle mainBundle] loadNibNamed:@"FPHomeTopView" owner:nil options:nil] firstObject];
    view.size = CGSizeMake(APPWINDOWWIDTH, 236);
    
    //弄到tableviewheader里面去
    ParallaxHeaderView * headerView = [ParallaxHeaderView parallaxHeaderViewWithSubView:view];
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64 - 49)];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView setTableHeaderView:headerView];
    [self.view addSubview:tableView];
    
    sonView = [[[NSBundle mainBundle] loadNibNamed:@"FPHomeSonView" owner:nil options:nil] firstObject];
    sonView.origin = CGPointMake(0, -132);
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:sonView.bounds];
    sonView.layer.masksToBounds = NO;
    sonView.layer.shadowColor = [UIColor blackColor].CGColor;
    sonView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    sonView.layer.shadowOpacity = 0.5f;
    sonView.layer.shadowPath = shadowPath.CGPath;
    [self.view addSubview:sonView];
}

#pragma mark UISCrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == tableView)
    {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
        [(ParallaxHeaderView *)tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

#pragma mark - 创建navBar items
- (void)createBarItems
{
    UIButton* btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"new_album"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(pushToUpLoadVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    UIButton* btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,27)];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"hanbao"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(showSonView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
}

- (void)pushToUpLoadVC
{
    FPHomeSelectView * selView = [[[NSBundle mainBundle] loadNibNamed:@"FPHomeSelectView" owner:nil options:nil] firstObject];
    selView.delegate = self;
    selView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    
    CATransition *applicationLoadViewIn =[CATransition animation];
    [applicationLoadViewIn setDuration:0.3];
    [applicationLoadViewIn setType:kCATransitionReveal];
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [[selView layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
    [self.view addSubview:selView];

}

- (void)showSonView
{
    [UIView animateWithDuration:0.2 animations:^
    {
        if (sonView.origin.y == 0)
            sonView.origin = CGPointMake(0, -132);
        else
            sonView.origin = CGPointMake(0, 0);
    }];
}

#pragma mark - 图片选择器代理
- (void)imagePickerDidFinished:(JFImagePickerController *)picker
{
    //    [JFImagePickerController clear];  //clear datas 要清除调用这个
    //picker.assets is all choices photo
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerDidCancel:(JFImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)pushToImagePickerVC
{
    JFImagePickerController *picker = [[JFImagePickerController alloc] initWithRootViewController:self];
    picker.pickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

@end
