//
//  MoreMenuViewController.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/6.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoreMenuViewDelegate <NSObject>

- (void)cancelCallback;

@end

@interface MoreMenuView : UIView

@property (strong, nonatomic) id<MoreMenuViewDelegate> delegate;

- (void)loadMoreMenu:(NSArray *)menuArray;

@end
