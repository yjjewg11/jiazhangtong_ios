//
//  MySPCourseDetailVC.m
//  kindergartenApp
//
//  Created by Mac on 15/11/13.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "MySPCourseDetailVC.h"
#import "ACMacros.h"
#import "MySPCourseView.h"
#import "SPCourseDetailVC.h"
#import "MySPCourseCommentVC.h"
#import "MySPCourseTimeListVC.h"
#import "KGHUD.h"
#import "MJExtension.h"
#import "KGHttpService.h"
#import "MySPAllCouseListDomain.h"
#import "MySPCourseSchoolDetailWebView.h"

@interface MySPCourseDetailVC () <UIScrollViewDelegate>
{
    UIView * _courseInfoView;
    UIView * _buttonsView;
    UIScrollView * _contentView;
    NSMutableArray * _btns;
    
    MySPCourseTimeListVC *_listVC;
    
    NSMutableArray * _buttonItems;
    
    BOOL isFavor;
}

@property (strong, nonatomic) MySPCourseView * courseView;

@property (strong, nonatomic) MySPCourseCommentVC * commentVC;

@end

@implementation MySPCourseDetailVC

- (MySPCourseCommentVC *)commentVC
{
    if (_commentVC == nil)
    {
        _commentVC = [[MySPCourseCommentVC alloc] init];
    }
    
    return _commentVC;
}

- (MySPCourseView *)courseView
{
    if (_courseView == nil)
    {
        _courseView = [[[NSBundle mainBundle] loadNibNamed:@"MySPCourseView" owner:nil options:nil] firstObject];
    }
    return _courseView;
}

#pragma mark - viewdidload
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"学校详情";
    
    //创建顶部课程信息view
    _courseInfoView = [[UIView alloc] init];
    _courseInfoView.frame = CGRectMake(0, APPSTATUSBARHEIGHT + APPTABBARHEIGHT, APPWINDOWWIDTH, 150);
    [self addInfoCell:_courseInfoView];
    
    //创建上面三个按钮view
    _buttonsView = [[UIView alloc] init];
    _buttonsView.frame = CGRectMake(0, APPSTATUSBARHEIGHT + APPTABBARHEIGHT + 120, APPWINDOWWIDTH, 30);
    [self addSelBtns:_buttonsView];
    
    //创建scrollView
    _contentView = [[UIScrollView alloc] init];
    _contentView.frame = CGRectMake(0, CGRectGetMaxY(_buttonsView.frame) + 1, APPWINDOWWIDTH, APPWINDOWHEIGHT - CGRectGetMaxY(_buttonsView.frame));

    [self addContent:_contentView];
    
    //获取数据
    
}

#pragma mark - 请求一个班级的全部课程安排
- (void)getListData
{
    [[KGHUD sharedHud] show:self.view];
    
    [[KGHttpService sharedService] getListAll:self.domain.uuid pageNo:@"" success:^(MySPAllCourseListVO *courseListVO)
    {
        _listVC.listDatas = [NSMutableArray arrayWithArray:[MySPAllCouseListDomain objectArrayWithKeyValuesArray:courseListVO.data]];
        
        _listVC.classuuid = self.domain.uuid;
        
        [_contentView addSubview:_listVC.tableView];
        
        [_listVC.tableView reloadData];
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.view onlyMsg:errorMsg];
    }];
}


#pragma mark - 创建顶部schoolinfo
- (void)addInfoCell:(UIView *)view
{
    CGFloat padding = (APPWINDOWWIDTH - 320) / 2;
    
    [self.courseView setOrigin:CGPointMake(padding, 0)];
    
    //设置数据
    [self.courseView setData:self.domain];
    
    //加入
    [_courseInfoView addSubview:self.courseView];
    [self.view addSubview:_courseInfoView];
}

