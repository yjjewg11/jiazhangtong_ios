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

@interface TopicTableViewCell() <ShareBtnViewDelegate,TopicInteractionViewDelegate>

@end
@implementation TopicTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TOPICTABLECELL];
    if (!cell)
    {
        cell = [[TopicTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TOPICTABLECELL];
    }
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = KGColorFrom16(0xEBEBF2);
//        self.backgroundColor = [UIColor purpleColor];
        
        imagesMArray = [NSMutableArray new];
        //用户信息加载
        [self initUserView];
        
        //加载帖子内容
        [self initContentView];
        
        //加载帖子互动视图
        [self initTopicInteractionView];
        
        //分割线
        [self initLeve];
        
        self.shareview = [[[NSBundle mainBundle] loadNibNamed:@"ShareBtnView" owner:nil options:nil] firstObject];
    }
      return self;
}

//用户信息加载
-(void)initUserView{
    UIView * userview = [[UIView alloc] init];
    userview.backgroundColor = CLEARCOLOR;
//    userview.backgroundColor = [UIColor yellowColor];
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
    
    MLEmojiLabel  * topicTextView = [MLEmojiLabel new];
    topicTextView.numberOfLines = Number_Zero;
    topicTextView.font = [UIFont systemFontOfSize:APPUILABELFONTNO12];
    topicTextView.lineBreakMode = NSLineBreakByCharWrapping;
//    [topicTextView setBackgroundColor:[UIColor brownColor]];
    topicTextView.customEmojiRegex = String_DefValue_EmojiRegex;
    [self addSubview:topicTextView];
    
    _topicTextView = topicTextView;
    
    UIView  * topicImgsView = [[UIView alloc] init];
//    topicImgsView.backgroundColor = [UIColor greenColor];
    [self addSubview:topicImgsView];
    
    _topicImgsView = topicImgsView;
}


//加载帖子互动视图
- (void)initTopicInteractionView {
    if(_topicInteractionView) {
        [_topicInteractionView removeFromSuperview];
    }
    TopicInteractionView  * topicInteractionView = [[TopicInteractionView alloc] init];
    [self addSubview:topicInteractionView];
//    topicInteractionView.backgroundColor = [UIColor blueColor];
    _topicInteractionView = topicInteractionView;
}


//加载分割线
-(void)initLeve{
    UILabel * levelab = [[UILabel alloc] init];
    levelab.backgroundColor = KGColor(225, 225, 225, 1);
//    levelab.backgroundColor = [UIColor redColor];
    [self addSubview:levelab];
    
    _levelab = levelab;
}

-(void)setTopicFrame:(TopicFrame *)topicFrame{
    
    _topicFrame = topicFrame;
    
    TopicDomain * topic = self.topicFrame.topic;
    
    [imagesMArray removeAllObjects];
    /** 用户信息 */
    self.userView.frame = self.topicFrame.userViewF;
    //头部图片
    self.headImageView.frame = self.topicFrame.headImageViewF;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.topicFrame.topic.create_img] placeholderImage:[UIImage imageNamed:@"head_def"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.headImageView setBorderWithWidth:Number_Zero color:KGColorFrom16(0xE7E7EE) radian:self.headImageView.width / Number_Two];
    }];
    
    //名称
    self.nameLab.frame = self.topicFrame.nameLabF;
    self.nameLab.text = topic.create_user;
    
    //title
    if (topic.url == nil || [topic.url isEqualToString:@""])
    {
        self.titleLab.frame = self.topicFrame.titleLabF;
        self.titleLab.text = topic.title;
        
        //内容表情文本混合
        if(topic.content && [topic.content length]>Number_Zero) {
            self.topicTextView.frame = self.topicFrame.topicTextViewF;
            [self.topicTextView setText:topic.content];
        } else {
            [self.topicTextView setText:String_DefValue_Empty];
        }
        [self.shareview removeFromSuperview];
    }
    else
    {
        self.titleLab.text = @"";
        self.topicTextView.text = @"";
        self.shareview.delegate = self;
        self.shareview.frame = self.topicFrame.titleLabF;
        self.shareview.contentLbl.text = topic.content;
        self.shareview.url = topic.url;
        [self addSubview:self.shareview];
    }
    
    if(topic.imgs && topic.imgs.length > Number_Zero) {
        self.topicImgsView.hidden = NO;
        self.topicImgsView.frame = self.topicFrame.topicImgsViewF;
        [self loadTopicImgs];
    } else {
        self.topicImgsView.hidden = YES;
    }
    
    //帖子互动视图
    self.topicInteractionView.frame = self.topicFrame.topicInteractionViewF;
    self.topicInteractionView.delegate = self;
    self.topicInteractionView.url = topic.url;
    self.topicInteractionView.title = topic.content;
    self.topicInteractionView.topicInteractionFrame = self.topicFrame.topicInteractionFrame;
    //分割线
    self.levelab.frame = self.topicFrame.levelabF;
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
        if([imgArray count] > Number_Zero) {
            [self loadMoreTopicImgs:imgArray];
        }
