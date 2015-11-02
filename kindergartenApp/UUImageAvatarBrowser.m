//
//  UUAVAudioPlayer.m
//  BloodSugarForDoc
//
//  Created by shake on 14-9-1.
//  Copyright (c) 2014年 shake. All rights reserved.
//

#import "UUImageAvatarBrowser.h"
#import "UIImageView+WebCache.h"

static UIImageView *orginImageView;
@implementation UUImageAvatarBrowser

+(void)showImage:(UIImageView *)avatarImageView url:(NSString *)imgUrl{
    UIImage *image=avatarImageView.image;
    orginImageView = avatarImageView;
    orginImageView.alpha = 0;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    CGRect oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.7];
    backgroundView.alpha=1;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.tag=1;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    
    if(imgUrl && ![imgUrl isEqualToString:String_DefValue_Empty]) {
        
        NSArray * array = [imgUrl componentsSeparatedByString:@"@"];
        if(array && [array count]>Number_Zero) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:[array objectAtIndex:Number_Zero]] placeholderImage:image options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
        }
        
    } else {
        imageView.image=image;
    }
    
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

+(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=[orginImageView convertRect:orginImageView.bounds toView:[UIApplication sharedApplication].keyWindow];
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        orginImageView.alpha = 1;
//        backgroundView.alpha=0;
    }];
}
@end
