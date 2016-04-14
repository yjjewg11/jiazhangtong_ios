//
//  DianzanNameShowView.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/12.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "DianzanNameShowView.h"

@implementation DianzanNameShowView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (void)loadData:(NSString *)rel_uuid type:(KGTopicType)type {
    self.rel_uuid=rel_uuid;
    self.type=type;
    [self.namesShowLbl setText:@"加载中..."];
    if(self.rel_uuid==nil){
        [MBProgressHUD showError:@"rel_uuid==nil"];
        return;
    }
    if(self.type==nil){
        [MBProgressHUD showError:@"type==nil"];
        return;
    }
    
    
    if(self.pageNo==nil)self.pageNo=1;
    if(self.currentTime==nil)self.currentTime=[KGDateUtil getQueryFormDateStringByDate:[KGDateUtil getLocalDate]];
    
    
    MBProgressHUD *hud=[MBProgressHUD showMessage:@"加载数据.."];
    hud.removeFromSuperViewOnHide=YES;
    [[KGHttpService sharedService] baseDian_queryNameByPage:self.rel_uuid type:self.type pageNo:[NSString stringWithFormat:@"%ld",self.pageNo] time:self.currentTime  success:^(PageInfoDomain * pageInfoDomain)
     {
         [hud hide:YES];

         NSArray * arr = [DianzanUserDomain objectArrayWithKeyValuesArray:pageInfoDomain.data];
         NSMutableArray * names=[NSMutableArray array];
         for (DianzanUserDomain * user in arr){
        
             [names addObject:user.username];
         }
         
         NSString * namesString=[names componentsJoinedByString:@","];
         
         NSString * str = [NSString stringWithFormat:@"%@等赞", namesString];
         if(arr.count==0){
             str=@"无人点赞";
         }
         NSRange range = [str rangeOfString:namesString];
         
         NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:str];
         
         [self.namesShowLbl setText:attString afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
             
             [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:KGColorFrom16(0xff4966) range:range];
             
             return mutableAttributedString;
         }];

     }
                                                       faild:^(NSString *errorMsg)
     {
         [hud hide:YES];

         [MBProgressHUD showError:errorMsg];
        
     }];
}

- (IBAction)btnClick:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)touchUpOutside:(id)sender {
     [self removeFromSuperview];
}
@end
