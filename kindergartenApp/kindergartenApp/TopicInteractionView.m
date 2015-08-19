//
//  TopicInteractionView.m
//  kindergartenApp
//
//  Created by You on 15/7/30.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "TopicInteractionView.h"
#import "UIColor+Extension.h"
#import "UIView+Extension.h"
#import "UIButton+Extension.h"
#import "KGNSStringUtil.h"
#import "KGRange.h"
#import "KGDateUtil.h"

@implementation TopicInteractionView 

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        //加载功能按钮 (点赞、回复)
        [self initFunView];
        
        //加载点赞列表
        [self initDZLabel];
        
        //加载回复
        [self initReplyView];
        
        //加载显示更多
        [self loadMoreBtn];
        
        //加载回复输入框
        [self initReplyTextField];
    }
    
    return self;
}


//加载功能按钮 (点赞、回复)
- (void)initFunView {
    _funView = [[UIView alloc] init];
    _funView.backgroundColor = CLEARCOLOR;
//    funView.backgroundColor = [UIColor redColor];
    [self addSubview:_funView];
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.backgroundColor = CLEARCOLOR;
    _dateLabel.font = TopicCellDateFont;
    _dateLabel.textColor = KGColorFrom16(0x666666); //KGColorFrom16(0xff4966)
    [_funView addSubview:_dateLabel];
    
    _browseCountImageView = [[UIImageView alloc] init];
    _browseCountImageView.image = [UIImage imageNamed:@"eye"];
    [_funView addSubview:_browseCountImageView];
    
    _browseCountLabel = [[UILabel alloc] init];
    _browseCountLabel.backgroundColor = CLEARCOLOR;
    _browseCountLabel.font = TopicCellDateFont;
    _browseCountLabel.textColor = KGColorFrom16(0xff4966);
    [_funView addSubview:_browseCountLabel];
    
    //点赞按钮
    _dianzanBtn = [[UIButton alloc] init];
    [_dianzanBtn setBackgroundImage:@"anzan" selImg:@"hongzan"];
    _dianzanBtn.tag = Number_Ten;
    [_dianzanBtn addTarget:self action:@selector(topicDZBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_funView addSubview:_dianzanBtn];
    
    //回复按钮
    _replyBtn = [[UIButton alloc] init];
    [_replyBtn setBackgroundImage:@"pinglun" selImg:@"pinglun"];
    _replyBtn.tag = Number_Eleven;
    [_replyBtn addTarget:self action:@selector(replyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_funView addSubview:_replyBtn];
}

//加载点赞列表
- (void)initDZLabel {
    if(_dianzanView) {
        [_dianzanView removeFromSuperview];
    }
    _dianzanView = [[UIView alloc] init];
    _dianzanView.backgroundColor = CLEARCOLOR;
//    dzView.backgroundColor = [UIColor brownColor];
    [self addSubview:_dianzanView];
    
    _dianzanIconImg = [[UIImageView alloc] init];
    _dianzanIconImg.image = [UIImage imageNamed:@"wodehuizan"];
//    dzImage.backgroundColor = [UIColor redColor];
    [_dianzanView addSubview:_dianzanIconImg];
    
    //点赞列表
    _dianzanLabel = [MLEmojiLabel new];
    _dianzanLabel.backgroundColor = CLEARCOLOR;
    _dianzanLabel.numberOfLines = Number_Zero;
    _dianzanLabel.font = TopicCellDateFont;
    _dianzanLabel.textColor = [UIColor blackColor];
    [_dianzanView addSubview:_dianzanLabel];
}

//加载回复
- (void)initReplyView {
    if(_replyView) {
        [_replyView removeFromSuperview];
    }
    
    _replyView = [MLEmojiLabel new];
    _replyView.backgroundColor = [UIColor clearColor];
    _replyView.numberOfLines = Number_Zero;
    _replyView.font = [UIFont systemFontOfSize:APPUILABELFONTNO12];
    _replyView.textColor = [UIColor blackColor];
    _replyView.customEmojiRegex = String_DefValue_EmojiRegex;
    
    [self addSubview:_replyView];
}

//加载显示更多
- (void)loadMoreBtn {
    if(_moreBtn) {
        [_moreBtn removeFromSuperview];
    }
    
    _moreBtn = [[UIButton alloc] init];
    [_moreBtn setText:@"显示更多"];
    _moreBtn.backgroundColor = [UIColor clearColor];
    _moreBtn.titleLabel.font = [UIFont systemFontOfSize:Number_Ten];
    [_moreBtn setTextColor:[UIColor blueColor] sel:[UIColor blueColor]];
    [_moreBtn addTarget:self action:@selector(moreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_moreBtn];
}


//加载回复输入框
- (void)initReplyTextField {
    if(_replyTextField) {
        [_replyTextField removeFromSuperview];
    }
    _replyTextField = [[UIButton alloc] init];
    [_replyTextField setText:@"我来说一句..."];
    _replyTextField.titleLabel.font = [UIFont systemFontOfSize:APPUILABELFONTNO12];
    [_replyTextField setTextColor:[UIColor grayColor] sel:[UIColor grayColor]];
    _replyTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _replyTextField.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_replyTextField addTarget:self action:@selector(textFieldEditingDidBegin) forControlEvents:UIControlEventTouchUpInside];
    [_replyTextField setBorderWithWidth:1 color:[UIColor blackColor] radian:5.0];
    [self addSubview:_replyTextField];
}


- (void)setTopicInteractionFrame:(TopicInteractionFrame *)topicInteractionFrame {
    _topicInteractionFrame = topicInteractionFrame;
    _dianzan = topicInteractionFrame.topicInteractionDomain.dianzan;
    _replyPage = topicInteractionFrame.topicInteractionDomain.replyPage;
    _topicUUID = topicInteractionFrame.topicInteractionDomain.topicUUID;
    _topicType = topicInteractionFrame.topicInteractionDomain.topicType;
    
    /* 功能视图 */
    _funView.frame = _topicInteractionFrame.funViewF;
    
    /** 发帖时间 */
    
    if(_topicInteractionFrame.topicInteractionDomain.borwseType == Number_One) {
        NSDate * date = [KGDateUtil getDateByDateStr:_topicInteractionFrame.topicInteractionDomain.createTime format:dateFormatStr2];
        _dateLabel.text  = [KGNSStringUtil compareCurrentTime:date];
        _dateLabel.frame = _topicInteractionFrame.dateLabelF;
        
    } else if(_topicInteractionFrame.topicInteractionDomain.borwseType == Number_Two) {
        _browseCountLabel.text = [NSString stringWithFormat:@"浏览%ld次", (long)_dianzan.count];
        _browseCountImageView.frame = _topicInteractionFrame.browseCountImageViewF;
        _browseCountLabel.frame = _topicInteractionFrame.browseCountLabelF;
    }
    
    /** 点赞按钮 */
    if(_dianzan && !_dianzan.canDianzan) {
        _dianzanBtn.selected = YES;
    }
    _dianzanBtn.frame = _topicInteractionFrame.dianzanBtnF;
    
    /** 回复按钮 */
    _replyBtn.frame = _topicInteractionFrame.replyBtnF;
    
    /** 点赞列表视图 */
    _dianzanView.frame = _topicInteractionFrame.dianzanViewF;
    
    /** 点赞列表ICON */
    _dianzanIconImg.frame = _topicInteractionFrame.dianzanIconImgF;
    
    /** 点赞列表文本 */
    [self resetDZText];
    _dianzanLabel.frame = _topicInteractionFrame.dianzanLabelF;
    
    /** 回复列表视图 */
    [self addReplyData];
    _replyView.frame = _topicInteractionFrame.replyViewF;
    
    /** 回复输入框 */
    _replyTextField.frame = _topicInteractionFrame.replyTextFieldF;
    
}

//点赞列表文本
- (void)resetDZText {
    NSString * str = String_DefValue_Empty;
    if(_dianzan.count > Number_Five) {
        str = [NSString stringWithFormat:@"%@等%ld人觉得很赞", _dianzan.names, (long)(_dianzan.count-Number_Five)];
    } else {
        str = [NSString stringWithFormat:@"%@  %ld人觉得很赞", _dianzan.names, (long)_dianzan.count];
    }
    
    NSRange range = [str rangeOfString:_dianzan.names];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:str];
    [self.dianzanLabel setText:attString afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:KGColorFrom16(0xff4966) range:range];
        
        return mutableAttributedString;
    }];
}

