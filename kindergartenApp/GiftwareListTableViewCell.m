//
//  GiftwareListTableViewCell.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/3/26.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "GiftwareListTableViewCell.h"
#import "DianzanNameShowView.h"

@interface GiftwareListTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *herald_imageView;
@property (weak, nonatomic) IBOutlet UILabel *subtitle_lable;
@property (weak, nonatomic) IBOutlet UILabel *reply_count_label;
@property (weak, nonatomic) IBOutlet UILabel *dianzan_count_label;
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (strong,nonatomic) FPMoive4QDomain *  domain1;

@end


@implementation GiftwareListTableViewCell
- (void)setDomain:(FPMoive4QDomain * )domain{
    self.domain1=domain;
    
    if([@"0" isEqualToString: domain.status]){
        [self.showStatusView setHidden:YES];

    }else{
        [self.showStatusView setHidden:NO];

    }
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
- (IBAction)touchInside_detail:(id)sender {
    
    [self.delegate touchInsideCell:self.domain1];
    

}
- (IBAction)touchInside_replyList:(id)sender {
//    [self.delegate touchInsideCellOfReply:self.domain1];
    
    NSInteger type=Topic_FPGiftware;
    
    NSDictionary * dic = @{@"rel_uuid" :_domain1.uuid, @"type" : [NSNumber numberWithInteger:type]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Key_Notification_ShowBaseReplyList object:self userInfo:dic];
}
- (IBAction)touchInside_dianzan:(id)sender {
    UIButton *button = (UIButton *)sender;
    
//    DianzanNameShowView * dianzan=[[DianzanNameShowView alloc]initWithFrame:CGRectMake(0, self.contentView.frame.size.height-44, self.contentView.frame.size.width, 44)];
    
    DianzanNameShowView * dianzan= [[[NSBundle mainBundle] loadNibNamed:@"DianzanNameShowView" owner:nil options:nil] firstObject];
//    float x=self.contentView.frame.size.width/2-280;
//    if(x<1)x=1;
//    float width=280;
//    if(self.contentView.frame.size.width<280){
//        width=self.contentView.frame.size.width;
//    }
    CGRect frame=self.bottomView.frame;
    frame.origin.x=1;
    frame.origin.y=1;
    
        [dianzan setFrame:frame];
//     [[self superview] addSubview:dianzan];
//    UILabel * dianzan=[[UILabel alloc]initWithFrame:CGRectMake(0, self.contentView.frame.size.height-44, 320, 44)];
//    dianzan.text=@"dfdfsdsdf";
//    [dianzan setBackgroundColor:[UIColor grayColor] ];
//    [self.contentView addSubview:dianzan];
    
    [self.bottomView addSubview:dianzan];

    [dianzan loadData:self.domain1.uuid type:Topic_FPGiftware];
}

@end
