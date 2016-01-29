//
//  FPUploadCell.m
//  kindergartenApp
//
//  Created by Mac on 16/1/20.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPUploadCell.h"

@interface FPUploadCell()

@property (weak, nonatomic) IBOutlet UIImageView *suoluetu;

@property (weak, nonatomic) IBOutlet UIImageView *statusView;

@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@property (assign, nonatomic) NSInteger status;

@property (strong, nonatomic) NSURL * localUrl;

@end

@implementation FPUploadCell

- (void)awakeFromNib
{
    self.progress.progress = 0;
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(updateProgress:) name:@"uploadprogress" object:nil];
}

- (void)setData:(FPFamilyPhotoUploadDomain *)domain
{
    self.status = domain.status;
    self.localUrl = domain.localurl;
    
    if (domain.status == 1) //等待上传
    {
        self.statusView.hidden = NO;
        self.statusView.image = [UIImage imageNamed:@"dengdai"];
    }
    else if (domain.status == 2) //上传中
    {
        self.statusView.hidden = YES;
    }
    else if (domain.status == 3) //上传失败
    {
        self.statusView.hidden = NO;
        self.statusView.image = [UIImage imageNamed:@"shibai"];
    }
    else //上传成功
    {
        self.statusView.hidden = YES;
        //通知移除
    }
    
    self.suoluetu.image = domain.suoluetu;
}

- (void)updateProgress:(NSNotification *)noti
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
       self.progress.progress = [noti.object floatValue];
    });
}

- (IBAction)btnClick:(id)sender
{
    if (self.status == 1) //通知 vc 开始上传
    {
        self.statusView.hidden = YES;
        
        NSNotification * noti = [[NSNotification alloc] initWithName:@"startupload" object:@(self.index) userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
        
        self.status = 2;
    }
    else if (self.status == 3) //通知 vc 开始上传
    {
        self.statusView.hidden = YES;
        
        NSNotification * noti = [[NSNotification alloc] initWithName:@"startupload" object:@(self.index) userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
        
        self.status = 2;
    }
    else
    {
        return;
    }
}

- (void)dealloc
{
    NSLog(@" cell  delloc --- ");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
