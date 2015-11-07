//
//  SPPresentsComment.h
//  kindergartenApp
//
//  Created by Mac on 15/11/2.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPCommentDomain.h"

@interface SPPresentsComment : UITableViewCell

@property (assign, nonatomic) CGFloat rowHeight;

@property (strong, nonatomic) SPCommentDomain * domain;

@end
