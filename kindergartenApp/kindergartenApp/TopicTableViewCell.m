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
#import "UIImageView+WebCache.h"
#import "UUImageAvatarBrowser.h"
#import "UIButton+Extension.h"
#import <objc/runtime.h>

#define TOPICTABLECELL @"topicTableCell"

@interface TopicTableViewCell() 

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
        
        //加载帖子互动视图
//        [self initTopicInteractionView];
        
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
    namelab.font = TopicCellNameFont;
    namelab.textColor = [UIColor blackColor];
    [userview addSubview:namelab];
    
    _nameLab = namelab;
    
    UILabel  * titlelab = [[UILabel alloc] init];
    titlelab.backgroundColor = CLEARCOLOR;
    titlelab.font = TopicCellNameFont;
//    titlelab.numberOfLines = 0;
    [userview addSubview:titlelab];
    _titleLab = titlelab;
    
}


//加载帖子内容
- (void)initContentView {
    UIView * topicContentView = [[UIView alloc] init];
    topicContentView.backgroundColor = [UIColor clearColor];
    [self addSubview:topicContentView];
    
    _topicContentView = topicContentView;
    
    TQRichTextView  * topicTextView = [[TQRichTextView alloc] init];
    topicTextView.lineSpace = 1.0f;
    topicTextView.font = [UIFont systemFontOfSize:12.0f];
    topicTextView.backgroundColor = [UIColor clearColor];
    [topicContentView addSubview:topicTextView];
    
    _topicTextView = topicTextView;
    
    UIView  * topicImgsView = [[UIView alloc] init];
    topicImgsView.backgroundColor = [UIColor greenColor];
    [topicContentView addSubview:topicImgsView];
    
    _topicImgsView = topicImgsView;
}


//加载帖子互动视图
- (void)initTopicInteractionView {
    if(_topicInteractionView) {
        [_topicInteractionView removeFromSuperview];
    }
    TopicInteractionView  * topicInteractionView = [[TopicInteractionView alloc] init];
    [self addSubview:topicInteractionView];
//    topicInteractionView.backgroundColor = [UIColor brownColor];
    _topicInteractionView = topicInteractionView;
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
    self.headImageView.image = [UIImage imageNamed:@"head_def"];
    
//    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.topicFrame.topic.imgs] placeholderImage:[UIImage imageNamed:@"head_def"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        [self.headImageView setBorderWithWidth:Number_Zero color:KGColorFrom16(0xE7E7EE) radian:self.headImageView.width / Number_Two];
//    }];
    
    //名称
    self.nameLab.frame = self.topicFrame.nameLabF;
    self.nameLab.text = topic.create_user;
   
    //title
    self.titleLab.frame = self.topicFrame.titleLabF;
    self.titleLab.text =  topic.title;
    
    //内容
    self.topicContentView.frame = self.topicFrame.topicContentViewF;
    
    self.topicTextView.frame = self.topicFrame.topicTextViewF;
    self.topicTextView.text = topic.content;
    
    self.topicImgsView.frame = self.topicFrame.topicImgsViewF;
    [self loadTopicImgs];
    
    //帖子互动视图
    [self initTopicInteractionView];
    [self.topicInteractionView loadFunView:self.topicFrame.topic.dianzan reply:self.topicFrame.topic.replyPage];
    self.topicInteractionView.topicUUID = self.topicFrame.topic.uuid;
    self.topicInteractionView.topicType = Topic_Interact;
    self.topicInteractionView.frame = self.topicFrame.topicInteractionViewF;
    
    //分割线
    CGRect levelabFrame = self.topicFrame.levelabF;
    self.topicFrame.levelabF = CGRectMake(levelabFrame.origin.x, CGRectGetMaxY(self.topicInteractionView.frame), levelabFrame.size.width, 0.5);
    self.levelab.frame = self.topicFrame.levelabF;
//    self.levelab.backgroundColor = [UIColor blackColor];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


//加载帖子图片
- (void)loadTopicImgs {
    TopicDomain * topic = self.topicFrame.topic;
    if(topic.imgs && ![topic.imgs isEqualToString:String_DefValue_Empty]) {
        NSArray * imgArray = topic.imgsList;
        
//        if([imgArray count] > Number_One) {
            [self loadMoreTopicImgs:imgArray];
//        } else {
//            [self onlyOneTopicImg:[imgArray objectAtIndex:Number_Zero]];
//        }
    }
}

//多张帖子图片
- (void)loadMoreTopicImgs:(NSArray *)imgUrlArray {
    UIImageView * imageView = nil;
    CGFloat y = Number_Zero;
    CGFloat wh = self.topicFrame.topicImgsViewF.size.width / Number_Three;
    CGFloat index = Number_Zero;
    
    UIButton * btn = nil;
    for(NSString * imgUrl in imgUrlArray) {
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(index * wh, y, wh, wh)];
        [self.topicImgsView addSubview:imageView];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        btn = [[UIButton alloc] initWithFrame:CGRectMake(index * wh, y, wh, wh)];
        btn.targetObj = imageView;
        objc_setAssociatedObject(btn, "imgUrl", imgUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [btn addTarget:self action:@selector(showImgClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.topicImgsView addSubview:btn];
        
        if(index == Number_Two) {
            index = Number_Zero;
            y += wh;
        }
        
        index++;
    }
}



//只有一张帖子图片
- (void)onlyOneTopicImg:(NSString *)imgUrl {
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleToFill;
    [self.topicImgsView addSubview:imageView];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        CGSize size = image.size;
        if(size.height < self.topicFrame.topicImgsViewF.size.height) {
            //图片小于显示区域的宽  按实际高度显示
            CGRect frame = self.topicFrame.topicImgsViewF;
            self.topicFrame.topicImgsViewF = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        }
        
    }];
}

- (void)showImgClicked:(UIButton *)sender{
    UIImageView * imageView = (UIImageView *)sender.targetObj;
    NSString * imgUrl = objc_getAssociatedObject(sender, "imgUrl");
    [UUImageAvatarBrowser showImage:imageView url:imgUrl];
}


@end
