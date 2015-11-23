//
//  MySPAllListHeaderView.h
//  kindergartenApp
//
//  Created by Mac on 15/11/18.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySPAllCouseListDomain.h"

@class MySPAllListHeaderView;
@protocol MySPAllListHeaderViewDelegate <NSObject>

- (void)viewBtnClick:(MySPAllListHeaderView *)view;

@end

@interface MySPAllListHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *courseCountLbl;

@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@property (weak, nonatomic) IBOutlet UILabel *courseNameLbl;

@property (weak, nonatomic) IBOutlet UIImageView *youjiantouLbl;

@property (weak, nonatomic) IBOutlet UIButton *btn;

- (void)setData:(MySPAllCouseListDomain *)domain row:(NSInteger)row;

@property (weak, nonatomic) id<MySPAllListHeaderViewDelegate> delegate;

@end
