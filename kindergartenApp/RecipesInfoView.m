//
//  RecipesInfoView.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/8/8.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "RecipesInfoView.h"
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

#define RecipesInfoCellIdentifier  @"RecipesInfoCellIdentifier"
#define RecipesDescCellIdentifier  @"RecipesDescCellIdentifier"
#define RecipesNoteCellIdentifier  @"RecipesNoteCellIdentifier"

@implementation RecipesInfoView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initTableView];
    }
    
    return self;
}

- (void)initTableView {
    recipesTableView = [[UITableView alloc] initWithFrame:CGRectMake(Number_Zero, Number_Zero, self.width, APPWINDOWHEIGHT-APPWINDOWTOPHEIGHTIOS7)];
    recipesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    recipesTableView.separatorColor = [UIColor clearColor];
    recipesTableView.delegate   = self;
    recipesTableView.dataSource = self;
    [self addSubview:recipesTableView];
}


- (NSMutableArray *)tableDataSource {
    if(!_tableDataSource) {
        _tableDataSource = [[NSMutableArray alloc] init];
    }
    return _tableDataSource;
}

- (NSMutableArray *)allRecipesArrsy {
    if(!_allRecipesArray) {
        _allRecipesArray = [[NSMutableArray alloc] init];
    }
    return _allRecipesArray;
}


//加载食谱数据
- (void)loadRecipesData:(NSMutableArray *)recipesArray {
    self.allRecipesArray = recipesArray;
    
    [self packageTableData];
    [recipesTableView reloadData];
}

- (void)packageTableData {
    [self.tableDataSource removeAllObjects];
    
    for(RecipesDomain * recipesDomain in _allRecipesArray) {
        RecipesItemVO * itemVO1 = [[RecipesItemVO alloc] initItemVO:recipesDomain.plandate cbArray:nil];
        itemVO1.headHeight = 15;
        itemVO1.cellHeight = 59;
        itemVO1.recipesItemType = RecipesItem_Base;
        itemVO1.recipesDomain = recipesDomain;
        [self.tableDataSource addObject:itemVO1];
        
        if(recipesDomain.isReqSuccessData) {
            if(recipesDomain.list_time_1 && [recipesDomain.list_time_1 count]>Number_Zero) {
                RecipesItemVO * itemVO2 = [[RecipesItemVO alloc] initItemVO:@"早餐" cbArray:recipesDomain.list_time_1];
                itemVO2.headHeight = 30;
                itemVO2.cellHeight = [self getCellHeight:[recipesDomain.list_time_1 count]];
                itemVO2.recipesItemType = RecipesItem_Recip;
                [self.tableDataSource addObject:itemVO2];
            }
            
            if(recipesDomain.list_time_2 && [recipesDomain.list_time_2 count]>Number_Zero) {
                RecipesItemVO * itemVO3 = [[RecipesItemVO alloc] initItemVO:@"早上加餐" cbArray:recipesDomain.list_time_2];
                itemVO3.headHeight = 30;
                itemVO3.cellHeight = [self getCellHeight:[recipesDomain.list_time_2 count]];
                itemVO3.recipesItemType = RecipesItem_Recip;
                [self.tableDataSource addObject:itemVO3];
            }
            
            if(recipesDomain.list_time_3 && [recipesDomain.list_time_3 count]>Number_Zero) {
                RecipesItemVO * itemVO4 = [[RecipesItemVO alloc] initItemVO:@"午餐" cbArray:recipesDomain.list_time_3];
                itemVO4.headHeight = 30;
                itemVO4.cellHeight = [self getCellHeight:[recipesDomain.list_time_3 count]];
                itemVO4.recipesItemType = RecipesItem_Recip;
                [self.tableDataSource addObject:itemVO4];
            }
            
            if(recipesDomain.list_time_4 && [recipesDomain.list_time_4 count]>Number_Zero) {
                RecipesItemVO * itemVO5 = [[RecipesItemVO alloc] initItemVO:@"下午加餐" cbArray:recipesDomain.list_time_4];
                itemVO5.headHeight = 30;
                itemVO5.cellHeight = [self getCellHeight:[recipesDomain.list_time_4 count]];
                itemVO5.recipesItemType = RecipesItem_Recip;
                [self.tableDataSource addObject:itemVO5];
            }
            
            if(recipesDomain.list_time_5 && [recipesDomain.list_time_5 count]>Number_Zero) {
                RecipesItemVO * itemVO6 = [[RecipesItemVO alloc] initItemVO:@"晚餐" cbArray:recipesDomain.list_time_5];
                itemVO6.headHeight = 30;
                itemVO6.cellHeight = [self getCellHeight:[recipesDomain.list_time_5 count]];
                itemVO6.recipesItemType = RecipesItem_Recip;
                [self.tableDataSource addObject:itemVO6];
            }
            
            TopicInteractionView * topicView = [self loadDZReplyView:recipesDomain];
            
            RecipesItemVO * itemVO7 = [[RecipesItemVO alloc] initItemVO:@"营养分析" cbArray:nil];
            itemVO7.headHeight = 30;
            itemVO7.cellHeight = topicView.topicInteractionFrame.topicInteractHeight + 160 +  Number_Ten;
            itemVO7.recipesItemType = RecipesItem_Desc;
            itemVO7.dzReplyView = topicView;
            itemVO7.recipesDomain = recipesDomain;
            [self.tableDataSource addObject:itemVO7];
        } else {
            RecipesItemVO * itemVO8 = [[RecipesItemVO alloc] initItemVO:nil cbArray:nil];
            itemVO8.headHeight = 0;
            itemVO8.cellHeight = 80;
            itemVO8.recipesItemType = RecipesItem_None;
            itemVO8.dzReplyView = [self loadNoDataView];
            [self.tableDataSource addObject:itemVO8];
        }
        
    }
    
}

