//
//  FuniAttachment.m
//  funiApp
//
//  Created by You on 13-6-18.
//  Copyright (c) 2013年 you. All rights reserved.
//

#import "KGAttachment.h"

@implementation KGAttachment


- (id)initAttachment:(NSString *)cover{
    self = [super init];
    if(self){
        _path = cover;
    }
return self;
}
@end
