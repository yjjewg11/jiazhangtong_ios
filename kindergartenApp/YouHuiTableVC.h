//
//  YouHuiTableVC.h
//  kindergartenApp
//
//  Created by Mac on 15/11/7.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YouHuiTableVC;

@protocol YouHuiTableVCDelegate <NSObject>

- (void)pushToDetailVC:(YouHuiTableVC *)tableVC data:(NSString *)uuid;

@end

@interface YouHuiTableVC : UITableViewController

@property (assign, nonatomic) CGRect tableRect;

@property (strong, nonatomic) NSMutableArray * dataArr;

@property (weak, nonatomic) id<YouHuiTableVCDelegate> delegate;

@end
