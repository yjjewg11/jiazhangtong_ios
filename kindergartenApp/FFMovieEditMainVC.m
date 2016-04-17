//
//  FFMovieEditMainVC.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/4.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FFMovieEditMainVC.h"
#import "FFMoiveEditSubSelectPhotoVC.h"
#import "FPImagePickerSelectVC.h"

#import "FPLocalDBPhotoPickerVC.h"
#import "FFMoiveEditPreviewVC.h"
#import "KGDateUtil.h"
#import "MBProgressHUD+HM.h"
#import "KGHttpService.h"
#import "MJExtension.h"
#import "FPImagePickerImageDomain.h"
#import "FFMovieEditTemplateSelectVC.h"
#import "FFMoiveEditMp3SelectedVC.h"
#import "FFMoiveSubmitView.h"
@interface FFMovieEditMainVC () <UIScrollViewDelegate, JRSegmentControlDelegate>
{
    CGFloat vcWidth;  // 每个子视图控制器的视图的宽
    CGFloat vcHeight; // 每个子视图控制器的视图的高
    
    JRSegmentControl *segment;
    NSInteger _index;
    BOOL _isDrag;
    
    
}


@property (nonatomic, strong) UIScrollView *scrollView;
@end
@implementation FFMovieEditMainVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self regNotification];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)regNotification {

    //注册回复通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickSubmitBysubView:) name:Key_Notification_FFMoviewEditclickSubmitBysubView object:nil];
    
   
    
}
- (void)clickSubmitBysubView: (NSNotification *)notification {
    NSDictionary  * dic = [notification userInfo];
    
    NSNumber *type=[dic objectForKey:@"nextIndex"];
    
    NSInteger nextIndex=[type integerValue];
    
    
    if(nextIndex>=segment.titles.count){
        [self fpMovie_save];
        return ;
    }
    [segment setSelectedIndex:nextIndex];
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
      [self loadRemoteData];
     [self regNotification];
    
}



-(void)initVCArray{
  
    [self setupScrollView];
    self.segmentBgColor = [UIColor colorWithRed:18.0f/255 green:50.0f/255 blue:110.0f/255 alpha:1.0f];
    self.indicatorViewColor = [UIColor whiteColor];
    self.titleColor = [UIColor whiteColor];
    self.segmentBgColor = [UIColor redColor];
    FFMoiveEditNoteSelectedVC *fFMoiveEditNoteSelectedVC=[[FFMoiveEditNoteSelectedVC alloc]init];
    FFMoiveEditSubSelectPhotoVC *fFMoiveEditSubSelectPhotoVC=[[FFMoiveEditSubSelectPhotoVC alloc]init];
    fFMoiveEditSubSelectPhotoVC.delegate=fFMoiveEditNoteSelectedVC;
    [self setViewControllers:@[fFMoiveEditSubSelectPhotoVC,fFMoiveEditNoteSelectedVC , [[FFMovieEditTemplateSelectVC alloc]init],[[FFMoiveEditMp3SelectedVC alloc]init]]];
    
    [self setTitles:@[@"选择", @"编辑", @"模板", @"音乐"]];
    
   
    [self setupViewControllers];
    [self setupSegmentControl];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)itemWidth
{
    if (_itemWidth == 0) {
        _itemWidth = 60.0f;
    }
    return _itemWidth;
}

- (CGFloat)itemHeight
{
    if (_itemHeight == 0) {
        _itemHeight = 30.0f;
    }
    return _itemHeight;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

/** 设置scrollView */
- (void)setupScrollView
{
    
    CGFloat Y = 0.0f;
//    if (self.navigationController != nil && ![self.navigationController isNavigationBarHidden]) {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//        Y = 64.0f;
//    }
    
    vcWidth = self.view.frame.size.width;
    vcHeight = self.view.frame.size.height - Y;
    [FFMovieShareData getFFMovieShareData].vcHeight=vcHeight;
    
    NSLog(@"vcHeight=%f",vcHeight);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, vcWidth, vcHeight)];
//    [scrollView setBackgroundColor:[UIColor yellowColor] ];
    
    scrollView.contentSize = CGSizeMake(vcWidth * self.titles.count, vcHeight);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator   = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate      = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

/** 设置子视图控制器，这个方法必须在viewDidLoad方法里执行，否则子视图控制器各项属性为空 */
- (void)setupViewControllers
{
    int cnt = (int)self.viewControllers.count;
    for (int i = 0; i < cnt; i++) {
        UIViewController *vc = self.viewControllers[i];
        [self addChildViewController:vc];
        
        vc.view.frame = CGRectMake(vcWidth * i, 0, vcWidth, vcHeight);
        [self.scrollView addSubview:vc.view];
    }
}

