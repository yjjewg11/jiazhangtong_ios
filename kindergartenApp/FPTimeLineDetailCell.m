//
//  FPTimeLineDetailCell.m
//  kindergartenApp
//
//  Created by Mac on 16/2/18.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPTimeLineDetailCell.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"

@interface FPTimeLineDetailCell()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) UIView * infoView;
@property (strong, nonatomic) UILabel * nameLbl;
@property (strong, nonatomic) UIImageView * addressIcon;
@property (strong, nonatomic) UILabel * addressLbl;
@property (strong, nonatomic) UIImageView * personIcon;
@property (strong, nonatomic) UILabel * personLbl;
@property (strong, nonatomic) UIView * commmentView;
@property (strong, nonatomic) UIView * sepView;
@property (strong, nonatomic) UILabel * loadingLbl;

@end

@implementation FPTimeLineDetailCell

- (void)awakeFromNib
{
    //创建imageView
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, APPWINDOWWIDTH - 20, 500)];
    
    //创建infoview
    self.infoView = [[UIView alloc] init];
    self.infoView.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 10, APPWINDOWWIDTH, 90);
    
    self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, APPWINDOWWIDTH-20, 20)];
    self.nameLbl.font = [UIFont systemFontOfSize:17];
    self.nameLbl.textColor = [UIColor darkGrayColor];
    [self.infoView addSubview:self.nameLbl];
    
    self.addressIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 15, 17)];
    self.addressIcon.image = [UIImage imageNamed:@"fp_location"];
    [self.infoView addSubview:self.addressIcon];
    
    self.addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(32, 25, APPWINDOWWIDTH - 42, 17)];
    self.addressLbl.font = [UIFont systemFontOfSize:14];
    self.addressLbl.textColor = [UIColor brownColor];
    [self.infoView addSubview:self.addressLbl];
    
    self.personIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 47, 15, 17)];
    self.personIcon.image = [UIImage imageNamed:@"fp_ren"];
    [self.infoView addSubview:self.personIcon];
    
    self.personLbl = [[UILabel alloc] initWithFrame:CGRectMake(32, 47, APPWINDOWWIDTH - 42, 17)];
    self.personLbl.text = @"未知";
    self.personLbl.font = [UIFont systemFontOfSize:14];
    self.personLbl.textColor = [UIColor brownColor];
    [self.infoView addSubview:self.personLbl];
    
    //创建最新评论view
    self.commmentView = [[UIView alloc] init];
    self.commmentView.frame = CGRectMake(0, CGRectGetMaxY(self.infoView.frame), APPWINDOWWIDTH, 80);
    
    self.sepView = [[UIView alloc] init];
    self.sepView.frame = CGRectMake(0, 5, APPWINDOWWIDTH, 1);
    self.sepView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.commmentView addSubview:self.sepView];
    
    self.loadingLbl = [[UILabel alloc] initWithFrame:CGRectMake((APPWINDOWWIDTH / 2)-90, 20, 180, 20)];
    self.loadingLbl.font = [UIFont systemFontOfSize:15];
    self.loadingLbl.text = @"最新评论拼命加载中...";
    [self.commmentView addSubview:self.loadingLbl];
    
    //添加到scrollview
    self.scrollView.frame = CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64 - 49);
    [self.scrollView addSubview:self.imageView];
    [self.scrollView addSubview:self.infoView];
    [self.scrollView addSubview:self.commmentView];
    [self.scrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(self.commmentView.frame))];
}

- (void)setData:(FPFamilyPhotoNormalDomain *)domain
{
    self.scrollView.hidden = YES;
    
    [self calImageViewHeight:domain success:^(CGFloat height)
    {
        self.imageView.height = height;
        [self.infoView setOrigin:CGPointMake(0, CGRectGetMaxY(self.imageView.frame) + 10)];
        [self.commmentView setOrigin:CGPointMake(0, CGRectGetMaxY(self.infoView.frame))];
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[[domain.path componentsSeparatedByString:@"@"] firstObject]]];
        
        self.nameLbl.text = @"未知";

        [domain.address stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (domain.address == nil || [domain.address isEqualToString:@""])
        {
            self.addressLbl.text = @"未知";
        }
        
        self.scrollView.hidden = NO;
    }
    faild:^(NSString *errorMsg)
    {
         //按照一个大小设置imageView
    }];
}

- (void)setComment:(FPTimeLineDetailCommentDomain *)comment
{
    
}

- (void)calImageViewHeight:(FPFamilyPhotoNormalDomain *)domain success:(void(^)(CGFloat height))success faild:(void(^)(NSString * errorMsg))faild
{
    NSString * path = [[domain.path componentsSeparatedByString:@"@"] firstObject];
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:path] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize)
    {
        
    }
    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
    {
         if (error)
         {
             NSLog(@"%@",error.debugDescription);
         }
         if (image)
         {
             [[SDImageCache sharedImageCache] storeImage:image forKey:[[domain.path componentsSeparatedByString:@"@"] firstObject] toDisk:YES];
             
             CGFloat imgW = image.size.width;
             CGFloat imgH = image.size.height;
             
             //计算宽度压缩了还是拉伸了
             CGFloat widthBiZhi = (APPWINDOWWIDTH - 20) / imgW;
             if (widthBiZhi >= 1) //直接按照这个比例设定imageview的高度,也就是图片本身的imgH
             {
                 success(imgH);
             }
             else //高度按照这个比例相应缩小
             {
                 success(imgH * widthBiZhi);
             }
         }
    }];
}

@end
