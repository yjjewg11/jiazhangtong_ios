//
//  FPLocalDBPhotoPickerVC.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/3/25.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPLocalDBPhotoPickerVC.h"

#import "FPImagePickerImageCell.h"
#import "FPImagePickerImageDomain.h"
#import "UploadImage.h"
#import "PhotoLargerViewController.h"
#import "FPImagePickerSelectBottomView.h"
#import "PickImgDayHeadView.h"
#import "MJExtension.h"
#import "DBNetDaoService.h"
#import "FPHomeVC.h"
#import "KGDateUtil.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface FPLocalDBPhotoPickerVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,PickImgDayHeadViewDelegate,FPImagePickerImageCellDelegate>
{
    
    UICollectionView * _collectionView;
    //照片数组加分组(日期分组）[groupInd,childInd]
    NSMutableArray * dataSourceGroup;
    //照片数组加分组（分组包含的数据）
    
    NSMutableDictionary * dataSourceGroupChildMap;
    
    //选中的照片集合
//    NSMutableSet * _selectIndexPath;
    UIButton *_rightBarBtnselectAllImg;
    
    //全选日期集合。
    NSMutableSet * _selectHeaderdate;
    
    FPImagePickerSelectBottomView * _bottomView;
    
    DBNetDaoService * _service;
    //全选
    BOOL isAllChecked;
}
@end

@implementation FPLocalDBPhotoPickerVC

static NSString *const ImageCell = @"FPImagePickerImageCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _service = [DBNetDaoService defaulService];
    
    self.title = @"选择图片";
    
    if(_selectIndexPath==nil)_selectIndexPath = [[NSMutableSet alloc]init];
    _selectHeaderdate= [[NSMutableSet alloc]init];
    dataSourceGroup=[NSMutableArray array];
    dataSourceGroupChildMap=[[NSMutableDictionary alloc] init];
    [self initNavigationBar];

    
    //处理数据
    [self execDatas];
    
        [self createBottomView];
    [self initCollectionView];
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //    [center addObserver:self selector:@selector(selectPhoto:) name:@"selectphoto" object:nil];
    //    [center addObserver:self selector:@selector(deSelectPhoto:) name:@"deselectphoto" object:nil];
    //
    [center addObserver:self selector:@selector(showBigPhoto:) name:@"showbigphoto" object:nil];
    [center addObserver:self selector:@selector(popSelf) name:@"endselect" object:nil];
}

-(void)selectAllImg{
    
    if(isAllChecked==YES){
        
        [_rightBarBtnselectAllImg setBackgroundImage:[UIImage imageNamed:@"icon_image_yes"] forState:UIControlStateNormal];
        
        
        isAllChecked=NO;
        
        
        
    }else{
        
        [_rightBarBtnselectAllImg setBackgroundImage:[UIImage imageNamed:@"icon_image_no"] forState:UIControlStateNormal];
        
        
        isAllChecked=YES;
    }
    
    for (NSString *sname in dataSourceGroup)
    {
        [self clickAction_selImg:sname checked:isAllChecked];
    }
    //    [_collectionView reloadData];
}

-(void) initNavigationBar{
    
    
    
    _rightBarBtnselectAllImg = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
    
    [_rightBarBtnselectAllImg setBackgroundImage:[UIImage imageNamed:@"icon_image_no"] forState:UIControlStateNormal];
    [_rightBarBtnselectAllImg addTarget:self action:@selector(selectAllImg) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //
    //    [btn2 addTarget:self action:@selector(showSonView) forControlEvents:UIControlEventTouchUpInside];
    //
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarBtnselectAllImg];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(APPWINDOWWIDTH,50);
    
}
- (void)initCollectionView
{
    if (_collectionView == nil)
    {
        //
        //        FPImagePickerSelectLayout * layout = [[FPImagePickerSelectLayout alloc] init];
        //
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - 49 - 64) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"FPImagePickerImageCell" bundle:nil] forCellWithReuseIdentifier:ImageCell];
        
        
        UINib *headerNib = [UINib nibWithNibName:NSStringFromClass([PickImgDayHeadView class])  bundle:[NSBundle mainBundle]];
        [_collectionView registerNib:headerNib  forSupplementaryViewOfKind :UICollectionElementKindSectionHeader  withReuseIdentifier: @"PickImgDayHeadView" ];  //注册加载头
        
        //
        //        [_collectionView registerClass:[PickImgDayHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PickImgDayHeadView"];
        //
        
        //代码控制header和footer的显示
        UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
        [self.view addSubview:_collectionView];
    }
}


- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    //    NSLog(@"viewForSupplementaryElementOfKind,%d,%d",indexPath.section,indexPath.row);
    
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        
        
        PickImgDayHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PickImgDayHeadView" forIndexPath:indexPath];
        NSString * sname=dataSourceGroup[indexPath.section];
        [headerView setData:sname checked:[_selectHeaderdate containsObject:sname]];
        headerView.delegate=self;
        return headerView;
        
    }
    
    //    if (kind == UICollectionElementKindSectionFooter)
    //    {
    //        RecipeCollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
    //
    //        reusableview = footerview;
    //    }
    
    reusableview.backgroundColor = [UIColor redColor];
    
    return reusableview;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FPImagePickerImageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCell forIndexPath:indexPath];
    
    //NSIndexPath是一个对象，记录了组和行信息
    NSLog(@"生成单元格(组：%i,行%i)",indexPath.section,indexPath.row);
    NSString * groupName=dataSourceGroup[indexPath.section];
    if(groupName==nil) return nil;
    NSArray *arr=[dataSourceGroupChildMap objectForKey:groupName];
    FPImagePickerImageDomain *tmp= arr[indexPath.row];
    
    [cell setData:tmp];
    cell.delegate=self;
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return dataSourceGroup.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSString * groupName=dataSourceGroup[section];
    if(groupName==nil) return nil;
    NSArray *arr=[dataSourceGroupChildMap objectForKey:groupName];
    
    return arr.count;
    //    return _domains.count;
}
#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float quter = (self.view.frame.size.width - 5) / 4 - 9;
    
    return CGSizeMake(quter, quter);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)execDatas
{
    //从数据库获取数据，判断是否有已导入图片
    NSMutableArray * marr = [_service getListTimePhotoDataByPage:[KGDateUtil getLocalDateStr] familyUUID:[FPHomeVC getFamily_uuid] pageNo:1 limit:999999];
;
    
    NSLog(@"总共有:%d张",marr.count);
    if(dataSourceGroup==nil)dataSourceGroup=[NSMutableArray array];
    if(dataSourceGroupChildMap==nil)dataSourceGroupChildMap=[[NSMutableDictionary alloc] init];
    
    
    for(FPFamilyPhotoNormalDomain * domain in marr){
        
        if(domain.create_time==nil){
            domain.create_time=@"1900-01-01 00:00:00";
        }
        NSString *sectionName= [[domain.create_time componentsSeparatedByString:@" "] firstObject];
        NSMutableArray *  tmp= [dataSourceGroupChildMap objectForKey:sectionName];
        
        
        FPImagePickerImageDomain *pickDomain=[[FPImagePickerImageDomain alloc]init];
        pickDomain.uuid= domain.uuid;
        pickDomain.localUrl=[NSURL URLWithString:domain.path];
        pickDomain.suoluetu=[UIImage imageNamed:domain.path];
        
        
        pickDomain.isSelect=[_selectIndexPath containsObject:pickDomain.uuid];
        //分组数据转换
        if(tmp==nil){
            tmp=[NSMutableArray array];
            [dataSourceGroup addObject:sectionName];
                
                [tmp addObject:pickDomain];
                
           
            [dataSourceGroupChildMap setObject:tmp forKey:sectionName];
        }else{
            
            {
                [tmp addObject:pickDomain];
            }
            
        }
        
    }
    
    // 降序
    // K --> A
    [dataSourceGroup sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
        NSString *str1=(NSString *)obj1;
        NSString *str2=(NSString *)obj2;
        return [str2 compare:str1];
    }];
    
}

