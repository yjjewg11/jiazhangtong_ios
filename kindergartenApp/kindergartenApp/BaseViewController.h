//
//  BaseViewController.h
//  kindergartenApp
//
//  Created by You on 15/7/15.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (assign, nonatomic) BOOL animating;
//内容view
@property (strong, nonatomic) IBOutlet UIView * contentView;

@end
