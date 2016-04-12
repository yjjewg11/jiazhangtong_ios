//
//  DianzanNameShowView.h
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/12.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGHttpService.h"
#import "MBProgressHUD+HM.h"
#import "KGHUD.h"
#import "KGDateUtil.h"
#import "MJExtension.h"
#import "DianzanUserDomain.h"

#import "UIColor+Extension.h"
#import "UIView+Extension.h"
#import "UIButton+Extension.h"
#import "KGNSStringUtil.h"
#import "KGRange.h"
#import "MLEmojiLabel.h"
@interface DianzanNameShowView : UIView
@property (strong,nonatomic) NSString *rel_uuid;
@property (nonatomic)  KGTopicType type;

@property (assign, nonatomic) NSInteger pageNo;
@property (strong, nonatomic) NSString * currentTime;
- (IBAction)touchUpOutside:(id)sender;

@property (weak, nonatomic) IBOutlet MLEmojiLabel *namesShowLbl;
- (IBAction)btnClick:(id)sender;


- (void)loadData:(NSString *)rel_uuid type:(KGTopicType)type;
@end