#pragma mark - 创建下面确定view
- (void)createBottomView
{
    _bottomView = [[[NSBundle mainBundle] loadNibNamed:@"FPImagePickerSelectBottomView" owner:nil options:nil] firstObject];
    
    _bottomView.frame = CGRectMake(0, APPWINDOWHEIGHT-49-64, APPWINDOWWIDTH, 49);
    
     _bottomView.infoLbl.text = [NSString stringWithFormat:@"选择了: %ld张",(long)[_selectIndexPath count]];
    
        [self.view addSubview:_bottomView];
}






- (void)showBigPhoto:(NSNotification *)noti
{
    //NSInteger index = [noti.object integerValue];
    NSString *localUrl = [noti.userInfo objectForKey:@"localUrl"];
    
    __weak typeof(self) wkself = self;
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       NSMutableArray *array = [NSMutableArray array];
                       UploadImage *upload1 = [[UploadImage alloc] init];
                       
                       
                      
                       upload1.image = [UIImage imageNamed:localUrl];
                       [array addObject:upload1];
                       PhotoLargerViewController *photo = [[PhotoLargerViewController alloc] init];
                       //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:photo];
                       [photo setUploadImages:array selectedIndex:0];
                       
                       
                       [wkself presentViewController:photo animated:YES completion:^
                        {
                            
                        }];
                   });
}

#pragma mark - 确定选择
- (void)popSelf
{
    //得到词典中所有key值
    // NSEnumerator * enumeratorObject = [_selectIndexPath keyEnumerator];
    
    NSMutableArray * urlArr = [NSMutableArray array];
    NSMutableArray * urlStrArr = [NSMutableArray array];
    
    for (NSURL *urls in _selectIndexPath)
    {
        [urlArr addObject:urls];
        [urlStrArr addObject:[urls absoluteString]];
    }
//    
//    NSNotification * noti = [[NSNotification alloc] initWithName:@"didgetphotodata" object:[urlArr copy] userInfo:nil];
//    [[NSNotificationCenter defaultCenter] postNotification:noti];
//    
//    //存入数据库
//    [_service saveUploadImgListPath:urlStrArr];
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       for (UIViewController *temp in self.navigationController.viewControllers)
                       {
//                           if ([temp isKindOfClass:[FPUploadVC class]])
//                           {
//                               [self.navigationController popToViewController:temp animated:YES];
//                           }
                       }
                   });
}

- (void)dealloc
{
    NSLog(@"select delloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma PickImgDayHeadViewDelegate
-(void)clickAction_selImg:(NSString *)sectionName checked:(Boolean ) checked
{
    NSUInteger section =[dataSourceGroup indexOfObject:sectionName];
    if(checked==YES){
        [_selectHeaderdate addObject:sectionName];
    }else{
        [_selectHeaderdate removeObject:sectionName];
    }
    
    if(section == NSNotFound){
        return;
    }else{
        //找到了
    }
    NSMutableArray *childArr=[dataSourceGroupChildMap objectForKey:sectionName];
    if(childArr.count==0)return;
    NSMutableArray<NSIndexPath *> *indexPaths=[NSMutableArray array];
    for (int i=0;i<childArr.count; i++ ) {
        FPImagePickerImageDomain * tmp=childArr[i];
        if(tmp.isUpload==YES){
            continue;
        }
        tmp.isSelect = checked;
        
        
        NSIndexPath * path= [NSIndexPath indexPathForItem:i inSection:section];
        [indexPaths addObject:path];
        //添加到选择框
        [self updateSelectedStatus:childArr[i]];
        
        //- (void)reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
    }
    //批量更新
    [_collectionView reloadItemsAtIndexPaths:indexPaths];
}

#pragma FPImagePickerImageCellDelegate
-(void)updateSelectedStatus:(FPImagePickerImageDomain *)domain{
    if(domain.isSelect==YES){
        
        [_selectIndexPath addObject:domain.uuid];
        
    }else{
        [_selectIndexPath removeObject:domain.uuid];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       _bottomView.infoLbl.text = [NSString stringWithFormat:@"选择了: %ld张",(long)[_selectIndexPath count]];
                   });
    
}
@end
