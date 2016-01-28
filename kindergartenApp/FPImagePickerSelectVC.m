//
//  FPImagePickerSelectVC.m
//  kindergartenApp
//
//  Created by Mac on 16/1/28.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPImagePickerSelectVC.h"
#import "FPImagePickerSelectLayout.h"
#import "FPImagePickerImageCell.h"
#import "FPImagePickerImageDomain.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface FPImagePickerSelectVC () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView * _collectionView;
    
    NSMutableArray * _domains;
    
    NSMutableDictionary * _selectIndexPath;
}

@end

@implementation FPImagePickerSelectVC

static NSString *const ImageCell = @"ImageCellID";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"选择图片";
    
    _selectIndexPath = [NSMutableDictionary dictionary];
    
    //处理数据
    [self execDatas];
    
    [self initCollectionView];
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(selectPhoto:) name:@"selectphoto" object:nil];
    [center addObserver:self selector:@selector(deSelectPhoto:) name:@"deselectphoto" object:nil];
    [center addObserver:self selector:@selector(showBigPhoto:) name:@"showbigphoto" object:nil];
}

- (void)initCollectionView
{
    if (_collectionView == nil)
    {
        FPImagePickerSelectLayout * layout = [[FPImagePickerSelectLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - 49 - 64) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"FPImagePickerImageCell" bundle:nil] forCellWithReuseIdentifier:ImageCell];
        
        [self.view addSubview:_collectionView];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FPImagePickerImageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCell forIndexPath:indexPath];
    
    cell.index = indexPath.row;
    
    [cell setData:_domains[indexPath.row]];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _domains.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)execDatas
{
    _domains = [NSMutableArray array];
    
    NSLog(@"总共有:%d张",self.totalCount);
    
    [self.group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
    {
        if (index < self.totalCount)
        {
            NSString * type = [result valueForProperty:@"ALAssetPropertyType"];
            
            if ([type isEqualToString:ALAssetTypePhoto])
            {
                NSURL * localUrl = [[result defaultRepresentation] url];
                
                //根据localUrl 去数据库找，看有没有已经上传了的，如果有标记一下
                FPImagePickerImageDomain * imgDomain = [[FPImagePickerImageDomain alloc] init];
                imgDomain.localUrl = localUrl;
                imgDomain.suoluetu = [UIImage imageWithCGImage:[result thumbnail]];
                imgDomain.dateStr = [result valueForProperty:@"ALAssetPropertyDate"];
                imgDomain.isUpload = NO;
                imgDomain.isSelect = NO;
                [_domains addObject:imgDomain];
                
                if (index + 1 == self.totalCount)
                {
                    *stop = YES;
                    dispatch_async(dispatch_get_main_queue(), ^
                    {
                       [_collectionView reloadData];
                    });
                }
            }

        }
    }];
}

#pragma mark - 通知方法

- (void)selectPhoto:(NSNotification *)noti
{
    NSInteger index = [noti.object integerValue];
    
    ((FPImagePickerImageDomain *)_domains[index]).isSelect = YES;
    
    [_selectIndexPath setObject:@"1" forKey:[NSString stringWithFormat:@"%d",index]];
    NSLog(@"%@",_selectIndexPath);
}

- (void)deSelectPhoto:(NSNotification *)noti
{
    NSInteger index = [noti.object integerValue];
    
    ((FPImagePickerImageDomain *)_domains[index]).isSelect = NO;
    
    [_selectIndexPath removeObjectForKey:[NSString stringWithFormat:@"%d",index]];
    
    NSLog(@"%@",_selectIndexPath);
}

- (void)showBigPhoto:(NSNotification *)noti
{
    NSInteger index = [noti.object integerValue];
    FPImagePickerImageDomain * d = _domains[index];
    
    __weak typeof(self) wkself = self;
    
    [[FPImagePickerVC defaultAssetsLibrary] assetForURL:d.localUrl resultBlock:^(ALAsset *asset)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            UIImageView * img = [[UIImageView alloc] init];
            img.backgroundColor = [UIColor blackColor];
            img.frame = CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64);
            img.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
            [wkself.view addSubview:img];
            [wkself.view bringSubviewToFront:img];
        });
    }
    failureBlock:^(NSError *error)
    {
        NSLog(@"大图失败拉");
    }];
}

- (void)dealloc
{
    NSLog(@"select delloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
