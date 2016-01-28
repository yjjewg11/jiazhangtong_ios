//
//  FPImagePickerGroupTableCell.m
//  kindergartenApp
//
//  Created by Mac on 16/1/28.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPImagePickerGroupTableCell.h"

@interface FPImagePickerGroupTableCell()

@property (weak, nonatomic) IBOutlet UIImageView *plImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

@property (weak, nonatomic) IBOutlet UILabel *countLbl;

@end

@implementation FPImagePickerGroupTableCell

- (void)setData:(ALAssetsGroup *)group
{
    self.plImg.image = [UIImage imageWithCGImage:group.posterImage];
    
    self.nameLbl.text = [group valueForProperty:@"ALAssetsGroupPropertyName"];
    
    self.countLbl.text = [NSString stringWithFormat:@"(%ld)",(long)group.numberOfAssets];
}

@end
