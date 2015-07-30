//
//  TopicTableViewCell.m
//  MYAPP
//
//  Created by Moyun on 15/7/1.
//  Copyright (c) 2015年 Moyun. All rights reserved.
//

#import "TopicTableViewCell.h"
#import "UIColor+Extension.h"
#import "TopicFrame.h"
#import "UIButton+Extension.h"
#import "UIView+Extension.h"
#import "TopicDomain.h"
#import "KGHttpService.h"
#import "PageInfoDomain.h"
#import "KGDateUtil.h"
#import "KGNSStringUtil.h"

#define TOPICTABLECELL @"topicTableCell"

@interface TopicTableViewCell() <UIWebViewDelegate>

@end
@implementation TopicTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TOPICTABLECELL];
    if (!cell) {
        cell = [[TopicTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TOPICTABLECELL];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = KGColorFrom16(0xEBEBF2);
        //用户信息加载
        [self initUserView];
        
        //加载帖子内容
        [self initContentView];
        
        //加载功能按钮 (点赞、回复)
        [self initFunView];
        
        //加载点赞列表
        [self initDZLabel];
        
        //加载回复列表
        [self initReplyView];
        
        //加载回复输入框
        [self initReplyTextField];
        
        //分割线
        [self initLeve];
        
    }
    
      return self;
}

//用户信息加载
-(void)initUserView{
    UIView * userview = [[UIView alloc] init];
    userview.backgroundColor = CLEARCOLOR;
//    userview.backgroundColor = [UIColor brownColor];
    [self addSubview:userview];
    _userView = userview;
    
    UIImageView * headImage = [[UIImageView alloc] init];
    [userview addSubview:headImage];
    _headImageView = headImage;
    
    UILabel * namelab = [[UILabel alloc] init];
    namelab.backgroundColor = CLEARCOLOR;
    namelab.font = MYTopicCellNameFont;
    namelab.textColor = [UIColor blackColor];
    [userview addSubview:namelab];
    
    _nameLab = namelab;
    
    UILabel  * titlelab = [[UILabel alloc] init];
    titlelab.backgroundColor = CLEARCOLOR;
    titlelab.font = MYTopicCellNameFont;
//    titlelab.numberOfLines = 0;
    [userview addSubview:titlelab];
    _titleLab = titlelab;
    
}


