//
//  FuniAttachment.h
//  funiApp
//  图片资源
//  Created by You on 13-6-18.
//  Copyright (c) 2013年 you. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KGBaseDomain.h"

@interface KGAttachment : KGBaseDomain

@property(strong, nonatomic) NSString * name;
@property(strong, nonatomic) NSString * relType;        //所属分类 大写
@property(strong, nonatomic) NSString * attachmentType; //所属分类 小写
@property(strong, nonatomic) NSString * path;
@property(strong, nonatomic) NSString * fileType;
@property (strong, nonatomic) UIImage * image;
@property (strong, nonatomic) NSString * imageUrl;

- (id)initAttachment:(NSString *)cover;

@end
