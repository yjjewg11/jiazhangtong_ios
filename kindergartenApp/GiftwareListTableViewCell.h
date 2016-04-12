//
//  GiftwareListTableViewCell.h
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/3/26.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FPMoive4QDomain.h"


@protocol GiftwareListTableViewCellDelegate <NSObject>

- (void)touchInsideCell:(FPMoive4QDomain * )domain;
//- (void)touchInsideCellOfReply:(FPMoive4QDomain * )domain;
@end

@interface GiftwareListTableViewCell : UITableViewCell
- (void)setDomain:(FPMoive4QDomain * )domain;

@property   id<GiftwareListTableViewCellDelegate> delegate;

@end