#pragma mark - 创建上面3个选择按钮
- (void)addSelBtns:(UIView *)view
{
    NSArray * titlts = @[@"课程",@"简介",@"评价"];
    _btns = [NSMutableArray array];
    
    for (NSInteger i=0; i<3; i++)
    {
        MyButtonTwo * btn = [[MyButtonTwo alloc] initWithFrame:CGRectMake(i * (APPWINDOWWIDTH / 3), 0, (APPWINDOWWIDTH / 3), 30)];
        
        [btn setTitle:titlts[i] forState:UIControlStateNormal];
        [btn setTitle:titlts[i] forState:UIControlStateSelected];
        
        [btn setBackgroundColor:[UIColor lightGrayColor]];
        [btn setBackgroundImage:[UIImage imageNamed:@"btnbeijing"] forState:UIControlStateSelected];
        
        btn.tag = i;
        
        [btn addTarget:self action:@selector(selBtn:) forControlEvents:UIControlEventTouchDown];
        
        [_btns addObject:btn];
        
        [_buttonsView addSubview:btn];
    }
    
    ((UIButton *)_btns[0]).selected = YES;
    
    [self.view addSubview:_buttonsView];
}

#pragma mark - 选择按钮显示效果
- (void)selBtn:(UIButton *)btn
{
    btn.selected = YES;
    
    for (NSInteger i=0; i<_btns.count; i++)
    {
        if (btn.tag == i)
        {
            ((UIButton *)_btns[i]).selected = YES;
        }
        else
        {
            ((UIButton *)_btns[i]).selected = NO;
        }
    }
    [_contentView setContentOffset:CGPointMake(btn.tag * APPWINDOWWIDTH, 0) animated:NO];
}

#pragma mark - 创建scroll中子控件
- (void)addContent:(UIScrollView *)scrollView
{
    _contentView.contentSize = CGSizeMake(APPWINDOWWIDTH * 3 , 0);
    
    _contentView.delegate = self;
    
    _contentView.pagingEnabled = YES;
    
    _contentView.showsHorizontalScrollIndicator = NO;
    
    //第一个
    MySPCourseTimeListVC * timelistVC = [[MySPCourseTimeListVC alloc] init];
    
    _listVC = timelistVC;
    
    timelistVC.classuuid = self.domain.uuid;
    
    timelistVC.tableFrame = CGRectMake(0,0, APPWINDOWWIDTH, APPWINDOWHEIGHT - CGRectGetMaxY(_buttonsView.frame));
    
    [self getListData];
    
    //第二个
    MySPCourseSchoolDetailWebView * web = [[[NSBundle mainBundle] loadNibNamed:@"MySPCourseSchoolDetailWebView" owner:nil options:nil] firstObject];
    
    web.frame = CGRectMake(APPWINDOWWIDTH ,0, APPWINDOWWIDTH, APPWINDOWHEIGHT - CGRectGetMaxY(_buttonsView.frame));
    
    web.groupuuid = self.domain.groupuuid;
    
    [_contentView addSubview:web];
    
    //第三个
    self.commentVC.classuuid = self.domain.uuid;
    
    self.commentVC.groupuuid = self.domain.groupuuid;
    
    self.commentVC.courseuuid = self.domain.courseuuid;
    
    self.commentVC.tableFrame = CGRectMake(APPWINDOWWIDTH + APPWINDOWWIDTH ,0, APPWINDOWWIDTH, APPWINDOWHEIGHT - CGRectGetMaxY(_buttonsView.frame));
    
    [_contentView addSubview:self.commentVC.tableView];
    
    //添加
    [self.view addSubview:_contentView];
}

#pragma mark - scrollview代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = (scrollView.contentOffset.x / APPWINDOWWIDTH);
    
    for (NSInteger i = 0 ; i<_btns.count; i++)
    {
        if (i == index)
        {
            ((MyButtonTwo *)_btns[i]).selected = YES;
        }
        else
        {
            ((MyButtonTwo *)_btns[i]).selected = NO;
        }
    }
}


@end

#pragma mark - 实现自定义Button
@implementation MyButtonTwo

//图片高亮会调用这个方法
- (void)setHighlighted:(BOOL)highlighted
{
    //取消点击效果
}

@end