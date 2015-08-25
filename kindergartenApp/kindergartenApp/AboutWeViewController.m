//
//  AboutWeViewController.m
//  kindergartenApp
//
//  Created by CxDtreeg on 15/8/13.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "AboutWeViewController.h"

@interface AboutWeViewController ()

@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@end

@implementation AboutWeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    _versionLabel.text = [NSString stringWithFormat:@"v%@", version];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
