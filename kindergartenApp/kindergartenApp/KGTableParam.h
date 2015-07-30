//
//  FuniPullReFresh.h
//  Guarantee
//  拉动刷新 参数对象
//  Created by rockyang on 14-5-14.
//  Copyright (c) 2014年 LQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KGTableParam : NSObject

//cell高度
@property (assign, nonatomic) NSInteger             cellHeight;

//section数量 默认为1
@property (assign, nonatomic) NSInteger             sectionCount;

//是否支持下拉刷新
@property (assign, nonatomic) bool                  isPullReFresh;

//是否支持上拉加载更多
@property (assign, nonatomic) bool                  isUpPullReFresh;

//选中cell后需要跳转的class名字
@property (strong, nonatomic) NSString            * selToClassNameStr;

//cell绑定的class名称  必须是继承FuniBaseCell的子类
@property (strong, nonatomic) NSString            * cellClassNameStr;

//表格数据源
@property (strong, nonatomic) NSArray      * dataSourceMArray;

//cell扩展字典
@property (strong, nonatomic) NSMutableDictionary * paramMDict;

//cell是否有选中状态
@property (assign, nonatomic) BOOL                  isSelectedStatus;

//cell默认背景色
@property (assign, nonatomic) UIColor             * cellDefBgColor;

//cell选中背景色
@property (assign, nonatomic) UIColor             * cellSelBgColor;


@end
