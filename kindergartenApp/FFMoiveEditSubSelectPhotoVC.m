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
#import "FFMoiveSubmitView.h"
#import "UIButton+Extension.h"

@interface FFMoiveEditSubSelectPhotoVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,FPLocalDBPhotoPickerVCDelegate,FPImagePickerImageCellDelegate>
{
    UICollectionView * _collectionView;
    //照片数组加分组(日期分组）[groupInd,childInd]
    NSMutableArray * dataSource;
    FPImagePickerImageDomain *selectDomain;
    
     FFMoiveSubmitView * _bottomView;

    float barHeight ;
    
    //选中遮掩成
    UIView * selectmaskView;
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
        
        if(dataSource==nil){
            dataSource=[NSMutableArray array];
        }

        
        //
        //        FPImagePickerSelectLayout * layout = [[FPImagePickerSelectLayout alloc] init];
        //
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        CGRect frame = CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT-64);
        
        NSLog(@"frame step1=%f,%f,%f,%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
//
//        frame.size.height=[FFMovieShareData getFFMovieShareData].vcHeight;
        
        [self.view setFrame:frame];
        
        frame = self.view.frame;
        NSLog(@"frame=%f,%f,%f,%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, APPWINDOWWIDTH, self.view.frame.size.height - 44) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"FPImagePickerImageCell" bundle:nil] forCellWithReuseIdentifier:ImageCell];
        
        [self.view addSubview:_collectionView];
    }
}

- (void)setSelectedFPMoive4QDomain_herald:(NSString *) herald{
    FPMoive4QDomain * domain=[FFMovieShareData getFFMovieShareData].domain;
    domain.herald=herald;
    
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row<dataSource.count){
       
           FPImagePickerImageDomain *data=dataSource[indexPath.row];
        [self setSelectedFPMoive4QDomain_herald:[data.localUrl absoluteString]  ];
        [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
        
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
      
         FPImagePickerImageDomain *data=dataSource[indexPath.row];
        [cell setData:data];
        FPMoive4QDomain * domain=[FFMovieShareData getFFMovieShareData].domain;
        if([domain.herald isEqualToString:[data.localUrl absoluteString] ]){
            [self setViewCellSelectd:cell];
            
        }


    }
    
    
      cell.delegate=self;
    
    return cell;
}


-(void) setViewCellSelectd:(UIView *) view{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,view.width, view.height)];
    label.text=@"封面";
    label.font=[UIFont fontWithName:@"Arial" size:18];
    label.textAlignment = UITextAlignmentCenter;
    [label setBackgroundColor: [ UIColor colorWithWhite: 1 alpha: 0.70 ]];
    //    [label setBorderWithWidth:1 color:[UIColor redColor]];
    
    if(selectmaskView!=nil)
        [selectmaskView removeFromSuperview];
    selectmaskView=label;
    [view addSubview:label];
    
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

    UIButton *_bottomViewBtn= [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.size.height-44, APPWINDOWWIDTH, 44)];
    
    CGRect frame = _bottomViewBtn.frame;
    NSLog(@"_bottomViewBtn.frame=%f,%f,%f,%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    [_bottomViewBtn setText:@"下一步"];
    
    _bottomViewBtn.titleLabel.font = [UIFont systemFontOfSize:APPUILABELFONTNO15];
    [_bottomViewBtn setTitleColor:[UIColor whiteColor ] forState:UIControlStateNormal];
    [_bottomViewBtn setBackgroundColor:[UIColor redColor]];
    _bottomViewBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
   
     [_bottomViewBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_bottomView addSubview:dd];
    
       [self.view addSubview:_bottomViewBtn];
 
    
}
- (void)btnClick:(UIButton *)sender
{

    NSDictionary * dic = @{ @"nextIndex" : [NSNumber numberWithInteger:1]};
                           
   [[NSNotificationCenter defaultCenter] postNotificationName:Key_Notification_FFMoviewEditclickSubmitBysubView object:self userInfo:dic];
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
    
//    dispatch_async(dispatch_get_main_queue(), ^
//                   {
//                       _bottomView.infoLbl.text = [NSString stringWithFormat:@"选择了: %ld张",(long)[[FFMovieShareData getFFMovieShareData].selectDomainMap count]];
//                   });
    
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
