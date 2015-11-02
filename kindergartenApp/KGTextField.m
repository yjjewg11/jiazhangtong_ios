//
//  DemoTextField.m
//  MHTextField
//
//  Created by Mehfuz Hossain on 12/3/13.
//  Copyright (c) 2013 Mehfuz Hossain. All rights reserved.
//

#import "KGTextField.h"
#import "KGFormVerify.h"
#import "SystemResource.h"
#import "KGNSStringUtil.h"

@implementation KGTextField

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setTextFielParam];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self setTextFielParam];
    }
    return self;
}


- (void)setTextFielParam {
    [self setBorderStyle:UITextBorderStyleNone];
    [self setTintColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
    //    [self setBackgroundColor:[UIColor whiteColor]];
    //    self.returnKeyType            = UIReturnKeyNext;
    self.autocapitalizationType   = UITextAutocapitalizationTypeNone;
    self.textAlignment            = NSTextAlignmentLeft;
    self.borderStyle              = UITextBorderStyleNone;
    self.clearButtonMode          = UITextFieldViewModeWhileEditing;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    self.textColor                = [UIColor whiteColor];
}


- (void) drawPlaceholderInRect:(CGRect)rect {
    rect.origin.y += 7;
    [self.placeholder drawInRect:rect withAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1.0],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
}


//控制placeHolder的位置，左右缩20
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    
    //return CGRectInset(bounds, 20, 0);
    CGRect inset = CGRectMake(bounds.origin.x+5, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
    return inset;
}

//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    //return CGRectInset(bounds, 50, 0);
    CGRect inset = CGRectMake(bounds.origin.x+5, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
    
    return inset;
    
}

//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    //return CGRectInset( bounds, 10 , 0 );
    
    CGRect inset = CGRectMake(bounds.origin.x +5, bounds.origin.y, bounds.size.width -10, bounds.size.height);
    return inset;
}


/**
 *  验证文本框
 *
 *  @return 返回是否验证通过
 */
- (BOOL)verifyTextField {
    BOOL judge = [self verifyTextFieldNoMessage];
    if(!judge){
        [self notification];
    }
    return judge;
}

/**
 *  验证文本框(不显示验证失败messageView)
 *
 *  @return 返回是否验证通过
 */
- (BOOL)verifyTextFieldNoMessage {
    BOOL judge = NO;
    switch (self.textFielType) {
        case KGTextFielType_Empty:
            judge = [self isPlaceholderStr];
            break;
        case KGTextFielType_EMail:
            judge = [KGFormVerify isValidateEmail:self.text];
            break;
        case KGTextFielType_Card:
            judge = [KGFormVerify validateIdentityCard:self.text];
            break;
        case KGTextFielType_Phone:
            judge = [KGFormVerify validateMobile:self.text];
            break;
        case KGTextFielType_Number:
            judge = [KGNSStringUtil isPureInt:self.text];
            break;
        case KGTextFielType_Length:
            if(self.minLength != Number_Zero && self.maxLength != Number_Zero){
                if([self.text length]>=self.minLength && [self.text length]<=self.maxLength){
                    judge = YES;
                }
            }else{
                judge = YES;
            }
            break;
        default:
            judge = YES;
            break;
    }
    return judge;
}


/**
 *  判断输入框文本是否=placeholder值
 *
 *  @return 返回是否相等
 */
- (BOOL)isPlaceholderStr {
    if([KGNSStringUtil isEmpty:self.text]) {
        return NO;
    }else {
        return ![self.text isEqualToString:self.placeholder];
    }
}

- (void)notification{
    NSDictionary * dic = [NSDictionary dictionaryWithObject:self.messageStr forKey:Key_Notification_MessageText];
    [[NSNotificationCenter defaultCenter]postNotificationName:Key_Notification_Message object:self userInfo:dic];
}

@end
