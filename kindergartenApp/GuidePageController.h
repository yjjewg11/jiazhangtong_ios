//
//  ViewController.h
//  ScrollViewTest
//
//  Created by silentcloud on 11/2/13.
//  Copyright (c) 2013 qiang.mou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGTabBarViewController.h"
@interface GuidePageController : UIViewController <UIScrollViewDelegate>

@property(strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property(strong, nonatomic) IBOutlet UIPageControl *pageControl;
+(void) firstLaunch;
@end
