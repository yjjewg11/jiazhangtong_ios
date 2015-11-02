//
//  MoreMenuViewController.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/6.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicMenuDomain.h"

@interface MoreMenuView : UIView

@property (nonatomic, copy) void (^MoreMenuBlock)(DynamicMenuDomain * domain);

- (void)loadMoreMenu:(NSArray *)menuArray;

@end