//回复数据
- (void)addReplyData {
    
    if(_replyPage.data && [_replyPage.data count]>Number_Zero) {
        
        self.replyView.text = String_DefValue_Empty;
        
        NSMutableString  * replyStr = [[NSMutableString alloc] init];
        NSMutableArray   * attributedStrArray = [[NSMutableArray alloc] init];
        NSInteger count = Number_Zero;
        for(ReplyDomain * reply in _replyPage.data) {
            if(count < Number_Five) {
                [replyStr appendFormat:@"%@:%@\n", reply.create_user, reply.content ? reply.content : @""];
                
                NSRange  range = [replyStr rangeOfString:[NSString stringWithFormat:@"%@:", reply.create_user]];
                KGRange * tempRange = [KGRange new];
                tempRange.location = range.location;
                tempRange.length   = range.length;
                
                [attributedStrArray addObject:tempRange];
            }
            count++;
        }
        
        NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:replyStr];
        [self.replyView setText:attString afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            for(KGRange * tempRange in attributedStrArray) {
                [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:KGColorFrom16(0xff4966) range:NSMakeRange(tempRange.location, tempRange.length)];
            }
            
            return mutableAttributedString;
        }];
        
        _replyView.frame = _topicInteractionFrame.replyViewF;
        
        if(count > Number_Four) {
            /** 显示更多*/
            _moreBtn.hidden = NO;
            _moreBtn.frame = _topicInteractionFrame.moreBtnF;
        } else {
            _moreBtn.hidden = YES;
        }
    }
}


