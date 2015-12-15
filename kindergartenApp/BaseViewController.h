//
//  BaseViewController.h
//  kindergartenApp
//
//  Created by You on 15/7/15.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
#import "MobClick.h"
#import "NoNetView.h"
#import "UIColor+flat.h"
#import "SDRotationLoopProgressView.h"

@interface BaseViewController : UIViewController <NoNetViewDelegate>

@property (assign, nonatomic) BOOL animating;

//内容view
@property (strong, nonatomic) IBOutlet UIView * contentView;

@property (strong, nonatomic) SDRotationLoopProgressView * loadingView;

@property (strong, nonatomic) NoNetView * noNetView;

- (void)showLoadView;
- (void)hidenLoadView;
- (void)showNoNetView;
- (void)hidenNoNetView;

@end
