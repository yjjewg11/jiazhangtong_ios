//
//  SPBottomItem.m
//  kindergartenApp
//
//  Created by Mac on 15/11/5.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SPBottomItem.h"

@interface SPBottomItem()


@end


@implementation SPBottomItem

- (void)setPic:(NSString *)name Title:(NSString *)title
{
    self.imgView.image = [UIImage imageNamed:name];
    
    self.titleLbl.text = title;
      [self.tipNumberLbl setHidden:YES];
}

- (void)setTipNumber:(NSInteger)count{
    if(count==0){
        [self.tipNumberLbl setHidden:YES];
      
        return;
    }
      [self.tipNumberLbl setHidden:NO];
    //count=999;
    self.tipNumberLbl.text=[NSString stringWithFormat:@"%d",count];
    
    //设置边缘弯曲角度
    self.tipNumberLbl.layer.cornerRadius =10;
    self.tipNumberLbl.clipsToBounds = YES;//（iOS7以后需要设置）
    
    float x=self.frame.size.width/2;
    if(x<0)x=0;
    [self.tipNumberLbl setFrame:CGRectMake(x, 5, 20, 20)];

}

@end
