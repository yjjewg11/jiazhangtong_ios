//
//  ReFreshBaseCell.h
//  kindergartenApp
//
//  Created by You on 15/7/17.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>

//cell分割线颜色
#define CELL_SPLITE_COLOR       [UIColor colorWithRed:229.0f / 255.0f green:229.0f / 255.0f blue:229.0f / 255.0f alpha:1.0f];

//cell分割线缩进宽度
#define CELL_RECTRACT_WIDTH     10

//cell分割线是否缩进
#define CELL_ISRECTRACT         @"isRectract"

//默认cell高度
#define CELL_DEFHEIGHT          44

#define CELL_DELTEXT            @"删除"

@interface ReFreshBaseCell : UITableViewCell {
    //cell分割线
    UILabel * spliteLabel;
}


/**
 *  初始化加载cell内容
 *
 *  @param baseDomain   cell需要的数据对象
 *  @param parameterDic 扩展字典
 */
- (void)initBaseCell:(id)baseDomain parame:(NSMutableDictionary *)parameterDic;


/**
 *  重置cell内容
 *
 *  @param baseDomain   cell需要的数据对象
 *  @param parameterDic 扩展字典
 */
- (void)resetValue:(id)baseDomain parame:(NSMutableDictionary *)parameterDic;


/**
 *  隐藏分割线
 */
- (void)hiddenSpliteLine;


@end