- (CGFloat)getCellHeight:(NSInteger)total {
    NSInteger pageSize = Number_Three;
    NSInteger page = (total + pageSize - Number_One) / pageSize;
    return 70 * page;
}

- (UIView *)loadNoDataView {
    PromptView * pView = [[[NSBundle mainBundle] loadNibNamed:@"PromptView" owner:nil options:nil] lastObject];
//    pView.size = CGSizeMake(APPWINDOWWIDTH, 80);
//    pView.origin = CGPointMake(0, 0);
    return pView;
}


#pragma UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.tableDataSource count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return Number_One;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    RecipesItemVO * itemVO = [self.tableDataSource objectAtIndex:section];
    return itemVO.headHeight;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    RecipesItemVO * itemVO = [self.tableDataSource objectAtIndex:section];
    if(itemVO.recipesItemType != RecipesItem_Base) {
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
    RecipesItemVO * itemVO = [self.tableDataSource objectAtIndex:indexPath.section];
    switch (itemVO.recipesItemType) {
        case RecipesItem_Base:
            //学生基本信息
            return [self loadStudentInfoCell:tableView cellForRowAtIndexPath:indexPath];
            break;
        case RecipesItem_Recip:
            return [self loadRecipesCell:tableView cellForRowAtIndexPath:indexPath];
            break;
        case RecipesItem_Desc:
            return [self loadRecipesNote:tableView cellForRowAtIndexPath:indexPath];
            break;
        case RecipesItem_None:
            return [self loadNoRecipesData:tableView cellForRowAtIndexPath:indexPath];
            break;
    }
}


- (UITableViewCell *)loadStudentInfoCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecipesItemVO * itemVO = [self.tableDataSource objectAtIndex:indexPath.section];
    RecipesStudentInfoTableViewCell * cell = [RecipesStudentInfoTableViewCell cellWithTableView:tableView];
    cell.backgroundColor = KGColorFrom16(0xff4966);
    [cell resetCellParam:itemVO];
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
    RecipesItemVO * itemVO = [self.tableDataSource objectAtIndex:indexPath.section];
    return itemVO.cellHeight;
}

//加载菜谱
- (void)loadRecipes:(RecipesItemVO *)recipesVO cell:(UITableViewCell *)cell {
    CGRect frame = CGRectMake(CELLPADDING, Number_Zero, CELLCONTENTWIDTH, cell.height);
    UIView * recipesImgsView = [[UIView alloc] initWithFrame:frame];
    
    CGFloat w = (frame.size.width - CELLPADDING * Number_Two) / Number_Three;
    CGFloat h = 70;
    CGFloat index = Number_Zero;
    CGFloat row   = Number_Zero;
    
    UIImageView * imageView = nil;
    UIButton    * btn = nil;
    for(CookbookDomain * cookbook in recipesVO.cookbookArray) {
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CELLPADDING + index * w, row * h, w, h)];
        imageView.backgroundColor = [UIColor clearColor];
        [imageView setClipsToBounds:YES];
        [imageView setContentMode:UIViewContentModeScaleToFill];
        [recipesImgsView addSubview:imageView];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:cookbook.img] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        btn = [[UIButton alloc] initWithFrame:CGRectMake(index * w, imageView.y, w, h)];
        btn.targetObj = imageView;
        objc_setAssociatedObject(btn, "cookbook", cookbook, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [btn addTarget:self action:@selector(showRecipesImgClicked:) forControlEvents:UIControlEventTouchUpInside];
        [recipesImgsView addSubview:btn];
        
        index++;
        
        if(index == Number_Three) {
            index = Number_Zero;
            row++;
        }
    }
    
    frame.size.height = CGRectGetMaxY(imageView.frame);
    recipesImgsView.frame = frame;
    
    [cell addSubview:recipesImgsView];
}

