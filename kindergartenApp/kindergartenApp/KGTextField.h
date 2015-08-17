//
//  KGTextField.h
//
//  Created by You on 13-7-25.
//  Copyright (c) 2013年 LQ. All rights reserved.
//

#import <Foundation/Foundation.h>

//定义文本框类型
typedef enum {
    KGTextFielType_Empty      = 1,//空
	KGTextFielType_EMail      = 2,//eMail
    KGTextFielType_Card       = 3,//身份证
    KGTextFielType_Phone      = 4,//电话
    KGTextFielType_Number     = 5,//数字
    KGTextFielType_Length     = 6 //长度
}KGTextFielType;

@interface KGTextField : UITextField


@property (strong, nonatomic) NSString         * placeholderStr;
@property (strong, nonatomic) NSString         * messageStr;
@property (assign, nonatomic) KGTextFielType   textFielType;//有值则属于必填
@property (assign, nonatomic) NSInteger        minLength;
@property (assign, nonatomic) NSInteger        maxLength;

/**
 *  验证文本框
 *
 *  @return 返回是否验证通过
 */
- (BOOL)verifyTextField;

/**
 *  验证文本框(不显示验证失败messageView)
 *
 *  @return 返回是否验证通过
 */
- (BOOL)verifyTextFieldNoMessage;

@end
