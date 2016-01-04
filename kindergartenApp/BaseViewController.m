//
//  BaseViewController.m
//  kindergartenApp
//
//  Created by You on 15/7/15.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"%@",  self.title, nil];
    [MobClick beginLogPageView:cName];
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"%@", self.title, nil];
    [MobClick endLogPageView:cName];
}

- (NoNetView *)noNetView
{
    if (_noNetView == nil)
    {
        _noNetView = [[[NSBundle mainBundle] loadNibNamed:@"NoNetView" owner:nil options:nil] firstObject];
    }
    return _noNetView;
}

- (SDRotationLoopProgressView *)loadingView
{
    if (_loadingView == nil)
    {
        _loadingView = [SDRotationLoopProgressView progressView];
    }
    return _loadingView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.contentView setBackgroundColor:KGColorFrom16(0xE7E7EE)];
    [self setNavColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setNavColor {
    UINavigationBar * bar = self.navigationController.navigationBar;
    NSMutableDictionary * textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:16];
    bar.titleTextAttributes = textAttrs;
    
    bar.translucent = NO;

    UIImage * img = [[UIImage alloc] init];
    
    [[UINavigationBar appearance] setBackgroundImage:img forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:img];

    //设置显示的颜色
    bar.barTintColor = [UIColor colorWithHexCode:@"#FF6666"];
}

#pragma mark - 菊花相关
- (void)showLoadView
{
    self.loadingView.frame = CGRectMake(0, 0, 100 * KWidth_Scale, 100 * KWidth_Scale);
    
    self.loadingView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2 - 64);
    
    [self.view addSubview: self.loadingView];

    [self.view bringSubviewToFront:self.loadingView];
}

- (void)hidenLoadView
{
    
    [self.loadingView removeFromSuperview];
}

- (void)showNoNetView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.noNetView.delegate = self;
    
    self.noNetView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2 - 64);
    
    [self.view addSubview:self.noNetView];
}

- (void)hidenNoNetView
{
   [self.noNetView removeFromSuperview];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
