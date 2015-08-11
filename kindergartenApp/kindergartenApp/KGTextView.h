//
//  KGTextView.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGTextView : UITextView

@property(nonatomic, strong) NSString * placeholder;     //占位符

//添加通知
- (void)addObserver;

//移除通知
- (void)removeobserver;

@end
