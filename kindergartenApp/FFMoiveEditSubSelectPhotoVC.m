//
//  FFMoiveEditSubSelectPhotoVC.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/4.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FFMoiveEditSubSelectPhotoVC.h"

#import "FPImagePickerImageCell.h"
#import "FPImagePickerImageDomain.h"
#import "MBProgressHUD+HM.h"
#import "KGHttpService.h"
#import "MJExtension.h"
#import "FPLocalDBPhotoPickerVC.h"
#import "FPImagePickerSelectBottomView.h"


@interface FFMoiveEditSubSelectPhotoVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,FPLocalDBPhotoPickerVCDelegate,FPImagePickerImageCellDelegate,FPImagePickerSelectBottomViewDelegate>
{
    UICollectionView * _collectionView;
    //照片数组加分组(日期分组）[groupInd,childInd]
    NSMutableArray * dataSource;
    FPImagePickerImageDomain *selectDomain;
    
    FPImagePickerSelectBottomView * _bottomView;

    float barHeight ;
}
@end

@implementation FFMoiveEditSubSelectPhotoVC
static NSString *const ImageCell = @"FPImagePickerImageCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    barHeight=0;
//    barHeight=self.navigationController.navigationBar.size.height;
//    [self.navigationController.navigationBar setSize:CGSizeMake(0,0)];
      [self initCollectionView];
    [self createBottomView];
    [self submitSelectMap:[FFMovieShareData getFFMovieShareData].selectDomainMap];
    
//    self.title=@"修改照片";
    // Do any additional setup after loading the view.
}
- (void)initCollectionView
{
    if (_collectionView == nil)
    {
        //
        //        FPImagePickerSelectLayout * layout = [[FPImagePickerSelectLayout alloc] init];
        //
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, APPWINDOWWIDTH, self.view.frame.size.height - 49 - 64-barHeight) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"FPImagePickerImageCell" bundle:nil] forCellWithReuseIdentifier:ImageCell];
        
        [self.view addSubview:_collectionView];
    }
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row<dataSource.count){
        return;
    }
    
        
    
    FPLocalDBPhotoPickerVC * vc = [[FPLocalDBPhotoPickerVC alloc] init];
    vc.delegate=self;
    
    vc.selectDomainMap=[FFMovieShareData getFFMovieShareData].selectDomainMap;
    //传递点击的日期过去
    //    vc.daytimeStr = _timeDatas[indexPath.row - 1];
    //    vc.familyUUID = [FPHomeVC getFamily_uuid];
    
//    [vc setFpPhotoNormalDomainArrByDic:_dataArr];
//
//    vc.selectIndex=indexPath.row;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (FPImagePickerImageDomain *)getSelectDomain{
    
    if(selectDomain==nil){
        
       selectDomain=[[FPImagePickerImageDomain alloc]init];
        selectDomain.isOlnyShowImg=YES;
        selectDomain.suoluetu= [UIImage imageNamed:@"newshoucang1"];
      
    }
    return selectDomain;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    FPImagePickerImageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCell forIndexPath:indexPath];
    
    //最后添加选择图片按钮
    if(dataSource.count==indexPath.row)
    {
          [cell setData:[self getSelectDomain]];
    }else{
        [cell setData:dataSource[indexPath.row]];

    }
    
    
      cell.delegate=self;
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
        //最后一个设置为选择
    return dataSource.count+1;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//提交选择数据
- (void)submitSelectMap: (NSMutableDictionary *) selectDomainMap{
    
    if(dataSource==nil){
        dataSource=[NSMutableArray array];
    }
    [FFMovieShareData getFFMovieShareData].selectDomainMap=selectDomainMap;
   
    [dataSource removeAllObjects];
    [dataSource addObjectsFromArray:[selectDomainMap allValues ]];
    [_collectionView reloadData];
    [self.delegate selectEndNoitce:selectDomainMap];
}


#pragma mark - 创建下面确定view
- (void)createBottomView
{
    _bottomView = [[[NSBundle mainBundle] loadNibNamed:@"FPImagePickerSelectBottomView" owner:nil options:nil] firstObject];
    _bottomView.delegate=self;
    _bottomView.frame = CGRectMake(0, self.view.size.height-49-64-20-barHeight, APPWINDOWWIDTH, 49);
    
    _bottomView.infoLbl.text = [NSString stringWithFormat:@"选择了: %ld张",(long)[[FFMovieShareData getFFMovieShareData].selectDomainMap count]];
    
    [self.view addSubview:_bottomView];
}


#pragma FPImagePickerImageCellDelegate
-(void)updateSelectedStatus:(FPImagePickerImageDomain *)domain{
    if(domain.isSelect==YES){
        [[FFMovieShareData getFFMovieShareData].selectDomainMap setObject:domain forKey:domain.uuid];
        // [_selectIndexPath addObject:domain.uuid];
        
    }else{
        [[FFMovieShareData getFFMovieShareData].selectDomainMap removeObjectForKey:domain.uuid];
        //[_selectIndexPath removeObject:domain.uuid];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       _bottomView.infoLbl.text = [NSString stringWithFormat:@"选择了: %ld张",(long)[[FFMovieShareData getFFMovieShareData].selectDomainMap count]];
                   });
    
}


- (void)submitOK{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
