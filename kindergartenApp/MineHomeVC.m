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
#import "MineHomeFunCell.h"
#import "MyCollectionViewController.h"
#import "MySPCourseVC.h"
#import "StudentInfoViewController.h"
#import "SettingViewController.h"
#import "StudentBaseInfoViewController.h"

@interface MineHomeVC () <UICollectionViewDataSource,UICollectionViewDelegate,MineHomeChildrenCellDelegate>
{
    UICollectionView * _collectionView;
    
    NSMutableArray * _studentArr;
}

@end

@implementation MineHomeVC

static NSString *const StuColl = @"stucolle";
static NSString *const NormalColle = @"normalcolle";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tianjiaxiaohai"] style:UIBarButtonItemStylePlain target:self action:@selector(addStudentBaseInfo)];
    
    [rightBarItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    UINavigationBar * bar = self.navigationController.navigationBar;
    NSMutableDictionary * textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor clearColor];
    textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:16];
    bar.titleTextAttributes = textAttrs;
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithHexCode:@"#FF6666"];
    
    if (_studentArr == nil)
    {
        _studentArr = [NSMutableArray arrayWithArray:[KGHttpService sharedService].loginRespDomain.list];
    }
    
    [self initCollectionView];
    
    [self.view addSubview:_collectionView];
    
    //注册通知
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(reloadStuData) name:@"minehomereloaddata" object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_collectionView reloadData];
}

#pragma mark - 添加孩子方法
- (void)addStudentBaseInfo
{
    StudentBaseInfoViewController * vc = [[StudentBaseInfoViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
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
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MineHomeFunCell" bundle:nil] forCellWithReuseIdentifier:NormalColle];
    
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
        
        [cell setUpStudentsItem:_studentArr];
        
        return cell;
    }
    else if (indexPath.row == 1)
    {
        MineHomeFunCell * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:NormalColle forIndexPath:indexPath];
        
        [cell setImageAndTitle:[UIImage imageNamed:@"shoucang"] title:@"我的收藏"];
        
        return cell;
    }
    else if (indexPath.row == 2)
    {
        MineHomeFunCell * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:NormalColle forIndexPath:indexPath];
        
        [cell setImageAndTitle:[UIImage imageNamed:@"my_kechen"] title:@"我的特长课程"];
        
        return cell;
    }
    else if (indexPath.row == 3)
    {
        MineHomeFunCell * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:NormalColle forIndexPath:indexPath];
        
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

#pragma mark - 跳转
- (void)pushToEditStudentInfo:(UIButton *)btn
{
    StudentInfoViewController * vc = [[StudentInfoViewController alloc] init];
    
    vc.studentInfo = [KGHttpService sharedService].loginRespDomain.list[btn.tag];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToAddStudentInfo
{
    StudentBaseInfoViewController * baseInfoVC = [[StudentBaseInfoViewController alloc] init];
    
    [self.navigationController pushViewController:baseInfoVC animated:YES];
}

- (void)reloadStuData
{
    _studentArr = [KGHttpService sharedService].loginRespDomain.list;
    
    [_collectionView reloadData];
}


@end
