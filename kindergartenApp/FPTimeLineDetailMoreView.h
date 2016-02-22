//
//  FPTimeLineDetailMoreView.h
//  kindergartenApp
//
//  Created by Mac on 16/2/19.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FPTimeLineDetailMoreViewDelegate <NSObject>

- (void)deleteBtn;

- (void)modifyBtn;

@end

@interface FPTimeLineDetailMoreView : UIView

@property (weak, nonatomic) id<FPTimeLineDetailMoreViewDelegate> delegate;

@end
