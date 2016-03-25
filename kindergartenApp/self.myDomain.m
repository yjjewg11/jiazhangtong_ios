//
//  PickImgDayHeadView.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/3/25.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "PickImgDayHeadView.h"
@interface PickImgDayHeadView()
@property (weak, nonatomic) IBOutlet UIImageView *selImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (weak,nonatomic)  NSString *data1;
@property  bool isSelect;

@end

@implementation PickImgDayHeadView

- (IBAction)SelImgButtonClick:(id)sender{
    self.isSelect=!self.isSelect;
    [self setData:self.data1 checked:self.isSelect];
    [self.delegate clickAction_selImg:self.data1 checked:self.isSelect];
}

- (void)setData:(NSString *)title checked:(BOOL)checked{
   // title=@"aaaaa";
    self.titleLabel.text=title;
    self.data1=title;
    self.isSelect=checked;
    if (self.isSelect == YES)
    {
        self.selImg.image = [UIImage imageNamed:@"icon_image_yes"];
    }
    else
    {
        self.selImg.image = [UIImage imageNamed:@"icon_image_no"];
    }
}
- (void)awakeFromNib {
   
}


@end
