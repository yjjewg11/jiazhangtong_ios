//
//  NoNetView.h
//  kindergartenApp
//
//  Created by Mac on 15/11/27.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoNetViewDelegate <NSObject>

- (void)tryBtnClicked;

@end

@interface NoNetView : UIView

@property (weak, nonatomic) id<NoNetViewDelegate> delegate;

@end
