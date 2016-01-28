//
//  FPImagePickerImageCell.h
//  kindergartenApp
//
//  Created by Mac on 16/1/28.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPImagePickerImageDomain.h"

@interface FPImagePickerImageCell : UICollectionViewCell

- (void)setData:(FPImagePickerImageDomain *)domain;

@property (assign, nonatomic) NSInteger index;

@end
