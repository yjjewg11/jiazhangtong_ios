//
//  MineHomeStudentHeadItem.h
//  kindergartenApp
//
//  Created by Mac on 15/12/8.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGUser.h"

@interface MineHomeStudentHeadItem : UIView

- (void)setData:(KGUser *)user;

@property (weak, nonatomic) IBOutlet UIButton *btn;

@end
