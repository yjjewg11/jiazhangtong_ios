//
//  UIColor+MFColor.h
//  maifangbao
//
//  Created by whb on 15/5/24.
//  Copyright (c) 2015年 whb. All rights reserved.
//

#import <UIKit/UIKit.h>

// RGB颜色
#define KGColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

// 16进制颜色
#define KGColorFrom16(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 随机色
#define KGRandomColor KGColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

//清除背景色
#define CLEARCOLOR [UIColor clearColor]

@interface UIColor (Extension)

+ (UIColor *)themeNavBackColor;

+ (UIColor *)themeNavWordColor;

+ (UIColor *)themeSelGrayBorderColor;

+ (UIColor *)themeLineColor;

+ (UIColor *)themeColorSplite;

+ (UIColor *)themeColorViewBg;

+ (UIColor *)themeColorText1;

+ (UIColor *)themeColorText2;

+ (UIColor *)themeColorBtnBg;

@end
