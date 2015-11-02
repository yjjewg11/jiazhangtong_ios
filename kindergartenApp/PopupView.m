//
//  FuniPopupWindowBaseView.m
//  funiiPhoneApp
//
//  Created by You on 14-8-26.
//  Copyright (c) 2014年 LQ. All rights reserved.
//

#import "PopupView.h"
#import "SystemResource.h"
#import "Masonry.h"
#import "UIView+Extension.h"

@implementation PopupView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self addGestureBtn];
    }
    return self;
}


- (void)setPopupContentView:(UIView *)popupContentView{
    [_popupContentView removeFromSuperview];
    _popupContentView = popupContentView;
    [self addSubview:_popupContentView];
    
    [_popupContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(Number_Fourty);
        make.left.equalTo(self.mas_left).offset(Number_Fourty);
        make.right.equalTo(self.mas_right).offset(-Number_Fourty);
        make.bottom.equalTo(self.mas_bottom).offset(-Number_Fourty);
    }];
}

//添加手势
- (void)addGestureBtn {
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(Number_Zero, Number_Zero, self.width, self.height)];
    [btn addTarget:self action:@selector(singleBtnTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

//单击响应
- (void)singleBtnTap{
    [UIView viewAnimate:^{
        self.alpha = Number_Zero;
    } time:0.5f];
}

@end
