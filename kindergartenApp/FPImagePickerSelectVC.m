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
#import "UploadImage.h"
#import "PhotoLargerViewController.h"
#import "FPImagePickerSelectBottomView.h"
#import "FPUploadVC.h"
#import "MJExtension.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface FPImagePickerSelectVC () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView * _collectionView;
    
    NSMutableArray * _domains;
    
    NSMutableDictionary * _selectIndexPath;
    
    FPImagePickerSelectBottomView * _bottomView;
}

@end

@implementation FPImagePickerSelectVC

static NSString *const ImageCell = @"ImageCellID";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"选择图片";
    
    _selectIndexPath = [NSMutableDictionary dictionary];
    
    [self createBottomView];
    
    //处理数据
    [self execDatas];
    
    [self initCollectionView];
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(selectPhoto:) name:@"selectphoto" object:nil];
    [center addObserver:self selector:@selector(deSelectPhoto:) name:@"deselectphoto" object:nil];
    [center addObserver:self selector:@selector(showBigPhoto:) name:@"showbigphoto" object:nil];
    [center addObserver:self selector:@selector(popSelf) name:@"endselect" object:nil];
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

#pragma mark - 创建下面确定view
- (void)createBottomView
{
    _bottomView = [[[NSBundle mainBundle] loadNibNamed:@"FPImagePickerSelectBottomView" owner:nil options:nil] firstObject];
    
    _bottomView.frame = CGRectMake(0, APPWINDOWHEIGHT-49-64, APPWINDOWWIDTH, 49);
    
    _bottomView.infoLbl.text = @"选择了:0 张";
    
    [self.view addSubview:_bottomView];
}

#pragma mark - 通知方法
- (void)selectPhoto:(NSNotification *)noti
{
    NSInteger index = [noti.object integerValue];
    
    ((FPImagePickerImageDomain *)_domains[index]).isSelect = YES;
    
    FPImagePickerImageDomain * d = _domains[index];
    
    [_selectIndexPath setObject:d.localUrl forKey:[NSString stringWithFormat:@"%ld",(long)index]];
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
       _bottomView.infoLbl.text = [NSString stringWithFormat:@"选择了: %ld张",(long)[_selectIndexPath count]];
    });
}

- (void)deSelectPhoto:(NSNotification *)noti
{
    NSInteger index = [noti.object integerValue];
    
    ((FPImagePickerImageDomain *)_domains[index]).isSelect = NO;
    
    [_selectIndexPath removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)index]];
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
       _bottomView.infoLbl.text = [NSString stringWithFormat:@"选择了: %ld张",(long)[_selectIndexPath count]];
    });
}

- (void)showBigPhoto:(NSNotification *)noti
{
    NSInteger index = [noti.object integerValue];
    FPImagePickerImageDomain * d = _domains[index];
    
    __weak typeof(self) wkself = self;
    
    [[FPUploadVC defaultAssetsLibrary] assetForURL:d.localUrl resultBlock:^(ALAsset *asset)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            NSMutableArray *array = [NSMutableArray array];
            UploadImage *upload1 = [[UploadImage alloc] init];
            upload1.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
            [array addObject:upload1];
            PhotoLargerViewController *photo = [[PhotoLargerViewController alloc] init];
            //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:photo];
            [photo setUploadImages:array selectedIndex:0];
            [wkself presentViewController:photo animated:YES completion:^
            {
                
            }];
        });
    }
    failureBlock:^(NSError *error)
    {
        NSLog(@"大图失败拉");
    }];
}

- (void)popSelf
{
    //得到词典中所有value值
    NSEnumerator * enumeratorKey = [_selectIndexPath objectEnumerator];
    
    NSMutableArray * arr = [NSMutableArray array];
    //快速枚举遍历所有KEY的值
    for (NSURL *urls in enumeratorKey)
    {
        [arr addObject:urls];
    }
   
    NSNotification * noti = [[NSNotification alloc] initWithName:@"didgetphotodata" object:[arr copy] userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        for (UIViewController *temp in self.navigationController.viewControllers)
        {
            if ([temp isKindOfClass:[FPUploadVC class]])
            {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
    });
}

- (void)dealloc
{
    NSLog(@"select delloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
