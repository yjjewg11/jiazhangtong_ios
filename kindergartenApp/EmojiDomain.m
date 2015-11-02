//
//  EmojiDomain.m
//  kindergartenApp
//
//  Created by You on 15/8/4.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "EmojiDomain.h"
#import "MJExtension.h"

@implementation EmojiDomain

//属性名映射
+(void)initialize{
    [super initialize];
    [self setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"descriptionUrl" : @"description"};
    }];
}

- (void)setDatavalue:(NSString *)datavalue {
    _datavalue = datavalue;
    _emojiName = [NSString stringWithFormat:@"[%@]", datavalue];
}

@end
