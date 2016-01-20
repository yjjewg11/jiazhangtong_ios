//
//  FPGifrwarePickerVC.m
//  kindergartenApp
//
//  Created by Mac on 16/1/20.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPGifrwarePickerVC.h"
#import "FPGiftwarePickerLayout.h"
#import "FPGiftwarePickerImageCell.h"
#import "FPGiftwarePickerTakePhotoCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface FPGifrwarePickerVC () <UICollectionViewDataSource,UICollectionViewDelegate,FPGiftwarePickerImageCellDelegate>
{
    UICollectionView * _collectionView;
    NSMutableArray * _images;
}

@end

@implementation FPGifrwarePickerVC

static NSString *const ImageID = @"imagecoll";
static NSString *const CamaraID = @"camaracoll";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"选择图片";
    
    _images = [NSMutableArray array];
    
    [self reloadImagesFromLibrary];
    
    [self initCollectionView];
}

- (void)initCollectionView
{
    FPGiftwarePickerLayout * layout = [[FPGiftwarePickerLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64 - 49) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor darkGrayColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"FPGiftwarePickerImageCell" bundle:nil] forCellWithReuseIdentifier:ImageID];

    [self.view addSubview:_collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1 + _images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FPGiftwarePickerImageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageID forIndexPath:indexPath];
    cell.delegate = self;
    [cell setImage:_images[indexPath.row]];
    return cell;
}

//获取相册的所有图片
- (void)reloadImagesFromLibrary
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        ALAssetsLibrary * assetsLibrary;
        assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop)
         {
             if (group)
             {   //通过这个可以知道相册的名字，从而也可以知道安装的部分应用
                 //例如 Name:柚子相机, Type:Album, Assets count:1
//                 NSLog(@"%@",group);
                 
                 NSString * info = (NSString *)group.description;
                 NSArray * stringArr = [info componentsSeparatedByString:@":"];
                 
                 __block NSInteger i = 1;
                 if (![[stringArr lastObject] isEqualToString:@"0"] || stringArr != nil)
                 {
                     [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
                     {
                          if (result)
                          {
                              [_images addObject:[UIImage imageWithCGImage:result.thumbnail]];
                              
                              if ([[NSString stringWithFormat:@"%ld",(long)i] isEqualToString:[stringArr lastObject]])
                              {
                                  dispatch_async(dispatch_get_main_queue(), ^
                                  {
                                      [_collectionView reloadData];
                                  });
                              }
                              i++;
                          }
                      }];
                 }
                 else if ([[stringArr lastObject] isEqualToString:@"0"])
                 {
                     dispatch_async(dispatch_get_main_queue(), ^
                     {
                         [_collectionView reloadData];
                     });
                 }
             }
         }failureBlock:^(NSError *error)
         {
             NSLog(@"Group not found!\n");
         }];
    });

//    //获取资源图片的详细资源信息
//    ALAssetRepresentation* representation = [asset defaultRepresentation];
//    //获取资源图片的长宽
//    CGSize dimension = [representation dimensions];
//    //获取资源图片的高清图
//    [representation fullResolutionImage];
//    //获取资源图片的全屏图
//    [representation fullScreenImage];
//    //获取资源图片的名字
//    NSString* filename = [representation filename];
//    NSLog(@"filename:%@",filename);
//    //缩放倍数
//    [representation scale];
//    //图片资源容量大小
//    [representation size];
//    //图片资源原数据
//    [representation metadata];
//    //旋转方向
//    [representation orientation];
//    //资源图片url地址，该地址和ALAsset通过ALAssetPropertyAssetURL获取的url地址是一样的
//    NSURL* url = [representation url];
//    NSLog(@"url:%@",url);
//    //资源图片uti，唯一标示符
//    NSLog(@"uti:%@",[representation UTI]);
}

- (void)getSelImage:(UIImage *)image
{
    
}

@end

