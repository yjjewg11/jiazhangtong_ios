//
//  KGPopupViewController.m
//  kindergartenApp
//
//  Created by You on 15/7/24.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGPopupViewController.h"
#import "Masonry.h"

@interface KGPopupViewController () <UIGestureRecognizerDelegate>

@end

@implementation KGPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:Number_ViewAlpha_Five];
    [self addGestureBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)setContentView:(UIView *)contentView {
    _contentView = contentView;
//    _contentView.tag
    [self.view addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
}


//添加手势
- (void)addGestureBtn {
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    singleTapGesture.delegate = self;
    singleTapGesture.numberOfTapsRequired = Number_One;
    singleTapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleTapGesture];
}

//单击手势响应
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if(
//       touch.view.frame.size.width==self.contentView.frame.size.width &&
       touch.view.frame.size.height==self.view.frame.size.height)
        return YES;
    
    NSLog(@"is___%d", touch.view==_contentView);
    
    return NO;
}

//单击响应
- (void)singleTap{
    if(_delegate && [_delegate respondsToSelector:@selector(popupCallback)]) {
        [_delegate popupCallback];
    }
}


@end
