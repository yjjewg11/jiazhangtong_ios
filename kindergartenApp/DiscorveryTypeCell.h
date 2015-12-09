//
//  DiscorveryTypeCell.h
//  kindergartenApp
//
//  Created by Mac on 15/12/8.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscorveryNewNumberDomain.h"

@protocol DiscorveryTypeCellDelegate <NSObject>

- (void)pushToVC:(UIButton *)btn;

@end

@interface DiscorveryTypeCell : UICollectionViewCell

- (void)setData:(DiscorveryNewNumberDomain *)domain;

@property (weak, nonatomic) id<DiscorveryTypeCellDelegate> delegate;

@end
