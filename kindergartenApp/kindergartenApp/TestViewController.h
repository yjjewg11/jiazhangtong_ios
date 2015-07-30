//
//  TestViewController.h
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/14.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "KGReFreshViewDelegate.h"
#import "ReFreshTableViewController.h"

@interface TestViewController : BaseViewController <KGReFreshViewDelegate> {
//    FuniReFreshView * reFreshView;
    ReFreshTableViewController * reFreshView;
}

@end
