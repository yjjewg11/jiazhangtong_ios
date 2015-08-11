//
//  StudentSignRecordViewController.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "StudentSignRecordViewController.h"
#import "StudentSignRecordTableViewCell.h"
#import "StudentSignRecordDomain.h"
#import "KGHttpService.h"
#import "KGHUD.h"

#define StudentSignRecordCellIdentifier  @"StudentSignRecordCellIdentifier"

@interface StudentSignRecordViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView * signRecordTableView;
    
    //学生数据 因学生需要分组显示 所以返回的数据需要分组封装
    //key=学生uuid  value=学生的打卡记录集合
    NSMutableDictionary * studentSignRecordMDic;
    //table数据源
    NSMutableArray      * dataSourceMArray;
}

@end

@implementation StudentSignRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"签到记录";
    
    signRecordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    signRecordTableView.separatorColor = [UIColor clearColor];
    signRecordTableView.backgroundColor = [UIColor clearColor];
    signRecordTableView.delegate   = self;
    signRecordTableView.dataSource = self;
    
    studentSignRecordMDic = [[NSMutableDictionary alloc] init];
    [self getSsignRecordData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//获取签到数据
- (void)getSsignRecordData {
    
    [[KGHUD sharedHud] show:self.contentView];
    [[KGHttpService sharedService] getStudentSignRecordList:^(NSArray *recordArray) {
        
        [[KGHUD sharedHud] hide:self.contentView];
        [self packageSignRecord:recordArray];
        
    } faild:^(NSString *errorMsg) {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
    }];
}

//更正学生打卡记录数据
- (void)packageSignRecord:(NSArray *)recordArray {
    
    for(StudentSignRecordDomain * domain in recordArray) {
        [self addStudentSignRecord:domain];
    }
    
    dataSourceMArray = [[NSMutableArray alloc] init];
    
    for(NSString * key in studentSignRecordMDic.allKeys) {
        [dataSourceMArray addObject:[studentSignRecordMDic objectForKey:key]];
    }
    
    [signRecordTableView reloadData];
}


//学生打卡记录追加
- (void)addStudentSignRecord:(StudentSignRecordDomain *)domain {
    NSMutableArray * recordMArray = [studentSignRecordMDic objectForKey:domain.studentuuid];
    if(!recordMArray) {
        recordMArray = [[NSMutableArray alloc] init];
        [studentSignRecordMDic setValue:recordMArray forKey:domain.studentuuid];
    }
    
    [recordMArray addObject:domain];
}


#pragma UITableView delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [dataSourceMArray count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(dataSourceMArray && [dataSourceMArray count]>Number_Zero) {
        NSMutableArray * studentRecordMArray = [dataSourceMArray objectAtIndex:section];
        return [studentRecordMArray count];
    }
    return Number_One;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StudentSignRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:StudentSignRecordCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StudentSignRecordTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:Number_Zero];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSMutableArray * studentRecordMArray = [dataSourceMArray objectAtIndex:indexPath.section];
    StudentSignRecordDomain * domain = [studentRecordMArray objectAtIndex:indexPath.row];
    [cell resetValue:domain parame:nil];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 97;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
