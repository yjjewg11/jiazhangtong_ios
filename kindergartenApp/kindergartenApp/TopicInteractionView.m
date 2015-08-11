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

@implementation TopicInteractionView 

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
    }
    
    return self;
}

- (void)loadFunView:(DianZanDomain *)dzDomain reply:(ReplyPageDomain *)replyPageDomain {
    
    _dianzan = dzDomain;
    _replyPage = replyPageDomain;
    
    //加载功能按钮 (点赞、回复)
    [self initFunView];
    
    //加载点赞列表
    [self initDZLabel];
    
    //加载回复
    [self initReplyView];
    
    //加载回复输入框
    [self initReplyTextField];
}


//加载功能按钮 (点赞、回复)
- (void)initFunView {
    // cell的宽度
    CGFloat cellW = KGSCREEN.size.width;
    
    _funView = [[UIView alloc] initWithFrame:CGRectMake(CELLPADDING, Number_Zero, CELLCONTENTWIDTH, CELLPADDING)];
    _funView.backgroundColor = CLEARCOLOR;
//    funView.backgroundColor = [UIColor redColor];
    [self addSubview:_funView];
    
    /* cell的高度 */
    self.topicInteractHeight = CGRectGetMaxY(_funView.frame);
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(Number_Zero, Number_Three, 100, 10)];
    _dateLabel.backgroundColor = CLEARCOLOR;
    _dateLabel.font = TopicCellDateFont;
    _dateLabel.textColor = KGColorFrom16(0x666666);
    [_funView addSubview:_dateLabel];
    
    //回复按钮
    CGSize funBtnSize = CGSizeMake(31, 16);
    CGFloat replyBtnX = cellW - funBtnSize.width - CELLPADDING - CELLPADDING;
    CGFloat replyBtnY = 0;
    
    //点赞按钮
    CGFloat dzBtnX = replyBtnX - 15 - funBtnSize.width;
    
    _dianzanBtn = [[UIButton alloc] initWithFrame:CGRectMake(replyBtnX, replyBtnY, funBtnSize.width, funBtnSize.height)];
    [_dianzanBtn setBackgroundImage:@"anzan" selImg:@"hongzan"];
    _dianzanBtn.selected = !_dianzan.canDianzan;
    _dianzanBtn.tag = Number_Ten;
    [_dianzanBtn addTarget:self action:@selector(topicFunBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_funView addSubview:_dianzanBtn];
    
    _replyBtn = [[UIButton alloc] initWithFrame:CGRectMake(dzBtnX, replyBtnY, funBtnSize.width, funBtnSize.height)];
    [_replyBtn setBackgroundImage:@"pinglun" selImg:@"pinglun"];
    _replyBtn.tag = Number_Eleven;
    [_replyBtn addTarget:self action:@selector(replyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_funView addSubview:_replyBtn];
}

//加载点赞列表
- (void)initDZLabel {
    
    _dianzanView = [[UIView alloc] initWithFrame:CGRectMake(Number_Zero, self.topicInteractHeight + TopicCellBorderW, CELLCONTENTWIDTH, TopicCellBorderW)];
    _dianzanView.backgroundColor = CLEARCOLOR;
//    dzView.backgroundColor = [UIColor brownColor];
    [self addSubview:_dianzanView];
    
    _dianzanIconImg = [[UIImageView alloc] initWithFrame:CGRectMake(CELLPADDING, Number_Zero, Number_Ten, Number_Ten)];
    _dianzanIconImg.image = [UIImage imageNamed:@"wodehuizan"];
//    dzImage.backgroundColor = [UIColor redColor];
    [_dianzanView addSubview:_dianzanIconImg];
    
    //点赞列表
    // cell的宽度
    CGFloat cellW = KGSCREEN.size.width;
    CGFloat dzLabelX = CGRectGetMaxX(_dianzanIconImg.frame) + Number_Ten;
    CGFloat dzLabelW = cellW - dzLabelX - CELLPADDING;
    
    _dianzanLabel = [[UILabel alloc] initWithFrame:CGRectMake(dzLabelX, Number_Zero, dzLabelW, Number_Ten)];
    _dianzanLabel.backgroundColor = CLEARCOLOR;
    _dianzanLabel.font = TopicCellDateFont;
    [_dianzanView addSubview:_dianzanLabel];
    
    [self resetDZText];
    
    /* cell的高度 */
    self.topicInteractHeight = CGRectGetMaxY(_dianzanView.frame);
    
}

//加载回复
- (void)initReplyView {
    
    _replyView = [[HBVLinkedTextView alloc] init];
    _replyView.backgroundColor = CLEARCOLOR;
//    replyLabel.backgroundColor = [UIColor greenColor];
    _replyView.font = TopicCellDateFont;
    [self addSubview:_replyView];
    
    [self addReplyData];
}

- (void)addReplyData {
    self.replyView.text = String_DefValue_Empty;
    
    if(_replyPage.data && [_replyPage.data count]>Number_Zero) {
        NSMutableArray  * arrayOfStrings = [[NSMutableArray alloc] initWithCapacity:[_replyPage.data count]];
        NSMutableString * replyStr       = [[NSMutableString alloc] init];
        
        for(ReplyDomain * reply in _replyPage.data) {
            [replyStr appendFormat:@"%@:%@ \n", reply.create_user, reply.content ? reply.title : @""];
            [arrayOfStrings addObject:[NSString stringWithFormat:@"%@:", reply.create_user]];
        }
        
        CGSize size = [replyStr sizeWithFont:[UIFont systemFontOfSize:APPUILABELFONTNO12]
                           constrainedToSize:CGSizeMake(CELLCONTENTWIDTH, 2000)
                               lineBreakMode:NSLineBreakByWordWrapping];
        
        _replyView.frame = CGRectMake(CELLPADDING, self.topicInteractHeight + Number_Five, CELLCONTENTWIDTH, size.height);
        
        self.replyView.text = replyStr;
        [self.replyView linkStrings:arrayOfStrings
                  defaultAttributes:[self exampleAttributes]
              highlightedAttributes:[self exampleAttributes]
                         tapHandler:nil];
        /* cell的高度 */
        self.topicInteractHeight = CGRectGetMaxY(_replyView.frame);
    }
}


//加载回复输入框
- (void)initReplyTextField {
    _replyTextField = [[KGTextField alloc] initWithFrame:CGRectMake(CELLPADDING, self.topicInteractHeight + TopicCellBorderW, CELLCONTENTWIDTH, 30)];
    _replyTextField.placeholder = @"我来说一句...";
    _replyTextField.returnKeyType = UIReturnKeySend;
    _replyTextField.delegate = self;
    [self addSubview:_replyTextField];
    [_replyTextField setBorderWithWidth:1 color:[UIColor blackColor] radian:5.0];
    
    self.topicInteractHeight = CGRectGetMaxY(_replyTextField.frame) + Number_Ten;
    self.height = self.topicInteractHeight;
}


//键盘回车
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString * replyText = [KGNSStringUtil trimString:textField.text];
    if(replyText && ![replyText isEqualToString:String_DefValue_Empty]) {
        NSDictionary *dic = @{Key_TopicTypeReplyText : [KGNSStringUtil trimString:textField.text],
                              Key_TopicUUID : _topicUUID,
                              Key_TopicType : [NSNumber numberWithInteger:_topicType]};
        [[NSNotificationCenter defaultCenter] postNotificationName:Key_Notification_TopicFunClicked object:self userInfo:dic];
        
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)replyBtnClicked:(UIButton *)sender {
    [_replyTextField becomeFirstResponder];
}


- (void)topicFunBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    NSDictionary *dic = @{Key_TopicCellFunType : [NSNumber numberWithInteger:sender.tag],
                          Key_TopicUUID : _topicUUID,
                          Key_TopicFunRequestType : [NSNumber numberWithBool:sender.selected],
                          Key_TopicType : [NSNumber numberWithInteger:_topicType],
                          Key_TopicInteractionView : self};
    [[NSNotificationCenter defaultCenter] postNotificationName:Key_Notification_TopicFunClicked object:self userInfo:dic];
}

- (NSMutableDictionary *)exampleAttributes
{
    return [@{NSFontAttributeName:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]],
              NSForegroundColorAttributeName:[UIColor redColor]}mutableCopy];
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
            if(i > Number_Four) {
                break;
            }
            
            if(![[nameArray objectAtIndex:i] isEqualToString:name]) {
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

- (void)resetDZText {
    if(_dianzan.count > Number_Five) {
        _dianzanLabel.text = [NSString stringWithFormat:@"%@等%ld人觉得很赞", _dianzan.names, (long)(_dianzan.count-Number_Five)];
    } else {
        _dianzanLabel.text = [NSString stringWithFormat:@"%@  %ld人觉得很赞", _dianzan.names, (long)_dianzan.count];
    }
}

//重置回复
- (void)resetReplyList:(ReplyDomain *)replyDomain {
    if(!_replyPage.data) {
        _replyPage.data = [[NSMutableArray alloc] init];
    }
    [_replyPage.data addObject:replyDomain];
//    [self addReplyData];
    
    //通知改变view高度
//    [[NSNotificationCenter defaultCenter] postNotificationName:Key_Notification_TopicHeight object:self userInfo:nil];
}

@end










