//
//  FFMovieShareData.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/5.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FFMovieShareData.h"

@implementation FFMovieShareData

+ (FFMovieShareData *)getFFMovieShareData
{
    static dispatch_once_t pred = 0;
    static FFMovieShareData * service = nil;
    dispatch_once(&pred,^
                  {
                      service = [[FFMovieShareData alloc] init];
                  });
    return service;
}
@end
