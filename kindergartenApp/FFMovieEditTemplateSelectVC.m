//
//  FFMovieEditTemplateSelectVC.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/8.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FFMovieEditTemplateSelectVC.h"


#import "FPImagePickerImageCell.h"
#import "FPImagePickerImageDomain.h"
#import "MBProgressHUD+HM.h"
#import "KGHttpService.h"
#import "MJExtension.h"
#import "FPImagePickerSelectBottomView.h"
#import "UIImageView+WebCache.h"
#import "FPTimeLineEditVC.h"
#import "FFMovieShareData.h"
#import "FPMovieTemplateDomain.h"
#import "FFMoiveSubmitView.h"
#import "UIButton+Extension.h"

@interface FFMovieEditTemplateSelectVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView * _collectionView;
    //照片数组加分组(日期分组）[groupInd,childInd]
    NSMutableArray * dataSource;
    NSIndexPath * selectIndexPath;
    //选中遮掩成
    UIView * selectmaskView;
      int _pageNo;
     FFMoiveSubmitView * _bottomView;
}

@end

@implementation FFMovieEditTemplateSelectVC

#pragma mark - 创建下面确定view
- (void)createBottomView
{
    
    UIButton *_bottomViewBtn= [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.size.height-44-64, APPWINDOWWIDTH, 44)];
    
    
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
    
    NSDictionary * dic = @{ @"nextIndex" : [NSNumber numberWithInteger:3]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Key_Notification_FFMoviewEditclickSubmitBysubView object:self userInfo:dic];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNo = 1;

      [self initCollectionView];
    [self createBottomView];
    [self getData];
    // Do any additional setup after loading the view.
}
- (void)setSelectedFPMoive4QDomain:(FPMovieTemplateDomain *) template{
    FPMoive4QDomain * domain=[FFMovieShareData getFFMovieShareData].domain;
    domain.template_key=template.key;
    domain.mp3=template.mp3;
    
}
- (void)getData{
  
    MBProgressHUD * hub=[MBProgressHUD showMessage:@"加载数据，请稍后"];
    hub.removeFromSuperViewOnHide=YES;
    NSString * url=[NSString stringWithFormat:@"%@rest/fPMovieTemplate/query.json", [KGHttpUrl getBaseServiceURL]];
    //请求最新domain
    [[KGHttpService sharedService] queryByPage:url pageNo:_pageNo success:^(KGListBaseDomain *baseDomain) {
        _pageNo++;
        [hub hide:YES];
        dataSource=   [FPMovieTemplateDomain objectArrayWithKeyValuesArray:baseDomain.list.data];
      
        if(dataSource.count>0){
            FPMoive4QDomain * domain=[FFMovieShareData getFFMovieShareData].domain;
            //初始值
            if(domain.template_key==nil){
                [self setSelectedFPMoive4QDomain:dataSource[0]];
            }
            
        }
        [_collectionView reloadData];

    } faild:^(NSString *errorMsg) {
        [hub hide:YES];
        [MBProgressHUD showError:errorMsg];
    } ];
  

}

- (void)initCollectionView
{
    if (_collectionView == nil)
    {
        //
        //        FPImagePickerSelectLayout * layout = [[FPImagePickerSelectLayout alloc] init];
        //
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, APPWINDOWWIDTH, self.view.frame.size.height - 49 - 64) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class]     forCellWithReuseIdentifier:@"collectionViewCell"];
        [self.view addSubview:_collectionView];
    }
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    selectIndexPath=indexPath;
    FPMovieTemplateDomain *selectDomain= dataSource[indexPath.row];
    
    [self setSelectedFPMoive4QDomain:selectDomain];
    [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * CellIdentifier = @"collectionViewCell";
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSLog(@"indexPath.row:%ld", indexPath.row);
    
    FPMovieTemplateDomain * data=dataSource[indexPath.row];
    
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.width, cell.height-20)];
    
    //        [cell setRestorationIdentifier:[data objectForKey:@"uuid"]];
    //
    
    [imgView sd_setImageWithURL:data.herald placeholderImage:[UIImage imageNamed:@"waitImageDown"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {}];
    
    // 测试字串
    UIFont *font = [UIFont fontWithName:@"Arial" size:12];
    //备注
    //设置一个行高上限
    //    CGSize size = CGSizeMake(cell.width, cell.height);
    //
    //    CGSize labelsize = [data.note sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    //
    
    //UILabel自适应高度和自动换行
    //初始化label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,cell.height-20,cell.width, 20)];
    //    [label setBackgroundColor:UIColor blackColor];
    label.text=data.title;
    
    //设置自动行数与字符换行
    [label setNumberOfLines:0];
    label.lineBreakMode = UILineBreakModeWordWrap;
    
    [imgView addSubview:label];
    
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    [cell.contentView addSubview:imgView];
    [cell.contentView addSubview:label];
    
    
    FPMoive4QDomain * domain=[FFMovieShareData getFFMovieShareData].domain;
    if([domain.template_key isEqualToString:data.key]){
        [self setViewCellSelectd:imgView];

    }
    return cell;
    
}
-(void) setViewCellSelectd:(UIView *) view{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,view.width, view.height)];
    label.text=@"已选中";
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
    return dataSource.count;
    //    return _domains.count;
}
#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float quter = (self.view.frame.size.width - 5) / 2 - 9;
    
    return CGSizeMake(quter, quter+20);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}





- (void)submitOK{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
