//
//  RecipesCollectionViewCell.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "RecipesCollectionViewCell.h"
#import "RecipesItemVO.h"
#import "RecipesHeadTableViewCell.h"
#import "UIColor+Extension.h"
#import "RecipesStudentInfoTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "KGTextView.h"
#import "TopicInteractionView.h"
#import "UIView+Extension.h"
#import "UUImageAvatarBrowser.h"
#import "UIButton+Extension.h"
#import <objc/runtime.h>
#import "CookbookDomain.h"
#import "KGHUD.h"
#import "KGHttpService.h"

#define RecipesInfoCellIdentifier  @"RecipesInfoCellIdentifier"
#define RecipesNoteCellIdentifier  @"RecipesNoteCellIdentifier"

@implementation RecipesCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    recipesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    recipesTableView.separatorColor = [UIColor clearColor];
    recipesTableView.delegate   = self;
    recipesTableView.dataSource = self;
    
    self.backgroundColor = [UIColor grayColor];
}

- (NSMutableArray *)tableDataSource {
    if(!_tableDataSource) {
        _tableDataSource = [[NSMutableArray alloc] init];
    }
    return _tableDataSource;
}


//加载食谱数据
- (void)loadRecipesData:(RecipesDomain *)recipesDomain; {
    recipes = recipesDomain;
    
    [self packageTableData];
    [recipesTableView reloadData];
}

//加载食谱数据
- (void)loadRecipesInfoByData:(NSString *)dateStr {
    [[KGHUD sharedHud] show:self];
    
    [[KGHttpService sharedService] getRecipesList:dateStr endDate:nil success:^(NSArray *recipesArray) {
        
        [[KGHUD sharedHud] hide:self];
        
        RecipesDomain * tempDomain = [[RecipesDomain alloc] init];
        tempDomain.plandate = dateStr;
        if(recipesArray && [recipesArray count]>Number_Zero) {
            tempDomain = [recipesArray objectAtIndex:Number_Zero];
        }
        
        [self packageTableData];
        [recipesTableView reloadData];
        
    } faild:^(NSString *errorMsg) {
        [[KGHUD sharedHud] show:self.contentView onlyMsg:errorMsg];
    }];
}

- (void)packageTableData {
    [self.tableDataSource removeAllObjects];
    
    RecipesItemVO * itemVO1 = [[RecipesItemVO alloc] initItemVO:recipes.plandate cbArray:nil];
    [self.tableDataSource addObject:itemVO1];
    
    if(recipes.list_time_1 && [recipes.list_time_1 count]>Number_Zero) {
        RecipesItemVO * itemVO2 = [[RecipesItemVO alloc] initItemVO:@"早餐" cbArray:recipes.list_time_1];
        [self.tableDataSource addObject:itemVO2];
    }
    
    if(recipes.list_time_2 && [recipes.list_time_2 count]>Number_Zero) {
        RecipesItemVO * itemVO3 = [[RecipesItemVO alloc] initItemVO:@"早上加餐" cbArray:recipes.list_time_2];
        [self.tableDataSource addObject:itemVO3];
    }
    
    if(recipes.list_time_3 && [recipes.list_time_3 count]>Number_Zero) {
        RecipesItemVO * itemVO4 = [[RecipesItemVO alloc] initItemVO:@"午餐" cbArray:recipes.list_time_3];
        [self.tableDataSource addObject:itemVO4];
    }
    
    if(recipes.list_time_4 && [recipes.list_time_4 count]>Number_Zero) {
        RecipesItemVO * itemVO5 = [[RecipesItemVO alloc] initItemVO:@"下午加餐" cbArray:recipes.list_time_4];
        [self.tableDataSource addObject:itemVO5];
    }
    
    if(recipes.list_time_5 && [recipes.list_time_5 count]>Number_Zero) {
        RecipesItemVO * itemVO6 = [[RecipesItemVO alloc] initItemVO:@"晚餐" cbArray:recipes.list_time_5];
        [self.tableDataSource addObject:itemVO6];
    }
    
    RecipesItemVO * itemVO7 = [[RecipesItemVO alloc] initItemVO:@"营养分析" cbArray:nil];
    [self.tableDataSource addObject:itemVO7];
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


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section!=Number_Zero) {
        RecipesItemVO * itemVO = [self.tableDataSource objectAtIndex:section];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RecipesHeadTableViewCell" owner:nil options:nil];
        RecipesHeadTableViewCell * view = (RecipesHeadTableViewCell *)[nib objectAtIndex:Number_Zero];
        [view resetHead:itemVO.headStr];
        view.backgroundColor = KGColorFrom16(0xE7E7EE);
        return view;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == Number_Zero) {
        //学生基本信息
        return [self loadStudentInfoCell:tableView cellForRowAtIndexPath:indexPath];
    } else if(indexPath.section == [self.tableDataSource count]-Number_One){
        return [self loadRecipesNote:tableView];
    } else {
        return [self loadRecipesCell:tableView cellForRowAtIndexPath:indexPath];
    }
}


