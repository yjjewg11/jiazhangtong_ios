//
//  SPBottomItem.h
//  kindergartenApp
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPBottomItem : UIView

@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *tipNumberLbl;



- (void)setPic:(NSString *)name Title:(NSString *)title;

- (void)setTipNumber:(NSInteger)count;
@end
