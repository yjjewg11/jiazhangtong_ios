//
//  FFMoiveEditSubSelectPhotoVC.h
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/4.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPMoive4QDomain.h"
#import <UIKit/UIKit.h>
#import "FFMovieShareData.h"

@protocol FFMoiveEditSubSelectPhotoVCEndSelected <NSObject>
//数据变更后，通知对应对象
-(void)selectEndNoitce:(NSMutableDictionary *)selectDomainMap;

@end
@interface FFMoiveEditSubSelectPhotoVC : UIViewController
//@property (copy, nonatomic) FPMoive4QDomain * domain;
//@property (strong, nonatomic) NSMutableDictionary *
@property (strong, nonatomic) id< FFMoiveEditSubSelectPhotoVCEndSelected> delegate;



@end
