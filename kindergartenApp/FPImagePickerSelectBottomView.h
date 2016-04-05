//
//  FPImagePickerSelectBottomView.h
//  kindergartenApp
//
//  Created by Mac on 16/1/29.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FPImagePickerSelectBottomViewDelegate <NSObject>

//提交选择数据
- (void)submitOK;

@end
@interface FPImagePickerSelectBottomView : UIView

@property (weak, nonatomic) IBOutlet UILabel *infoLbl;

@property (strong, nonatomic) id<FPImagePickerSelectBottomViewDelegate> delegate;

@end
