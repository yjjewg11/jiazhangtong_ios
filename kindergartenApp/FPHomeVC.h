//
//  FPHomeVC.h
//  kindergartenApp
//
//  Created by Mac on 16/1/13.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "BaseViewController.h"
static NSString *family_uuid = nil;

@interface FPHomeVC : BaseViewController
+(void) setFamily_uuid:(NSString *)str;
+(NSString *) getFamily_uuid;


@end
