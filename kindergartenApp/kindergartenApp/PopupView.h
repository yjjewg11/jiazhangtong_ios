//
//  FuniPopupWindowBaseView.h
//  funiiPhoneApp
//
//  Created by You on 14-8-26.
//  Copyright (c) 2014年 LQ. All rights reserved.
//

#import "KGBaseView.h"

@interface PopupView : KGBaseView <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView * popupContentView;

//单击响应
- (void)singleBtnTap;
@end
