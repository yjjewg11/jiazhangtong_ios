//
//  FPHomeVC.m
//  kindergartenApp
//
//  Created by Mac on 16/1/13.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "FPHomeVC.h"
#import "ParallaxHeaderView.h"
#import "FPHomeTopView.h"
#import "FPHomeSonView.h"
#import "FPHomeSelectView.h"
#import "UzysAssetsPickerController.h"
#import "FPHomeBtnCell.h"
#import "FPGifrwarePickerVC.h"

@interface FPHomeVC () <UITableViewDataSource,UITableViewDelegate,FPHomeSelectViewDelegate,UzysAssetsPickerControllerDelegate>
{
    UITableView * _tableView;
    FPHomeSonView * sonView;
    FPHomeSelectView * selView;
}


@end

@implementation FPHomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showLoadView];
    
    [self initTableView];
    
    [self createBarItems];
}

- (void)initTableView
{
    //自定义的headerview
    FPHomeTopView * view = [[[NSBundle mainBundle] loadNibNamed:@"FPHomeTopView" owner:nil options:nil] firstObject];
    view.size = CGSizeMake(APPWINDOWWIDTH, 236);
    
    //弄到tableviewheader里面去
    ParallaxHeaderView * headerView = [ParallaxHeaderView parallaxHeaderViewWithSubView:view];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64 - 49)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setTableHeaderView:headerView];
    [self.view addSubview:_tableView];
    
    sonView = [[[NSBundle mainBundle] loadNibNamed:@"FPHomeSonView" owner:nil options:nil] firstObject];
    sonView.origin = CGPointMake(0, -132);
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:sonView.bounds];
    sonView.layer.masksToBounds = NO;
    sonView.layer.shadowColor = [UIColor blackColor].CGColor;
    sonView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    sonView.layer.shadowOpacity = 0.5f;
    sonView.layer.shadowPath = shadowPath.CGPath;
    [self.view addSubview:sonView];
}

#pragma mark UISCrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableView)
    {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
        [(ParallaxHeaderView *)_tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
        sonView.origin = CGPointMake(0, -132);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        static NSString * btnCell = @"btn_cell";
        
        FPHomeBtnCell * cell = [tableView dequeueReusableCellWithIdentifier:btnCell];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FPHomeBtnCell" owner:nil options:nil] firstObject];
        }
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 44;
    }
    
    return 0;
}

#pragma mark - 创建navBar items
- (void)createBarItems
{
    UIButton* btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"new_album"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(pushToUpLoadVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    UIButton* btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,27)];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"hanbao"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(showSonView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
}

- (void)pushToUpLoadVC
{
    sonView.origin = CGPointMake(0, -132);
    selView = [[[NSBundle mainBundle] loadNibNamed:@"FPHomeSelectView" owner:nil options:nil] firstObject];
    selView.delegate = self;
    selView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    
    CATransition *applicationLoadViewIn =[CATransition animation];
    [applicationLoadViewIn setDuration:0.3];
    [applicationLoadViewIn setType:kCATransitionReveal];
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [[selView layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
    [self.view addSubview:selView];
}

- (void)showSonView
{
    [UIView animateWithDuration:0.2 animations:^
    {
        if (sonView.origin.y == 0)
            sonView.origin = CGPointMake(0, -132);
        else
            sonView.origin = CGPointMake(0, 0);
    }];
}

- (void)pushToImagePickerVC
{
    UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
    picker.delegate = self;
    //设置最大选择图片数量
    picker.maximumNumberOfSelectionPhoto = 999;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)pushToCreateGiftwareShopVC
{
    
}

#pragma mark - UzysAssetsPickerControllerDelegate methods 
//本框架支持选择视频文件
- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [selView removeFromSuperview];
    
    if([[assets[0] valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"]) //Photo
    {
        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
        {
            ALAsset *representation = obj;
            
            UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                               scale:representation.defaultRepresentation.scale
                                         orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
        }];
        
        //从本机相册获取到图片,复制一份到本地沙盒，然后进行上传
        
        
        //若下一次进来，比较两个UIImage的data，看看是否相同。直接上关键代码了。
        
        
    }
}

- (void)uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:NSLocalizedStringFromTable(@"只能选择999张图片哦", @"UzysAssetsPickerController", nil)
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}



@end
