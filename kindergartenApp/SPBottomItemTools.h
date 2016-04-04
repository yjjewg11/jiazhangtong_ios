//
//  SPBottomItemTools.h
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/4.
//  Copyright © 2016年 funi. All rights reserved.
//
//创建底部多个按钮
#import <Foundation/Foundation.h>





@interface SPBottomItemTools : NSObject


+(NSMutableArray *)createBottoms:(UIView *)view imageName:(NSArray *) imageName titleName:(NSArray *) titleName addTarget:(id )target action:(SEL)action;
@end
