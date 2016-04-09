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

+ (NSString *)getFFMovie_photo_uuids{
    NSArray * arr=[[FFMovieShareData getFFMovieShareData].selectDomainMap allValues];
    NSMutableArray *uuidsArr=[NSMutableArray array];
    for (FPImagePickerImageDomain * obj in arr) {
        
        if(obj.isSelect==YES){
            [uuidsArr addObject:obj.uuid];
        }
    }
  return [uuidsArr componentsJoinedByString:@","];
    
}


+ (FFMoiveSubmitView *)createBottomView:(UIView *) view
{
    FFMoiveSubmitView *_bottomView = [[[NSBundle mainBundle] loadNibNamed:@"FFMoiveSubmitView" owner:nil options:nil] firstObject];
    _bottomView.frame = CGRectMake(0, 22, APPWINDOWWIDTH, 44);
        _bottomView.frame = CGRectMake(0, view.size.height-44-64, APPWINDOWWIDTH, 44);
    //     _bottomView = [[FFMoiveSubmitView alloc]initWithFrame: CGRectMake(0, self.view.size.height-44-64, APPWINDOWWIDTH, 44)];
    CGRect frame =_bottomView.frame;
    NSLog(@"frame=%f,%f,%f,%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    [_bottomView setBackgroundColor:[UIColor blueColor ]];
    _bottomView.titleLbl.text = @"1/5:下一步";
    _bottomView.nextIndex=2-1;
 
    return _bottomView;
}

@end
