//
//  RecipesHeadTableViewCell.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/3.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipesHeadTableViewCell : UITableViewCell {
    
    IBOutlet UILabel * headLabel;
}

- (void)resetHead:(NSString *)headStr;

@end
