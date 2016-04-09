//
//  GiftwareListTableViewCell.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/3/26.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "GiftwareListTableViewCell.h"
@interface GiftwareListTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *herald_imageView;
@property (weak, nonatomic) IBOutlet UILabel *subtitle_lable;
@property (weak, nonatomic) IBOutlet UILabel *reply_count_label;
@property (weak, nonatomic) IBOutlet UILabel *dianzan_count_label;
@property (weak, nonatomic) IBOutlet UILabel *title_label;



@end


@implementation GiftwareListTableViewCell
- (void)setDomain:(FPMoive4QDomain * )domain{
    
    
    NSURL *imageUrl = [NSURL URLWithString:domain.herald];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    
    self.herald_imageView.clipsToBounds = YES;
   
    self.herald_imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.herald_imageView.image = image;
    
    
//    self.herald_imageView.frame = CGRectMake(0, 0, 320, 190);
//    
    
    
    self.title_label.text=domain.title;
    NSString * dt1=[[domain.create_time componentsSeparatedByString:@" "] firstObject];
    self.subtitle_lable.text=[NSString stringWithFormat:@"%@制作于%@,共%d张照片",domain.create_username,dt1,domain.photo_count];
    
    self.reply_count_label.text=[NSString stringWithFormat:@"%d",domain.reply_count ];
    
    NSDictionary * dic =domain.dianZan;
    NSNumber * dianzancount=[dic  valueForKey :@"dianzan_count"];
    
//    self.dianzan_count_label.text=dianzancount;
     self.dianzan_count_label.text=[NSString stringWithFormat:@"%d",[dianzancount integerValue] ];
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
