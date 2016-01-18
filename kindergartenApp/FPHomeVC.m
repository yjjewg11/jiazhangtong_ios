//
//  FPHomeVC.m
//  kindergartenApp
//
//  Created by Mac on 16/1/13.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPHomeVC.h"
#import "FPHomeTopView.h"


@interface FPHomeVC ()

@property (strong, nonatomic) UITableView * tableView;

@end

@implementation FPHomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableView];
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT)];
    
    FPHomeTopView * stretchView = [[[NSBundle mainBundle] loadNibNamed:@"FPHomeTopView" owner:nil options:nil] firstObject];
    
    
    
    [self.view addSubview:self.tableView];
}




@end
