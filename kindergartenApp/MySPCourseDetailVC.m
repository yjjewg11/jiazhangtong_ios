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

@interface MySPCourseDetailVC () <UIScrollViewDelegate>
{
    UIView * _courseInfoView;
    UIView * _buttonsView;
    UIScrollView * _contentView;
    NSMutableArray * _btns;
    
    NSMutableArray * _buttonItems;
    
    BOOL isFavor;
}

@property (strong, nonatomic) MySPCourseView * courseView;

@end

@implementation MySPCourseDetailVC

- (MySPCourseView *)courseView
{
    if (_courseView == nil)
    {
        _courseView = [[[NSBundle mainBundle] loadNibNamed:@"MySPCourseView" owner:nil options:nil] firstObject];
    }
    return _courseView;
}

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

    
    //第二个
    SPCourseDetailVC * vc = [[SPCourseDetailVC alloc] init];
    
    vc.haveBottomView = 100;
    vc.uuid = self.domain.courseuuid;
    vc.bottomView.alpha = 0;

    [vc.bottomView removeFromSuperview];
    vc.view.frame = CGRectMake(APPWINDOWWIDTH,0, APPWINDOWWIDTH, APPWINDOWHEIGHT - CGRectGetMaxY(_buttonsView.frame));
    [_contentView addSubview:vc.view];
    
    //第三个
    
    
    
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