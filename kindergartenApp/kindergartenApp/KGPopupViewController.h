//
//  KGPopupViewController.h
//  kindergartenApp
//
//  Created by You on 15/7/24.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KGPopupVCDelegate <NSObject>

- (void)popupCallback;

@end

@interface KGPopupViewController : UIViewController


@property (strong, nonatomic) id<KGPopupVCDelegate> delegate;
@property (strong, nonatomic) UIView * contentView;

@end