//点赞按钮点击
- (void)topicDZBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    NSDictionary *dic = @{Key_TopicInteractionDomain : _topicInteractionFrame.topicInteractionDomain,
                          Key_TopicFunRequestType : [NSNumber numberWithBool:sender.selected],
                          Key_TopicInteractionView : self};
    [[NSNotificationCenter defaultCenter] postNotificationName:Key_Notification_TopicDZ object:self userInfo:dic];
}

//回复按钮点击
//1. 输入框获得焦点。
//2.发送开始回复的通知 把当前数据传递出去  在回复键盘点击发送后 才知道是对哪条帖子进行回复
- (void)replyBtnClicked:(UIButton *)sender {
    [self textFieldEditingDidBegin];
}

//回复框开始编辑
- (void)textFieldEditingDidBegin {
    NSDictionary *dic = @{Key_TopicInteractionDomain : _topicInteractionFrame.topicInteractionDomain};
    [[NSNotificationCenter defaultCenter] postNotificationName:Key_Notification_BeginReplyTopic object:self userInfo:dic];
}

//加载更多按钮点击
- (void)moreBtnClicked:(UIButton *)sender {
    NSDictionary *dic = @{Key_TopicInteractionDomain : _topicInteractionFrame.topicInteractionDomain};
    [[NSNotificationCenter defaultCenter] postNotificationName:Key_Notification_TopicLoadMore object:self userInfo:dic];
}


//重置点赞列表
- (void)resetDZName:(BOOL)isAdd name:(NSString *)name {
    if(isAdd) {
        [self addDZ:name];
    } else {
        [self removeDZName:name];
    }
}

- (void)addDZ:(NSString *)name {
    NSArray * nameArray = [_dianzan.names componentsSeparatedByString:String_DefValue_SpliteStr];
    NSMutableString * tempNames = [[NSMutableString alloc] init];
    NSRange range = [_dianzan.names rangeOfString:name];//判断字符串是否包含
    
    if(range.location == NSNotFound) {
        //不包含
        [tempNames appendString:name];
        for(NSInteger i=Number_Zero; i<[nameArray count]; i++) {
            if(i >= Number_Four) {
                break;
            }
            
            if(![[nameArray objectAtIndex:i] isEqualToString:name] && ![[nameArray objectAtIndex:i] isEqualToString:String_DefValue_Empty]) {
                [tempNames appendFormat:@",%@", [nameArray objectAtIndex:i]];
            }
        }
        
        _dianzan.canDianzan = NO;
        _dianzan.count++;
        _dianzan.names = tempNames;
        
        [self resetDZText];
    }
}

- (void)removeDZName:(NSString *)name {
    NSRange range = [_dianzan.names rangeOfString:name];//判断字符串是否包含
    if (range.length > Number_Zero) {
        //包含
        [self reserDZListText:name];
    }
}

- (void)reserDZListText:(NSString *)name {
    NSArray * nameArray = [_dianzan.names componentsSeparatedByString:String_DefValue_SpliteStr];
    NSMutableString * tempNames = [[NSMutableString alloc] init];
    
    for(NSInteger i=Number_Zero; i<[nameArray count]; i++) {
        if(i > Number_Four) {
            break;
        }
        
        if(![[nameArray objectAtIndex:i] isEqualToString:name]) {
            [tempNames appendString:[nameArray objectAtIndex:i]];
        }
    }
    
    _dianzan.canDianzan = YES;
    _dianzan.count--;
    _dianzan.names = tempNames;
    
    [self resetDZText];
}



//重置回复
- (void)resetReplyList:(ReplyDomain *)replyDomain {
    if(!_replyPage.data) {
        _replyPage.data = [[NSMutableArray alloc] init];
    }
    [_replyPage.data insertObject:replyDomain atIndex:Number_Zero];
    [self addReplyData];
    
    self.replyTextField.y = CGRectGetMaxY(self.replyView.frame);
    
    //通知改变view高度
    [[NSNotificationCenter defaultCenter] postNotificationName:Key_Notification_TopicHeight object:self userInfo:nil];
}



@end