//加载营养分析及帖子回复
- (UITableViewCell *)loadRecipesNote:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RecipesDescCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.backgroundColor = [UIColor clearColor];
    
    RecipesItemVO * itemVO = [self.tableDataSource objectAtIndex:indexPath.section];
    
    if(itemVO.recipesDomain.isReqSuccessData) {
        KGTextView * textView = [[KGTextView alloc] initWithFrame:CGRectMake(CELLPADDING, Number_Five, CELLCONTENTWIDTH, 150)];
        [textView setBorderWithWidth:Number_One color:[UIColor blackColor] radian:Number_Five];
        textView.text = itemVO.recipesDomain.analysis;
        textView.editable = NO;
        [cell addSubview:textView];
        
        if(itemVO.dzReplyView) {
            [cell addSubview:itemVO.dzReplyView];
        }
    }
    
    return cell;
}

//加载无数据提示cell
- (UITableViewCell *)loadNoRecipesData:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:RecipesNoteCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RecipesNoteCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = [UIColor clearColor];
    
//    for(UIView * view in cell.subviews) {
//        [view removeFromSuperview];
//    }
    
    RecipesItemVO * itemVO = [self.tableDataSource objectAtIndex:indexPath.section];
    [cell addSubview:itemVO.dzReplyView];
    
    NSLog(@"ccell:%@", NSStringFromCGRect(cell.frame));
    return cell;
}

//加载点赞回复
- (TopicInteractionView *)loadDZReplyView:(RecipesDomain *)recipesDomain {
    if(recipesDomain.dianzan) {
        TopicInteractionDomain * topicInteractionDomain = [TopicInteractionDomain new];
        topicInteractionDomain.dianzan   = recipesDomain.dianzan;
        topicInteractionDomain.replyPage = recipesDomain.replyPage;
        topicInteractionDomain.topicType = Topic_Recipes;
        topicInteractionDomain.topicUUID = recipesDomain.uuid;
        
        TopicInteractionFrame * topicFrame = [TopicInteractionFrame new];
        topicFrame.topicInteractionDomain  = topicInteractionDomain;
        
        CGRect frame = CGRectMake(Number_Zero, 160, KGSCREEN.size.width, topicFrame.topicInteractHeight);
        TopicInteractionView * topicView = [[TopicInteractionView alloc] initWithFrame:frame];
        [topicViewCell addSubview:topicView];
        topicView.topicInteractionFrame = topicFrame;
        return topicView;
    }
    
    return nil;
}

- (void)showRecipesImgClicked:(UIButton *)sender{
    UIImageView * imageView = (UIImageView *)sender.targetObj;
    CookbookDomain * cookbook = objc_getAssociatedObject(sender, "cookbook");
    [UUImageAvatarBrowser showImage:imageView url:cookbook.img];
}

//重置回复内容
- (void)resetTopicReplyContent:(ReplyDomain *)domain topicInteraction:(TopicInteractionDomain *)topicInteractionDomain {
    //1.对应食谱增加回复
    RecipesDomain * recipesDomain = nil;
    for(RecipesDomain * domain in _allRecipesArray) {
        if([domain.uuid isEqualToString:topicInteractionDomain.topicUUID]) {
            recipesDomain = domain;
            break;
        }
    }
    
    if(recipesDomain) {
        ReplyPageDomain * replyPageDomain = recipesDomain.replyPage;
        if(!replyPageDomain) {
            replyPageDomain = [[ReplyPageDomain alloc] init];
        }
        [replyPageDomain.data insertObject:domain atIndex:Number_Zero];
        replyPageDomain.totalCount++;
        
        //2.重新加载点赞回复view
        [self packageTableData];
        [recipesTableView reloadData];
    }
}

@end
