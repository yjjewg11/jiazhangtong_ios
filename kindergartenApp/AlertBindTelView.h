//
//  AlertBindTelView.h
//  kindergartenApp
//
//  Created by liumingquan on 16/4/19.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^bindTelBtn)();
typedef void(^cancelBtn)();
@interface AlertBindTelView : UIView




@property(nonatomic, strong) bindTelBtn bindTelBtn;
@property(nonatomic, strong) cancelBtn cancelBtn;
@end