- (UITableViewCell *)loadStudentInfoCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecipesStudentInfoTableViewCell * cell = [RecipesStudentInfoTableViewCell cellWithTableView:tableView];
    cell.backgroundColor = [UIColor clearColor];
    [cell resetCellParam:recipes];
    return cell;
}


- (UITableViewCell *)loadRecipesCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:RecipesInfoCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RecipesInfoCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    RecipesItemVO * itemVO = [self.tableDataSource objectAtIndex:indexPath.section];
    [self loadRecipes:itemVO cell:cell];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == Number_Zero) {
        return 59;
    } else if (indexPath.section == [self.tableDataSource count]-Number_One) {
        return 380;
    } else {
        return 70;
    }
}

//加载菜谱
- (void)loadRecipes:(RecipesItemVO *)recipesVO cell:(UITableViewCell *)cell {
    CGRect frame = CGRectMake(CELLPADDING, Number_Zero, CELLCONTENTWIDTH, cell.height);
    UIView * recipesImgsView = [[UIView alloc] initWithFrame:frame];
    
    CGFloat y = Number_Zero;
    CGFloat w = (frame.size.width - CELLPADDING) / Number_Three;
    CGFloat h = 70;
    CGFloat index = Number_Zero;
    
    UIImageView * imageView = nil;
    UIButton    * btn = nil;
    for(CookbookDomain * cookbook in recipesVO.cookbookArray) {
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(index * w, y, w, h)];
        [recipesImgsView addSubview:imageView];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:cookbook.img] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        btn = [[UIButton alloc] initWithFrame:CGRectMake(index * w, y, w, h)];
        btn.targetObj = imageView;
        objc_setAssociatedObject(btn, "cookbook", cookbook, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [btn addTarget:self action:@selector(showRecipesImgClicked:) forControlEvents:UIControlEventTouchUpInside];
        [recipesImgsView addSubview:btn];
        
        if(index == Number_Two) {
            index = Number_Zero;
            y += h;
        }
        
        index++;
    }
    
    frame.size.height = h + (y * h);
    recipesImgsView.frame = frame;
    
    [cell addSubview:recipesImgsView];
}

//加载营养分析及帖子回复
- (UITableViewCell *)loadRecipesNote:(UITableView *)tableView {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:RecipesNoteCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RecipesNoteCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = [UIColor clearColor];
    KGTextView * textView = [[KGTextView alloc] initWithFrame:CGRectMake(CELLPADDING, Number_Five, CELLCONTENTWIDTH, 150)];
    [textView setBorderWithWidth:Number_One color:[UIColor blackColor] radian:Number_Five];
    textView.text = recipes.analysis;
    [cell addSubview:textView];
    
    
//    CGFloat y = CGRectGetMaxY(textView.frame) + Number_Ten;
//    CGRect frame = CGRectMake(Number_Zero, y, KGSCREEN.size.width, 56);
//    TopicInteractionView * topicView = [[TopicInteractionView alloc] initWithFrame:frame];
//    [topicView loadFunView:recipes.dianzan reply:recipes.replyPage];
//    topicView.topicType = Topic_Recipes;
//    topicView.topicUUID = recipes.uuid;
//    [cell addSubview:topicView];
//    [topicView loadFunView:recipes.dianzan reply:recipes.replyPage];
    
    return cell;
}

- (void)showRecipesImgClicked:(UIButton *)sender{
    UIImageView * imageView = (UIImageView *)sender.targetObj;
    CookbookDomain * cookbook = objc_getAssociatedObject(sender, "cookbook");
    [UUImageAvatarBrowser showImage:imageView url:cookbook.img];
}

@end
