//
//  MySPCourseCommentVC.m
//  kindergartenApp
//
//  Created by Mac on 15/11/13.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "MySPCourseCommentVC.h"
#import "KGHUD.h"
#import "KGHttpService.h"
#import "MySPCommentDomain.h"
#import "MJExtension.h"
#import "SPTeacherDomain.h"
#import "MySPCourseCommentCell.h"
#import "MySPNormalCell.h"
#import "MySPButtonCell.h"

@interface MySPCourseCommentVC () <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray * commentsArr;

@property (assign, nonatomic) BOOL flag;   //标识是否我评价了

@property (strong, nonatomic) MySPCommentDomain * courseDomain;

@property (strong, nonatomic) MySPCommentDomain * schoolDomain;

@property (strong, nonatomic) NSMutableArray * teachersDomain;

@property (strong, nonatomic) NSMutableArray * teacherList;

@end

@implementation MySPCourseCommentVC

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if ( self = [super initWithStyle:UITableViewStyleGrouped])
    {
        
    }
    
    return self;
}

- (NSMutableArray *)teacherList
{
    if (_teacherList == nil)
    {
        _teacherList = [NSMutableArray array];
    }
    return _teacherList;
}

- (MySPCommentDomain *)courseDomain
{
    if (_courseDomain == nil)
    {
        _courseDomain = [[MySPCommentDomain alloc] init];
    }
    return _courseDomain;
}

- (MySPCommentDomain *)schoolDomain
{
    if (_schoolDomain == nil)
    {
        _schoolDomain = [[MySPCommentDomain alloc] init];
    }
    return _schoolDomain;
}

- (NSMutableArray *)teachersDomain
{
    if (_teachersDomain == nil)
    {
        _teachersDomain = [NSMutableArray array];
    }
    return _teachersDomain;
}

- (NSMutableArray *)commentsArr
{
    if (_commentsArr == nil)
    {
        _commentsArr = [NSMutableArray array];
    }
    return _commentsArr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    self.tableView.frame = self.tableFrame;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //请求老师列表
    [self getTeacherList];
    
    //请求我的评价
    [self getCourseComment];
}

#pragma mark - 请求老师列表
- (void)getTeacherList
{
    [[KGHUD sharedHud] show:self.tableView];
    
    [[KGHttpService sharedService] MySPCourseTeacherList:self.classuuid success:^(NSArray *teacherArr)
    {
        self.teacherList = [NSMutableArray arrayWithArray:teacherArr];
        
        [self.tableView reloadData];
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.tableView onlyMsg:errorMsg];
    }];
}

#pragma mark - 请求我的评价
- (void)getCourseComment
{
    [[KGHttpService sharedService] MySPCourseComment:self.classuuid pageNo:@"0" success:^(SPDataListVO *msg)
    {
        self.commentsArr = [NSMutableArray arrayWithArray:[MySPCommentDomain objectArrayWithKeyValuesArray:msg.data]];
        if (self.commentsArr.count == 0 || self.commentsArr == nil)
        {
            NSLog(@"还没有我的评价");
            self.flag = NO;
            [self initData];
        }
        else
        {
            self.flag = YES;
            [self separateData];
        }
        
        [[KGHUD sharedHud] hide:self.tableView];
        [self.tableView reloadData];
    }
    faild:^(NSString *errorMsg)
    {
        [[KGHUD sharedHud] show:self.tableView onlyMsg:errorMsg];
    }];
    
}

#pragma mark - 没评价，初始化数据
- (void)initData
{
    for (MySPCourseTeacherList * domain in self.teacherList)
    {
        domain.score = @"50";
    }
    
    self.courseDomain.content = @"请写下评价";
    self.courseDomain.score = @"50";
    self.schoolDomain.score = @"50";
}

#pragma mark - 若评价了，把返回数据分类
- (void)separateData
{
    if (self.commentsArr.count != 0)
    {
        for (MySPCommentDomain * data in self.commentsArr)
        {
            if (data.type == Topic_PXKC)
            {
                self.courseDomain = data;
            }
            
            else if (data.type == Topic_PXJG)
            {
                self.schoolDomain = data;
            }
            
            else if (data.type == Topic_PXJS)
            {
                for (MySPCourseTeacherList *listDomain in self.teacherList)
                {
                    if ([listDomain.uuid isEqualToString:data.ext_uuid])
                    {
                        listDomain.score = data.score;
                    }
                }
            }
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if(section == 1)
    {
        if (self.flag == NO)  //没获取到我的评价
        {
            return self.teacherList.count + 1;
        }
        else
        {
            return 1 + self.teacherList.count;
        }
    }
    else
    {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        MySPCourseCommentCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"MySPCourseCommentCell" owner:nil options:nil] firstObject];
        
        if (self.flag == YES)
        {
            [cell setData:self.courseDomain];
            
//            cell.textView.editable = NO;
            
//            cell.textView.backgroundColor = [UIColor whiteColor];
            
            cell.textView.textColor = [UIColor blackColor];
            
            for (UIButton * v in cell.starView.subviews)
            {
                v.enabled = NO;
            }
        }
        else
        {
            [cell setData:self.courseDomain];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)  //学校
        {
            MySPNormalCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"MySPNormalCell" owner:nil options:nil] firstObject];
            
            [cell setSchoolData:self.schoolDomain];
            
            if (self.flag == YES)
            {
                for (UIButton * b in cell.starView.subviews)
                {
//                    b.enabled = NO;
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        else                     //教师
        {
            MySPNormalCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"MySPNormalCell" owner:nil options:nil] firstObject];
            
            [cell setData:self.teacherList[indexPath.row - 1]];
            
            if (self.flag == YES)
            {
                for (UIButton * b in cell.starView.subviews)
                {
//                    b.enabled = NO;
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
    
    if (indexPath.section == 2)
    {
        MySPButtonCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"MySPButtonCell" owner:nil options:nil] firstObject];
        
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        if (self.flag == YES)
        {
            cell.btn.backgroundColor = [UIColor grayColor];
            
            [cell.btn setTitle:@"已评价" forState:UIControlStateNormal];
            
//            cell.btn.enabled = NO;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone; 
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 160;
    }
    
    if (indexPath.section == 1)
    {
        return 50;
    }
    
    if (indexPath.section == 2)
    {
        return 40;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1;
    }
    else
    {
        return 10;
    }
}

@end
