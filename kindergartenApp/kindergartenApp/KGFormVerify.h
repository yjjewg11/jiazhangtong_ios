//
//  FuniFormVerify.h
//  funiiPhoneApp
//
//  Created by You on 13-11-13.
//  Copyright (c) 2013年 LQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGFormVerify : NSObject

+ (BOOL)validateMobile:(NSString *)mobileNum;

+ (BOOL)isValidateEmail:(NSString *)email;

/**
 *  是否是身份证号
 *
 *  @param identityCard 需要验证的文本
 *
 *  @return 返回是否是身份证号
 */
+ (BOOL)validateIdentityCard:(NSString *)identityCard;


@end
