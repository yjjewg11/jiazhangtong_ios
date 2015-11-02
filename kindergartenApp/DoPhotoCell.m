//
//  DoPhotoCell.m
//  DoImagePickerController
//
//  Created by Donobono on 2014. 1. 23..
//

#import "DoPhotoCell.h"

@implementation DoPhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelectMode:(BOOL)bSelect
{
    if (bSelect) {
//        _ivPhoto.alpha = 0.2;
        _vSelectedImageView.image = [UIImage imageNamed:@"xuanzhong"];
    } else {
//        _ivPhoto.alpha = 1.0;
        _vSelectedImageView.image = [UIImage imageNamed:@"moren"];
    }
}



@end
