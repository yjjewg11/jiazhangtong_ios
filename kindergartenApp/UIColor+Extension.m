//
//  UIColor+MFColor.m
//  maifangbao
//
//  Created by whb on 15/5/24.
//  Copyright (c) 2015年 whb. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)


+ (UIColor *)themeNavBackColor {
    return KGColor(229, 229, 229, 1);
}


+ (UIColor *)themeNavWordColor {
    return KGColor(68, 68, 68, 1);
}


+ (UIColor *)themeSelGrayBorderColor{
    return KGColor(153, 153, 153, 1);
}


+ (UIColor *)themeLineColor{
    return KGColor(160, 160, 160, 1);
}


+ (UIColor *)themeColorSplite {
    return KGColorFrom16(0xDBDBDB);
}

//view bg
+ (UIColor *)themeColorViewBg {
    return KGColorFrom16(0xF0F0F0);
}

+ (UIColor *)themeColorText1 {
    return KGColorFrom16(0x333333);
}

+ (UIColor *)themeColorText2 {
    return KGColorFrom16(0xEC4D4D);
}


+ (UIColor *)themeColorBtnBg {
    return KGColorFrom16(0xD03D42);
}

@end
