//
//  FPGiftwarePickerImageCell.h
//  kindergartenApp
//
//  Created by Mac on 16/1/20.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FPGiftwarePickerImageCellDelegate <NSObject>

- (void)getSelImage:(UIImage *)image;

@end

@interface FPGiftwarePickerImageCell : UICollectionViewCell

- (void)setImage:(UIImage *)img;

@property (assign, nonatomic) BOOL selectFlag;

@property (weak, nonatomic) id<FPGiftwarePickerImageCellDelegate> delegate;

@end
