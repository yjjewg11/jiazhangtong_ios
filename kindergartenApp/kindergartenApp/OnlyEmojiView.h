//
//  OnlyEmojiView.h
//  kindergartenApp
//
//  Created by CxDtreeg on 15/8/16.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonPressed)(UIButton *);

@interface OnlyEmojiView : UIView

@property (strong, nonatomic) ButtonPressed pressedBlock;

@end