//            else {
//            [self onlyOneTopicImg:[imgArray objectAtIndex:Number_Zero]];
//        }
    }
}

//多张帖子图片
- (void)loadMoreTopicImgs:(NSArray *)imgUrlArray {
    
    for(UIView * imgView in self.topicImgsView.subviews) {
        [imgView removeFromSuperview];
    }
    
    UIImageView * imageView = nil;
    CGFloat y = Number_Zero;
    CGFloat wh = (self.topicFrame.topicImgsViewF.size.width-Number_Ten) / Number_Three;
    CGFloat index = Number_Zero;
    NSInteger tag = Number_Zero;
    
    for(NSString * imgUrl in imgUrlArray) {
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(index * wh + index*Number_Five, y, wh, wh)];
        [self.topicImgsView addSubview:imageView];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
//        [self downloadBgImg:imgUrl];
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(index * wh, y, wh, wh)];
        btn.targetObj = imageView;
        btn.tag = tag;
        objc_setAssociatedObject(btn, "imgUrl", imgUrlArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [btn addTarget:self action:@selector(showTopicImgClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.topicImgsView addSubview:btn];
        
        if(index == Number_Two) {
            index = Number_Zero;
            y += wh + Number_Five;
        } else {
            index++;
        }
        
        tag++;
    }
}



//只有一张帖子图片
- (void)onlyOneTopicImg:(NSString *)imgUrl
{
    CGRect imgFrame = self.topicFrame.topicImgsViewF;
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.frame = (CGRect){Number_Zero, Number_Zero, imgFrame.size};
    imageView.contentMode = UIViewContentModeScaleToFill;
    [self.topicImgsView addSubview:imageView];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:imageView.frame];
    btn.targetObj = imageView;
    objc_setAssociatedObject(btn, "imgUrl", imgUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [btn addTarget:self action:@selector(showTopicImgClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.topicImgsView addSubview:btn];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        CGSize size = image.size;
        if(size.height < self.topicFrame.topicImgsViewF.size.height) {
            //图片小于显示区域的宽  按实际高度显示
            CGRect frame = self.topicFrame.topicImgsViewF;
            self.topicFrame.topicImgsViewF = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        }
    }];
}

- (void)showTopicImgClicked:(UIButton *)sender
{
//    UIImageView * imageView = (UIImageView *)sender.targetObj;
//    NSString * imgUrl = objc_getAssociatedObject(sender, "imgUrl");
//    [UUImageAvatarBrowser showImage:imageView url:imgUrl];
    NSArray * imgUrlArray = objc_getAssociatedObject(sender, "imgUrl");
    NSDictionary * dic = @{Key_ImagesArray : imgUrlArray, Key_Tag : [NSNumber numberWithInteger:sender.tag]};
    [[NSNotificationCenter defaultCenter] postNotificationName:Key_Notification_BrowseImages object:self userInfo:dic];
}

- (void)downloadBgImg:(NSString *)imgUrl
{
    NSArray * array = [imgUrl componentsSeparatedByString:@"@"];
    if(array && [array count]>Number_Zero) {
        [SDWebImageManager.sharedManager downloadImageWithURL:[array objectAtIndex:Number_Zero] options:SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if(image)
                [imagesMArray addObject:image];
        }];
    }
}

- (void)openWeb:(NSString *)url
{
    [self.delegate openWebWithUrl:url];
}

- (void)openShareWindow:(TopicInteractionView *)view
{
    [self.delegate openShareWindow:view.url title:view.title];
}
@end