//加载帖子内容
- (void)initContentView {
    UIWebView * contentWebView = [[UIWebView alloc] init];
//    contentWebView.backgroundColor = KGColorFrom16(0xEBEBF2);
    [contentWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#EBEBF2'"];
    contentWebView.delegate = self;
    [self addSubview:contentWebView];
    
    [contentWebView.layer setCornerRadius:10.0];
    [contentWebView.layer setMasksToBounds:YES];
    
    _contentWebView = contentWebView;
}


//加载功能按钮 (点赞、回复)
- (void)initFunView {
    UIView * funView = [[UIView alloc] init];
    funView.backgroundColor = CLEARCOLOR;
//    funView.backgroundColor = [UIColor grayColor];
    [self addSubview:funView];
    
    _funView = funView;
    
    UILabel * datelab = [[UILabel alloc] init];
    datelab.backgroundColor = CLEARCOLOR;
    datelab.font = MYTopicCellDateFont;
    datelab.textColor = KGColorFrom16(0x666666);
    [funView addSubview:datelab];
    _dateLabel = datelab;
    
    UIButton * dzBtn = [[UIButton alloc] init];
    [dzBtn setBackgroundImage:@"anzan" selImg:@"hongzan"];
    dzBtn.tag = Number_Ten;
    [dzBtn addTarget:self action:@selector(funBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [funView addSubview:dzBtn];
    _dianzanBtn = dzBtn;
    
    UIButton * replyBtn = [[UIButton alloc] init];
    [replyBtn setBackgroundImage:@"pinglun" selImg:@"pinglun"];
    replyBtn.tag = Number_Eleven;
    [replyBtn addTarget:self action:@selector(funBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [funView addSubview:replyBtn];
    _replyBtn = replyBtn;
}

//加载点赞列表
- (void)initDZLabel {
    UIView * dzView = [[UIView alloc] init];
    dzView.backgroundColor = CLEARCOLOR;
//    dzView.backgroundColor = [UIColor brownColor];
    
    [self addSubview:dzView];
    
    _dianzanView = dzView;
    
    UIImageView * dzImage = [[UIImageView alloc] init];
    dzImage.image = [UIImage imageNamed:@"wodehuizan"];
//    dzImage.backgroundColor = [UIColor redColor];
    [dzView addSubview:dzImage];
    
    _dianzanIconImg = dzImage;
    
    UILabel * dzlabel = [[UILabel alloc] init];
    dzlabel.backgroundColor = CLEARCOLOR;
    dzlabel.font = MYTopicCellDateFont;
    [dzView addSubview:dzlabel];
    _dianzanLabel = dzlabel;
}

//加载回复
- (void)initReplyView {
    HBVLinkedTextView * replyLabel = [[HBVLinkedTextView alloc] init];
    replyLabel.backgroundColor = CLEARCOLOR;
//    replyLabel.backgroundColor = [UIColor greenColor];
    replyLabel.font = MYTopicCellDateFont;
    [self addSubview:replyLabel];
    
    _replyView = replyLabel;
}


//加载回复输入框
- (void)initReplyTextField {
    UITextField * replyTextField = [[UITextField alloc] init];
    replyTextField.placeholder = @"我来说一句...";
    [self addSubview:replyTextField];
    
    [replyTextField setBorderWithWidth:1 color:[UIColor blackColor] radian:10.0];
    
    _replyTextField = replyTextField;
}


//加载分割线
-(void)initLeve{
    UILabel * levelab = [[UILabel alloc] init];
    levelab.backgroundColor = KGColor(225, 225, 225, 1);
    [self addSubview:levelab];
    
    _levelab = levelab;
}

-(void)setTopicFrame:(TopicFrame *)topicFrame{
    _topicFrame = topicFrame;
    TopicDomain * topic = self.topicFrame.topic;
    
    /** 用户信息 */
    self.userView.frame =self.topicFrame.userViewF;
    //头部图片
    self.headImageView.frame = self.topicFrame.headImageViewF;
    self.headImageView.image = [UIImage imageNamed:@"youxiang1"];
    
    //名称
    self.nameLab.frame = self.topicFrame.nameLabF;
    self.nameLab.text = topic.create_user;
   
    //title
    self.titleLab.frame = self.topicFrame.titleLabF;
    self.titleLab.text =  topic.title;
    
    //内容
    self.contentWebView.frame = self.topicFrame.contentWebViewF;
    [self.contentWebView loadHTMLString:topic.content baseURL:nil];
    
    //功能按钮
    self.funView.frame = self.topicFrame.funViewF;
    self.dateLabel.frame = self.topicFrame.dateLabelF;
    self.dianzanBtn.frame = self.topicFrame.dianzanBtnF;
    self.replyBtn.frame   = self.topicFrame.replyBtnF;
    
    //时间
    if(topic.create_time) {
        NSDate * date = [KGDateUtil getDateByDateStr:topic.create_time format:dateFormatStr2];
        self.dateLabel.text = [KGNSStringUtil compareCurrentTime:date];
    }
    
    //点赞
    [self getDZInfo];
    
    //回复
//    self.replyView.frame = self.topicFrame.replyViewF;
    
    //回复输入框
    self.replyTextField.frame = self.topicFrame.replyTextFieldF;
    
    //分割线
    self.levelab.frame = self.topicFrame.levelabF;

    [self getDZInfo];
    [self getReplyList];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)funBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
                     
    NSDictionary *dic = @{Key_TopicCellFunType : [NSNumber numberWithInteger:sender.tag],
                          Key_TopicUUID : _topicFrame.topic.uuid,
                          Key_TopicFunRequestType : [NSNumber numberWithBool:sender.selected]};
    [[NSNotificationCenter defaultCenter] postNotificationName:Key_Notification_TopicFunClicked object:self userInfo:dic];
}


- (void)getDZInfo {
    
//    if(!_topicFrame.topic.dianZanDomain || !_topicFrame.topic.isReqDianZan) {
        [[KGHttpService sharedService] getDZList:_topicFrame.topic.uuid success:^(DianZanDomain *dzDomain) {
            _topicFrame.topic.dianZanDomain = dzDomain;
            
            if(dzDomain) {
                //点赞
                self.dianzanView.frame = self.topicFrame.dianzanViewF;
                self.dianzanIconImg.frame = self.topicFrame.dianzanIconImgF;
                
                //点赞文本
                self.dianzanLabel.frame = self.topicFrame.dianzanLabelF;
                
                NSArray * nameArray = [dzDomain.names componentsSeparatedByString:@","];
                
                if([nameArray count] >= Number_Five) {
                    self.dianzanLabel.text = [NSString stringWithFormat:@"%@等%ld人觉得很赞", dzDomain.names, (long)dzDomain.count];
                } else {
                    self.dianzanLabel.text = [NSString stringWithFormat:@"%@ %ld人觉得很赞", dzDomain.names, (long)dzDomain.count];
                }
                
                self.dianzanBtn.selected = dzDomain.canDianzan;
                
                CGFloat h = CGRectGetHeight(self.topicFrame.dianzanViewF);
                
                /* cell的高度 */
                self.topicFrame.cellHeight += h;
                
                [self resetFrame:[[NSArray alloc] initWithObjects:self.replyView, self.replyTextField, self.levelab, nil] h:CGRectGetMaxY(self.topicFrame.dianzanViewF)];
            }
            
            _topicFrame.topic.isReqDianZan = YES;
            
        } faild:^(NSString *errorMsg) {
            _topicFrame.topic.isReqDianZan = YES;
        }];
        
//    }
}


- (void)getReplyList {
//    if(!_topicFrame.topic.replyMArray || !_topicFrame.topic.isReqReplyMArray) {
    
        PageInfoDomain * pageInfo = [[PageInfoDomain alloc] initPageInfo:Number_One size:Number_Ten];
        
        [[KGHttpService sharedService] getReplyList:pageInfo topicUUID:_topicFrame.topic.uuid success:^(PageInfoDomain *pageInfo) {
            _topicFrame.topic.replyMArray = (NSMutableArray *)pageInfo.data;
            
            if([pageInfo.data count] > Number_Zero) {
                
                CGFloat h = CGRectGetMaxY(self.topicFrame.funViewF);
                
                if(_topicFrame.topic.isReqDianZan) {
                    h = CGRectGetMaxY(self.topicFrame.dianzanViewF);
                }
                
                CGFloat tempY = h;
                
                NSMutableArray * arrayOfStrings = [[NSMutableArray alloc] initWithCapacity:[pageInfo.data count]];
                NSMutableString * replyStr = [[NSMutableString alloc] init];
                
                for(ReplyDomain * reply in pageInfo.data) {
                    [replyStr appendFormat:@"%@:%@ \n", reply.create_user, reply.title ? reply.title : @""];
                    [arrayOfStrings addObject:[NSString stringWithFormat:@"%@:", reply.create_user]];
                }
                
                CGSize size = [replyStr sizeWithFont:[UIFont systemFontOfSize:APPUILABELFONTNO12]
                                   constrainedToSize:CGSizeMake(CELLCONTENTWIDTH, 2000)
                                       lineBreakMode:NSLineBreakByWordWrapping];
                
                tempY += Number_Five;
                _topicFrame.replyViewF = CGRectMake(CELLPADDING, tempY, CELLCONTENTWIDTH, size.height);
                _replyView.frame = _topicFrame.replyViewF;
                
                self.replyView.text = replyStr;
                [self.replyView linkStrings:arrayOfStrings
                          defaultAttributes:[self exampleAttributes]
                      highlightedAttributes:[self exampleAttributes]
                                 tapHandler:nil];
                
                CGFloat addH = tempY - h;
                
                /* cell的高度 */
                self.topicFrame.cellHeight += addH;
                
                [self resetFrame:[[NSArray alloc] initWithObjects:self.replyTextField, self.levelab, nil] h:CGRectGetMaxY(_topicFrame.replyViewF)];
            }
            
        } faild:^(NSString *errorMsg) {
            
        }];
        _topicFrame.topic.isReqReplyMArray = YES;
//    }
}

- (void)resetFrame:(NSArray *)views h:(CGFloat)h {
    CGFloat y = h;
    for(UIView * view in views){
        if(view) {
            view.y = y;
            y = CGRectGetMaxY(view.frame);
        }
    }
}


- (NSMutableDictionary *)exampleAttributes
{
    return [@{NSFontAttributeName:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]],
              NSForegroundColorAttributeName:[UIColor redColor]}mutableCopy];
}


#pragma UIWebView delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    float height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    NSLog(@"size:%.f", height);
//    CGFloat tempH = self.contentWebView.height;
//    
//    if(tempH != height) {
//        CGFloat h = tempH - height;
//        if(h < 0) {
//            h = height - tempH;
//        }
//        self.contentWebView.height = height;
//        
//    }
}


@end
