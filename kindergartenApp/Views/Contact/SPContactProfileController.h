//
//  SPContactProfileController.h
//  WXOpenIMSampleDev
//
//  Created by sidian on 15/11/24.
//  Copyright © 2015年 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBarButtonItem+BlockSupport.h"

@class YWPerson, YWIMKit;

@interface SPContactProfileController : UIViewController

- (id)initWithContact:(YWPerson *)contact IMKit:(YWIMKit *)imkit;

@end
