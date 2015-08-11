//
//  TimetableItemView.m
//  kindergartenApp
//
//  Created by You on 15/8/10.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "TimetableItemView.h"

@implementation TimetableItemView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initTableView];
    }
    
    return self;
}

- (void)initTableView {
    timetableTableView = [[UITableView alloc] initWithFrame:CGRectMake(Number_Zero, Number_Zero, self.width, self.height)];
    timetableTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    timetableTableView.separatorColor = [UIColor clearColor];
    timetableTableView.delegate   = self;
    timetableTableView.dataSource = self;
    [self addSubview:timetableTableView];
}


- (NSMutableArray *)tableDataSource {
    if(!_tableDataSource) {
        _tableDataSource = [[NSMutableArray alloc] init];
    }
    return _tableDataSource;
}


//加载食谱数据
- (void)loadRecipesData:(TimetableDomain *)timetable {
    _timetableDomain = timetable;
    
//    [self packageTableData];
    [timetableTableView reloadData];
    
    NSLog(@"table:%@", NSStringFromCGRect(timetableTableView.frame));
}

#pragma UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.tableDataSource count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==Number_Zero || section==[self.tableDataSource count]-Number_One) {
        
    }
    return Number_One;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == Number_Zero) {
        return 0;
    } else {
        return 30;
    }
}


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if(section!=Number_Zero && _recipesDomain.isReqSuccessData) {
//        RecipesItemVO * itemVO = [self.tableDataSource objectAtIndex:section];
//        
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RecipesHeadTableViewCell" owner:nil options:nil];
//        RecipesHeadTableViewCell * view = (RecipesHeadTableViewCell *)[nib objectAtIndex:Number_Zero];
//        [view resetHead:itemVO.headStr];
//        view.backgroundColor = KGColorFrom16(0xE7E7EE);
//        return view;
//    }
//    
//    return nil;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(indexPath.section == Number_Zero) {
//        //学生基本信息
//        return [self loadStudentInfoCell:tableView cellForRowAtIndexPath:indexPath];
//    } else if(indexPath.section == [self.tableDataSource count]-Number_One){
//        return [self loadRecipesNote:tableView];
//    } else {
//        return [self loadRecipesCell:tableView cellForRowAtIndexPath:indexPath];
//    }
//}
//
//
//- (UITableViewCell *)loadStudentInfoCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    RecipesStudentInfoTableViewCell * cell = [RecipesStudentInfoTableViewCell cellWithTableView:tableView];
//    cell.backgroundColor = [UIColor clearColor];
//    [cell resetCellParam:_recipesDomain];
//    return cell;
//}
//
//
//- (UITableViewCell *)loadRecipesCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:RecipesInfoCellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RecipesInfoCellIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    
//    cell.backgroundColor = [UIColor clearColor];
//    
//    RecipesItemVO * itemVO = [self.tableDataSource objectAtIndex:indexPath.section];
//    [self loadRecipes:itemVO cell:cell];
//    
//    return cell;
//}
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(indexPath.section == Number_Zero) {
//        return 59;
//    } else if (indexPath.section == [self.tableDataSource count]-Number_One) {
//        return 380;
//    } else {
//        RecipesItemVO * itemVO = [self.tableDataSource objectAtIndex:indexPath.section];
//        NSInteger total = [itemVO.cookbookArray count];
//        NSInteger pageSize = Number_Three;
//        NSInteger page = (total + pageSize - Number_One) / pageSize;
//        return 70 * page;
//    }
//}


@end
