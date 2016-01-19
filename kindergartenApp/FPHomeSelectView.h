//
//  FPHomeSelectView.h
//  kindergartenApp
//
//  Created by Mac on 16/1/19.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FPHomeSelectViewDelegate <NSObject>

- (void)pushToImagePickerVC;

- (void)pushToCreateGiftwareShopVC;

@end

@interface FPHomeSelectView : UIView

@property (weak, nonatomic) id<FPHomeSelectViewDelegate> delegate;

@end
