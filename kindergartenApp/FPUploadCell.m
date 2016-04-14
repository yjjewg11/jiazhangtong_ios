//
//  FPUploadCell.m
//  kindergartenApp
//
//  Created by Mac on 16/1/20.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPUploadCell.h"

@interface FPUploadCell()

@property (weak, nonatomic) IBOutlet UIImageView * suoluetu;

@property (weak, nonatomic) IBOutlet UIImageView * statusView;

@property (strong, nonatomic) NSURL * localUrl;

@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@end

@implementation FPUploadCell

- (void)awakeFromNib
{
    self.progress.progress = 0;
    
//    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
//    [center addObserver:self selector:@selector(updateProgress:) name:@"uploadprogress" object:nil];
}

- (void)setPercent:(float)percent
{
    self.progress.progress = percent;
}

- (void)setStatus:(NSInteger)status
{
    _status = status;
    
    if (status == 1) //等待上传
    {   
        self.statusView.hidden = NO;
        self.statusView.image = [UIImage imageNamed:@"dengdai"];
    }
    else if (status == 2) //上传中
    {
        self.statusView.hidden = NO;
        
         self.statusView.image = [UIImage imageNamed:@"fp_pause"];
      
    }
    else if (status == 3) //上传失败
    {
        self.statusView.hidden = NO;
        self.statusView.image = [UIImage imageNamed:@"shibai"];
    }
    else //上传成功
    {
        self.statusView.hidden = YES;
    }
}

- (void)setData:(FPFamilyPhotoUploadDomain *)domain
{
    self.status = domain.status;
    self.localUrl = domain.localurl;
    
    
    ALAssetsLibrary *_library=[UploadPhotoToRemoteService defaultAssetsLibrary];
    if(domain.suoluetu==nil){
        [_library assetForURL:domain.localurl resultBlock:^(ALAsset *asset)
         {
             
             if(asset!=nil){
                 domain.suoluetu = [UIImage imageWithCGImage:[asset thumbnail]];
                 
                 self.suoluetu.image = domain.suoluetu;
             }
            
             
         }
                 failureBlock:^(NSError *error)
         {
             NSLog(@"获取列表数据拉");
         }];

    }else{
          self.suoluetu.image = domain.suoluetu;
    }
    
  
}

- (IBAction)btnClick:(id)sender
{
    if (self.status == 1) //通知 vc 开始上传
    {
        [self setStatus:2];
     
        NSNotification * noti = [[NSNotification alloc] initWithName:@"startupload" object:@(self.index) userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
    }
    else if (self.status == 3) //通知 vc 开始上传
    {
        [self setStatus:2];
        
        NSNotification * noti = [[NSNotification alloc] initWithName:@"startupload" object:@(self.index) userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
    }
    else
    {
        return;
    }
}

@end