/** 设置segment */
- (void)setupSegmentControl
{
    _itemWidth = 80.0f;
    // 设置titleView
    segment = [[JRSegmentControl alloc] initWithFrame:CGRectMake(0, 0, _itemWidth * 3, 30.0f)];
    segment.titles = self.titles;
    segment.cornerRadius = 5.0f;
    segment.titleColor = self.titleColor;
    segment.indicatorViewColor = self.indicatorViewColor;
    segment.backgroundColor = self.segmentBgColor;
    
    segment.delegate = self;
    self.navigationItem.titleView = segment;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [segment selectedBegan];
    _isDrag = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_isDrag) {
        CGFloat percent = scrollView.contentOffset.x / scrollView.contentSize.width;
        
        [segment setIndicatorViewPercent:percent];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        [segment selectedEnd];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    [segment setSelectedIndex:index];
    _isDrag = NO;
}

#pragma mark - JRSegmentControlDelegate

- (void)segmentControl:(JRSegmentControl *)segment didSelectedIndex:(NSInteger)index {
    
    _index=index;
   
    CGFloat X = index * self.view.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(X, 0) animated:YES];
}






#pragma mark - 远程获取数据.（某个时间以前的数据）
- (void)loadRemoteData
{
     self.selectDomainMap=[[NSMutableDictionary alloc]init];
    //
        self.domain=[FFMovieShareData getFFMovieShareData].domain;
    if(self.domain==nil){
        self.domain=[[FPMoive4QDomain alloc]init];
        [FFMovieShareData getFFMovieShareData].domain=self.domain;
       
    }

    if(self.domain.uuid==nil){//新建
        [FFMovieShareData getFFMovieShareData].selectDomainMap=nil;
        [self initVCArray];
        
        return;
    }
    NSString * url=[NSString stringWithFormat:@"%@rest/fPPhotoItem/queryForMovieUuid.json?movie_uuid=%@", [KGHttpUrl getBaseServiceURL], self.domain.uuid];
    
    
    
    MBProgressHUD *hud=[MBProgressHUD showMessage:@"获取数据.."];
    hud.removeFromSuperViewOnHide=YES;
    [[KGHttpService sharedService] getListByURL:url success:^(ListBaseDomain *baseDomain) {
//        [self.navigationController popViewControllerAnimated:YES];
        [hud hide:YES];
        [MBProgressHUD showSuccess:baseDomain.ResMsg.message];
        
        NSArray * datas = [FPFamilyPhotoNormalDomain objectArrayWithKeyValuesArray:baseDomain.list];
        NSMutableDictionary * selectDomainMap=[[NSMutableDictionary alloc]init];
        for(FPFamilyPhotoNormalDomain * tmpD in datas){
            FPImagePickerImageDomain *pickDomain=[[FPImagePickerImageDomain alloc]init];
            pickDomain.uuid= tmpD.uuid;
            pickDomain.localUrl=[NSURL URLWithString:tmpD.path];
            //pickDomain.suoluetu=[UIImage imageNamed:tmpD.path];
            
            pickDomain.note=tmpD.note;
            pickDomain.isSelect=YES;
            
          
             [selectDomainMap setObject:pickDomain forKey:pickDomain.uuid];
            
        }
        [FFMovieShareData getFFMovieShareData].selectDomainMap= selectDomainMap;
        [self initVCArray];

        
        
    } faild:^(NSString *errorMessage) {
        
        [hud hide:YES];
        [MBProgressHUD showError:errorMessage];
    }];
    
}
-(NSString * )get_photo_uuids{
    
    return nil;
}
-(void)fpMovie_save{
    
    FPMoive4QDomain * domain4q= [FFMovieShareData getFFMovieShareData].domain;
    FPMoiveDomain * saveDomain=[[FPMoiveDomain alloc]init];
    saveDomain.uuid=domain4q.uuid;
    saveDomain.title=domain4q.title;
    saveDomain.herald=domain4q.herald;
//    saveDomain.photo_uuids=domain4q.photo_uuids;
    saveDomain.template_key=domain4q.template_key;
    saveDomain.mp3=domain4q.mp3;
    saveDomain.status=@"1";//不发布。临存。预览用
    if(saveDomain.title==nil||saveDomain.title.length==0){
        saveDomain.title=[NSString stringWithFormat:@"精品相册%@",[KGDateUtil getNowDateYMD] ];
        
        domain4q.title=saveDomain.title;
    }
    saveDomain.photo_uuids=[FFMovieShareData getFFMovie_photo_uuids];
    if(saveDomain.photo_uuids==nil ||saveDomain.photo_uuids.length==0){
        [MBProgressHUD showError:@"请选择照片"];
           [segment setSelectedIndex:0];
        return;
    }
    MBProgressHUD *hud=[MBProgressHUD showMessage:@"保存中"];
    hud.removeFromSuperViewOnHide=YES;
    [[KGHttpService sharedService] fpMovie_save:saveDomain success:^(KGBaseDomain *domain) {
        [hud hide:YES];
        
        domain4q.uuid=domain.data_id;
        domain4q.share_url=domain.share_url;
        FFMoiveEditPreviewVC *vc=[[FFMoiveEditPreviewVC alloc]init];
        vc.domain=domain4q;
        [self.navigationController pushViewController:vc animated:YES];

        
    } faild:^(NSString *errorMsg) {
        [hud hide:YES];
        [MBProgressHUD showError:errorMsg];
    }];
        
    

}

@end
