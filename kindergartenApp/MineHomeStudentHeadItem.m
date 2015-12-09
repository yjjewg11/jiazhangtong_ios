//
//  MineHomeStudentHeadItem.m
//  kindergartenApp
//
//  Created by Mac on 15/12/8.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "MineHomeStudentHeadItem.h"
#import "UIColor+flat.h"
#import "UIImageView+WebCache.h"
#import "UIColor+Extension.h"

@interface MineHomeStudentHeadItem()

@property (weak, nonatomic) IBOutlet UIImageView *header;

@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation MineHomeStudentHeadItem

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor colorWithHexCode:@"#FF6666"];
}

- (void)setData:(KGUser *)user
{
    self.name.text = user.name;
    
    [self.header sd_setImageWithURL:[NSURL URLWithString:user.headimg] placeholderImage:[UIImage imageNamed:@"head_def"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.header setBorderWithWidth:2 color:[UIColor whiteColor] radian:self.header.width / Number_Two];
    }];
    
}

@end
