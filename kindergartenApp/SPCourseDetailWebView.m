//
//  SPCourseDetailWebView.m
//  kindergartenApp
//
//  Created by Mac on 15/11/20.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "SPCourseDetailWebView.h"

@interface SPCourseDetailWebView() <UIWebViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *sepViewNoOne;

@property (weak, nonatomic) IBOutlet UIView *courseDetailView;

@property (weak, nonatomic) IBOutlet UILabel *courseNameLbl;

@property (weak, nonatomic) IBOutlet UIView *starView;

@property (weak, nonatomic) IBOutlet UILabel *courseInfoLbl;

@property (weak, nonatomic) IBOutlet UILabel *courseLocationLbl;

@property (weak, nonatomic) IBOutlet UILabel *courseTimeLbl;

@property (weak, nonatomic) IBOutlet UILabel *feesLbl;
@property (weak, nonatomic) IBOutlet UILabel *feesText;

@property (weak, nonatomic) IBOutlet UILabel *discountFeesLbl;
@property (weak, nonatomic) IBOutlet UILabel *discountFeesText;

@property (weak, nonatomic) IBOutlet UILabel *suitAgeLbl;

@property (weak, nonatomic) IBOutlet UILabel *numberOfStudyLbl;

@property (weak, nonatomic) IBOutlet UIView *clearView;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *courseDetailViewHeightConstraint;

@property (assign, nonatomic) CGFloat yPoint;


@property (assign, nonatomic) CGFloat courseDetailOriY;
@property (assign, nonatomic) CGFloat webViewOriHeight;
@property (assign, nonatomic) CGFloat webViewOriY;

@end

@implementation SPCourseDetailWebView

#pragma mark - 设置数据
- (void)setData:(SPCourseDetailVO *)vo
{
    SPCourseDetailDomain * domain = [SPCourseDetailDomain objectWithKeyValues:vo.data];
    
    self.courseNameLbl.text = domain.title;
    
    self.courseLocationLbl.text = domain.address;
    
    self.courseTimeLbl.text = domain.schedule;
    
    self.suitAgeLbl.text = vo.age_min_max;
    
    self.numberOfStudyLbl.text = [NSString stringWithFormat:@"%ld",(long)domain.ct_study_students];
    
    if (domain.fees == 0)
    {
        [self.feesLbl setHidden:YES];
        [self.feesText setHidden:YES];
        [self.discountFeesLbl setHidden:YES];
        [self.discountFeesText setHidden:YES];
        
        self.courseDetailViewHeightConstraint.constant -= 25;
    }
    else
    {
        self.feesLbl.text = [NSString stringWithFormat:@"%.2f",domain.fees];
    }
    
    if (domain.discountfees == 0)
    {
        [self.discountFeesLbl setHidden:YES];
        [self.discountFeesText setHidden:YES];
        
        self.courseDetailViewHeightConstraint.constant -= 10;
    }
    else
    {
        self.discountFeesLbl.text = [NSString stringWithFormat:@"%.2f",domain.discountfees];
    }
    
    NSInteger intCount = (NSInteger)(domain.ct_stars / 10);
    
    NSInteger halfCount = domain.ct_stars - intCount * 10;
    
    [self setUpStarts:intCount halfCount:halfCount];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:vo.obj_url]]];
    
    self.webView.scrollView.showsHorizontalScrollIndicator = YES;
    self.webView.scrollView.showsVerticalScrollIndicator = YES;
    
}

- (void)awakeFromNib
{
    self.webView.delegate = self;
    
    self.webView.scrollView.scrollEnabled = NO;
    
    self.webView.scrollView.delegate = self;
    
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [self addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    
    [self addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    
    [self addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    
    [self addGestureRecognizer:recognizer];

}

#pragma mark - 手势触发方法
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown)
    {
    }
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp)
    {
        if (self.yPoint > CGRectGetMaxY(self.courseDetailView.frame))
        {
            self.clearView.hidden = YES;
            self.sepViewNoOne.hidden = YES;

            
            self.courseDetailOriY = self.courseDetailView.frame.origin.y;
            self.webViewOriHeight = self.webView.frame.size.height;
            self.webViewOriY = self.webView.frame.origin.y;
            
            [UIView animateWithDuration:0.7 animations:^
            {
                self.courseDetailView.alpha = 0;
                [self.courseDetailView setOrigin:CGPointMake(0, -self.courseDetailView.frame.size.height)];
                [self.webView setFrame:CGRectMake(0, 0, APPWINDOWWIDTH, APPWINDOWHEIGHT-(64+40+10+40))];
            }];
            
            self.webView.scrollView.scrollEnabled = YES;
        }
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft)
    {
//        NSLog(@"swipe left");
    }

    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight)
    {
//        NSLog(@"swipe right");
    }
}

- (void)setUpStarts:(NSInteger)intCount halfCount:(NSInteger)halfCount
{
    for (NSInteger i = 0; i < 5; i++)
    {
        for (UIButton * btn in self.starView.subviews)
        {
            if (btn.tag == i)
            {
                if (btn.tag < intCount)
                {
                    [btn setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
                }
                if (btn.tag == intCount)
                {
                    if (halfCount >= 5)
                    {
                        [btn setImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
                    }
                    else if(halfCount > 0 && halfCount <5)
                    {
                        [btn setImage:[UIImage imageNamed:@"banekexing"] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [btn setImage:[UIImage imageNamed:@"xing1"] forState:UIControlStateNormal];
                    }
                }
                if (btn.tag > intCount)
                {
                    [btn setImage:[UIImage imageNamed:@"xing1"] forState:UIControlStateNormal];
                }
            }
        }
    }
}

#pragma mark - scroll view代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //当currentOffset与maximumOffset的值相等时，说明scrollview已经滑到底部了。也可以根据这两个值的差来让他做点其他的什么事情
    if(scrollView.contentOffset.y <= -80)
    {
        self.clearView.hidden = NO;
        self.sepViewNoOne.hidden = NO;

        [UIView animateWithDuration:0.5 animations:^
        {
            self.courseDetailView.alpha = 1;
            [self.courseDetailView setOrigin:CGPointMake(0, self.courseDetailOriY)];
            [self.webView setFrame:CGRectMake(0, self.webViewOriY, APPWINDOWWIDTH, self.webViewOriHeight)];
        }];
        self.webView.scrollView.scrollEnabled = NO;
    }
}

#pragma mark - 获取触摸点
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSSet * allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch * touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    
    int y = point.y;
    
    self.yPoint = y;
}


@end
