//
//  TeacherJudgeTableViewCell.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/28.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "TeacherJudgeTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
#import "UIColor+Extension.h"
#import "KGNSStringUtil.h"
#import "UIButton+Extension.h"

#define judgeTeacherDefText  @"说点什么吧..."

@implementation TeacherJudgeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _isClicked = YES;
    _judgeTextView.placeholder = judgeTeacherDefText;
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
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_teachVO.img] placeholderImage:[UIImage imageNamed:@"head_def"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.headImageView setBorderWithWidth:Number_Zero color:KGColorFrom16(0xE7E7EE) radian:self.headImageView.width / Number_Two];
    }];

    
    if(_teachVO.teacheruuid) {
        //已经评价
        _judgeTextView.text = _teachVO.content;
        [self judgedHandler];
    }
//    else {
//        _judgeTextView.text = judgeTeacherDefText;
//    }
    
}

- (IBAction)judgeBtnClicked:(UIButton *)sender {
    
    if (_isClicked) {
        if(lastSelTag > Number_Zero && lastSelTag!=sender.tag) {
            UIImageView * imageView = (UIImageView *)[self viewWithTag:lastSelTag * Number_Ten];
            NSString * imgName = [NSString stringWithFormat:@"judge_no_%ld", (long)lastSelTag];
            imageView.image = [UIImage imageNamed:imgName];
        }
        
        UIImageView * imageView = (UIImageView *)[self viewWithTag:sender.tag * Number_Ten];
        NSString * imgName = [NSString stringWithFormat:@"judge_yes_%ld", (long)sender.tag];
        imageView.image = [UIImage imageNamed:imgName];
        
        lastSelTag = sender.tag;
    }
    
}

- (IBAction)submitBtnClicked:(UIButton *)sender {
    _teachVO.content = [KGNSStringUtil trimString:_judgeTextView.text];
    _teachVO.type = lastSelTag / Number_Ten;
    _teachVO.teacheruuid = _teachVO.teacher_uuid;
    NSDictionary *dic = @{@"tearchVO" : _teachVO, @"tableViewCell" : self};
    [[NSNotificationCenter defaultCenter] postNotificationName:Key_Notification_TeacherJudge object:self userInfo:dic];
}


- (void)judgedHandler {
    _judgeTextView.editable = NO;
    _submitBtn.enabled = YES;
    _submitBtn.userInteractionEnabled = NO;
    _isClicked = NO;
    [_submitBtn setText:@"已评价"];
    [_submitBtn setBackgroundImage:@"" selImg:@""];
    UIImageView * imageView = (UIImageView *)[self viewWithTag:_teachVO.type * 100];
    NSUInteger flag = _teachVO.type==0?10:_teachVO.type*Number_Ten;
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"judge_yes_%ld", flag]];
}

@end
