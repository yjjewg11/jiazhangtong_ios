//
//  DiscorveryJingXuanCell.m
//  kindergartenApp
//
//  Created by Mac on 15/12/9.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "DiscorveryJingXuanCell.h"
#import "UIImageView+WebCache.h"
#import "MyUILabel.h"

@interface DiscorveryJingXuanCell()
{
    MyUILabel * _myTitleLbl;
    MyUILabel * _mySummaryLbl;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (weak, nonatomic) IBOutlet UILabel *dzLbl;

@property (weak, nonatomic) IBOutlet UILabel *summaryLbl;

@property (weak, nonatomic) IBOutlet UIImageView *img1;

@property (weak, nonatomic) IBOutlet UIImageView *img2;

@property (weak, nonatomic) IBOutlet UIImageView *img3;

@property (weak, nonatomic) IBOutlet UIView *imgsView;

@end

@implementation DiscorveryJingXuanCell

- (void)awakeFromNib
{
    _myTitleLbl = [[MyUILabel alloc] initWithFrame:CGRectMake(15, 15, KGSCREEN.size.width - 30, 40)];
    _myTitleLbl.backgroundColor = [UIColor whiteColor];
    _myTitleLbl.textAlignment = UITextAlignmentLeft;
    _myTitleLbl.numberOfLines = 2;
    _myTitleLbl.lineBreakMode = UILineBreakModeWordWrap;
    [_myTitleLbl setVerticalAlignment:VerticalAlignmentTop];
    [self addSubview:_myTitleLbl];
    
    _mySummaryLbl = [[MyUILabel alloc] initWithFrame:CGRectMake(70, 70, KGSCREEN.size.width - 70 - 15, 50)];
    _mySummaryLbl.backgroundColor = [UIColor whiteColor];
    _mySummaryLbl.textAlignment = UITextAlignmentLeft;
    _mySummaryLbl.numberOfLines = 3;
    _mySummaryLbl.lineBreakMode = UILineBreakModeWordWrap;
    [_mySummaryLbl setVerticalAlignment:VerticalAlignmentTop];
    [self addSubview:_mySummaryLbl];
}

- (void)setData:(DiscorveryReMenJingXuanDomain *)domain
{
    _myTitleLbl.text = domain.title;
    
    self.dzLbl.text = [NSString stringWithFormat:@"%ld",(long)domain.yes_count];
    self.dzLbl.layer.cornerRadius = 5;
    self.dzLbl.layer.masksToBounds = YES;
    
    _mySummaryLbl.text = domain.summary;
    
    for (NSInteger i=0; i<domain.imgsList.count; i++)
    {
        UIImageView * v = self.imgsView.subviews[i];
        
        [v sd_setImageWithURL:[NSURL URLWithString:domain.imgsList[i]] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    }
}

@end
