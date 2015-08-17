//
//  BaseViewController.m
//  kindergartenApp
//
//  Created by You on 15/7/15.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "BaseViewController.h"
#import "UIColor+Extension.h"
#import "MobClick.h"

@interface BaseViewController ()

@end

@implementation BaseViewController


-(void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"%@",  self.title, nil];
    [MobClick beginLogPageView:cName];
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"%@", self.title, nil];
    [MobClick endLogPageView:cName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    
    [self.contentView setBackgroundColor:KGColorFrom16(0xE7E7EE)];
    [self setNavColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setNavColor {
    UINavigationBar * bar = self.navigationController.navigationBar;
    NSMutableDictionary * textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:16];
    bar.titleTextAttributes = textAttrs;
    //设置显示的颜色
    bar.barTintColor = KGColorFrom16(0xff4966);
}


@end
