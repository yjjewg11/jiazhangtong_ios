//
//  ReFreshBaseCell.m
//  kindergartenApp
//
//  Created by You on 15/7/17.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "ReFreshBaseCell.h"
#import "Masonry.h"

#define tableViewCellDelBtn               @"UITableViewCellDeleteConfirmationControl"

@implementation ReFreshBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCellStyle];
        [self initSpliteLineLabel];
    }
    return self;
}


/**
 *  初始化自定义cell分割线
 */
- (void)initSpliteLineLabel{
    if(!spliteLabel){
        spliteLabel = [[UILabel alloc] init];
        spliteLabel.backgroundColor = CELL_SPLITE_COLOR;
        spliteLabel.opaque          = YES;
        spliteLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:spliteLabel];
        
        [spliteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(CELL_RECTRACT_WIDTH);
            make.right.equalTo(self.contentView.mas_right).offset(-CELL_RECTRACT_WIDTH);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-0.5);
            make.height.equalTo(@0.5);
        }];
        
    }
}


- (void)awakeFromNib
{
    // Initialization code
    [self initCellStyle];
    [self initSpliteLineLabel];
}


/**
 *  初始化设置cell的style
 */
- (void)initCellStyle {
    self.selectionStyle              = UITableViewCellSelectionStyleNone;
    self.autoresizingMask            = UIViewAutoresizingFlexibleRightMargin;
}


/**
 *  清空cell里面内容
 */
- (void)clearContentView {
    for(UIView * view in [self.contentView subviews]){
        [view removeFromSuperview];
    }
}


/**
 *  初始化加载cell内容
 *
 *  @param baseDomain   cell需要的数据对象
 *  @param parameterDic 扩展字典
 */
- (void)initBaseCell:(id)baseDomain parame:(NSMutableDictionary *)parameterDic {
    [self clearContentView];
}


/**
 *  重置cell内容
 *
 *  @param baseDomain   cell需要的数据对象
 *  @param parameterDic 扩展字典
 */
- (void)resetValue:(id)baseDomain parame:(NSMutableDictionary *)parameterDic {
    //是否不缩进分割线
    BOOL isRectract = (BOOL)[parameterDic objectForKey:CELL_ISRECTRACT];
    if(isRectract){
        [spliteLabel setX:0];
        [spliteLabel setWidth:self.frame.size.width];
    }
}


/**
 *  隐藏分割线
 */
- (void)hiddenSpliteLine {
    spliteLabel.hidden = YES;
}


#pragma cellDelegate

/**
 *  cell状态change之前
 *
 *  @param state cell 状态
 */
- (void)willTransitionToState:(UITableViewCellStateMask)state{
    [super willTransitionToState: state];
    [self resetCellDeleteBtnFrame:YES state:state];
}


/**
 *  cell状态change之后
 *
 *  @param state cell 状态
 */
- (void)didTransitionToState:(UITableViewCellStateMask)state{
    [super didTransitionToState: state];
    [self resetCellDeleteBtnFrame:NO state:state];
}


/**
 *  重置删除按钮的Frame
 *
 *  @param isWill 是否出现删除按钮
 *  @param state  cell的状态
 */
- (void)resetCellDeleteBtnFrame:(bool)isWill state:(UITableViewCellStateMask)state{
    //状态为show删除按钮
    if(state == UITableViewCellStateShowingDeleteConfirmationMask || state==3){
        UIView * deleteButtonView = [self getTableViewCellDelBtn];
        UIView * view = Nil;
        if(isWill){
            view = [[UIView alloc] initWithFrame:CGRectMake(deleteButtonView.frame.origin.x-CELL_RECTRACT_WIDTH*3, 1, deleteButtonView.frame.size.width+CELL_RECTRACT_WIDTH*3, deleteButtonView.frame.size.height-1)];
            view.tag = 6;
            [self.contentView addSubview:view];
        }
    }
    //状态为结束编辑
    if(state == UITableViewCellStateShowingEditControlMask || state == UITableViewCellStateDefaultMask){
        if(!isWill){
            UIView * view = [self.contentView viewWithTag:6];
            [self viewAnimate:view];
        }
    }
}


/**
 *  获得cell里面删除按钮
 *
 *  @return 返回获取的删除按钮
 */
- (UIView *)getTableViewCellDelBtn{
    UIView * deleteButtonView = nil;
    for(UIView * subview in self.subviews){
        if([NSStringFromClass([subview class]) isEqualToString:tableViewCellDelBtn]){
            deleteButtonView = subview;
            break;
        }
    }
    return deleteButtonView;
}


/**
 *  动画改名删除背景x座标 并移除
 *
 *  @param delBtnBgView 删除按钮view
 */
- (void)viewAnimate:(UIView *)delBtnBgView{
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGRect c = delBtnBgView.frame;
                         c.origin.x += c.size.width;
                         delBtnBgView.frame = c;
                     }
                     completion:^(BOOL finished){
                         [delBtnBgView removeFromSuperview];
                     }];
    
}


/**
 *  cell加载的时候扩展处理
 */
- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.isEditing) {
        //解决IOS7 删除按钮不在最顶层
        [self sendSubviewToBack:self.contentView];
    }
    
}

@end
