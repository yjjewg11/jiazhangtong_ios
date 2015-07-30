//
//  TeacherJudgeTableViewCell.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/28.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "TeacherJudgeTableViewCell.h"

#define judgeTeacherDefText  @"说点什么吧..."

@implementation TeacherJudgeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_judgeTextView setBorderWithWidth:1 color:[UIColor blackColor] radian:10.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


/**
 *  重置cell内容
 *
 *  @param baseDomain   cell需要的数据对象
 *  @param parameterDic 扩展字典
 */
- (void)resetValue:(id)baseDomain parame:(NSMutableDictionary *)parameterDic {
    _teachVO = (TeacherVO *)baseDomain;
    _nameLabel.text = _teachVO.name;
    if(_teachVO.teacheruuid) {
        //已经评价
        _judgeTextView.text = _teachVO.content;
        _submitBtn.enabled = YES;
        _submitBtn.userInteractionEnabled = NO;
        
        UIImageView * imageView = (UIImageView *)[self viewWithTag:_teachVO.type * 100];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"judge_yes_%ld", (long)_teachVO.type]];
        
        
    } else {
        _judgeTextView.text = judgeTeacherDefText;
    }
    
}

- (IBAction)judgeBtnClicked:(UIButton *)sender {
    
    if(!_teachVO.teacheruuid) {
        if(lastSelTag > Number_Zero) {
            UIImageView * imageView = (UIImageView *)[self viewWithTag:lastSelTag * 10];
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"judge_no_%ld", (long)lastSelTag]];
        }
        
        UIImageView * imageView = (UIImageView *)[self viewWithTag:sender.tag * 10];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"judge_yes_%ld", (long)sender.tag]];
        
        lastSelTag = sender.tag;
    }
    
}

- (IBAction)submitBtnClicked:(UIButton *)sender {
    
}

@end
