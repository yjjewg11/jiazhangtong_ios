//
//  FPTimeLineCommentCell.m
//  kindergartenApp
//
//  Created by Mac on 16/2/22.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPTimeLineCommentCell.h"
#import "UIImageView+WebCache.h"

@interface FPTimeLineCommentCell()

@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *content;

@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation FPTimeLineCommentCell

- (void)setData:(FPTimeLineCommentDomain *)domain
{
    [self.img sd_setImageWithURL:[NSURL URLWithString:domain.create_img] placeholderImage:[UIImage imageNamed:@"head_def"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.img setBorderWithWidth:2 color:[UIColor whiteColor] radian:self.img.width / Number_Two];
    }];
    
    self.name.text = domain.create_user;
    self.content.text = domain.content;
    self.time.text = domain.create_time;
}

@end
