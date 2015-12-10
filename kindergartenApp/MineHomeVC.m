//
//  MineHomeVC.m
//  kindergartenApp
//
//  Created by Mac on 15/12/8.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "MineHomeVC.h"
#import "MineHomeChildrenCell.h"
#import "MineHomeLayout.h"
#import "UIColor+flat.h"
#import "MineHomeNormalCell.h"
#import "MyCollectionViewController.h"
#import "MySPCourseVC.h"
#import "StudentInfoViewController.h"
#import "SettingViewController.h"

@interface MineHomeVC () <UICollectionViewDataSource,UICollectionViewDelegate,MineHomeChildrenCellDelegate>
{
    UICollectionView * _collectionView;
}

@end

@implementation MineHomeVC

static NSString *const StuColl = @"stucoll";
static NSString *const NormalColl = @"normalcoll";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINavigationBar * bar = self.navigationController.navigationBar;
    NSMutableDictionary * textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor clearColor];
    textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:16];
    bar.titleTextAttributes = textAttrs;
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithHexCode:@"#FF6666"];
    
    [self initCollectionView];
    
    [self.view addSubview:_collectionView];
}

#pragma mark - 初始化collectionview
- (void)initCollectionView
{
    //创建coll布局
    MineHomeLayout * layout = [[MineHomeLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KGSCREEN.size.width, KGSCREEN.size.height - 64) collectionViewLayout:layout];
    
    _collectionView.bounces = NO;
    
    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MineHomeChildrenCell" bundle:nil] forCellWithReuseIdentifier:StuColl];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MineHomeNormalCell" bundle:nil] forCellWithReuseIdentifier:NormalColl];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        MineHomeChildrenCell * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:StuColl forIndexPath:indexPath];
        
        cell.delegate = self;
        
        return cell;
    }
    else if (indexPath.row == 1)
    {
        MineHomeNormalCell * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:NormalColl forIndexPath:indexPath];
        
        [cell setImageAndTitle:[UIImage imageNamed:@"shoucang"] title:@"我的收藏"];
        
        return cell;
    }
    else if (indexPath.row == 2)
    {
        MineHomeNormalCell * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:NormalColl forIndexPath:indexPath];
        
        [cell setImageAndTitle:[UIImage imageNamed:@"my_kechen"] title:@"我的特长课程"];
        
        return cell;
    }
    else if (indexPath.row == 3)
    {
        MineHomeNormalCell * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:NormalColl forIndexPath:indexPath];
        
        [cell setImageAndTitle:[UIImage imageNamed:@"shezhi"] title:@"设置"];
        
        return cell;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
    {
        MyCollectionViewController * vc = [[MyCollectionViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 2)
    {
        MySPCourseVC * vc = [[MySPCourseVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 3)
    {
        SettingViewController * vc = [[SettingViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)pushToEditStudentInfo:(UIButton *)btn
{
    StudentInfoViewController * vc = [[StudentInfoViewController alloc] init];
    
    vc.studentInfo = [KGHttpService sharedService].loginRespDomain.list[btn.tag];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
