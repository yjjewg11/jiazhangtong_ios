//
//  EmojiDomain.h
//  kindergartenApp
//  表情
//  Created by You on 15/8/4.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "KGBaseDomain.h"

@interface EmojiDomain : KGBaseDomain


@property (strong, nonatomic) NSString * datavalue;      //server表情显示名
@property (strong, nonatomic) NSString * descriptionUrl; //表情url全地址.
@property (strong, nonatomic) NSString * emojiName;      //表情显示名   [datavalue]
@property (strong, nonatomic) NSString * emojiPath;     //表情笨蛋路径.

@end
