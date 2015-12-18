//
//  TuiJianCell.m
//  kindergartenApp
//
//  Created by Mac on 15/12/8.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "TuiJianCell.h"

@interface TuiJianCell()
{
    NSString * _url;
}
@property (weak, nonatomic) IBOutlet UILabel *summary;


@end

@implementation TuiJianCell

- (void)awakeFromNib
{
    
}

- (void)setData:(DiscorveryMeiRiTuiJianDomain *)domain
{
    self.summary.text = domain.title;
    _url = domain.url;
}

- (IBAction)btnClicked:(id)sender
{
    [self.delegate openTuiJianWebView:_url];
}
@end
