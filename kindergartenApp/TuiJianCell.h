//
//  TuiJianCell.h
//  kindergartenApp
//
//  Created by Mac on 15/12/8.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscorveryMeiRiTuiJianDomain.h"

@protocol TuiJianCellDelegate <NSObject>

- (void)openTuiJianWebView:(NSString *)url;

@end

@interface TuiJianCell : UICollectionViewCell

- (void)setData:(DiscorveryMeiRiTuiJianDomain *)domain;

@property (weak, nonatomic) id<TuiJianCellDelegate> delegate;

@end
