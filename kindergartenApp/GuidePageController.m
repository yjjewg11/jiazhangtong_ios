//
//  ViewController.m
//  ScrollViewTest
//
//  Created by silentcloud on 11/2/13.//  Copyright (c) 2013 qiang.mou. All rights reserved.
//
#import "GuidePageController.h"

@implementation GuidePageController

#define SCREEN_WIDTH self.view.bounds.size.width
#define SCREEN_HEIGHT self.view.bounds.size.height
#define GuidPageCount 3

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * GuidPageCount, SCREEN_HEIGHT);
    [self.view addSubview:_scrollView];

    int _x = 0;
    for (int index = 0; index < GuidPageCount; index++) {
        UIImageView *imgScrollView = [[UIImageView alloc] initWithFrame:CGRectMake(0+_x, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        imgScrollView.tag = index;
        
        
        NSString *imgName = [NSString stringWithFormat:@"ios_yindaoye%d", index + 1];
        imgScrollView.image = [UIImage imageNamed:imgName];
        [_scrollView addSubview:imgScrollView];
        
       
        
        _x += SCREEN_WIDTH;
    }
    
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    _pageControl.numberOfPages = GuidPageCount;
    [self.view addSubview:_pageControl];
    
    UIButton *skipBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 40, 40, 20)];
    [skipBtn setBackgroundImage:[UIImage imageNamed:@"tiaoguo"] forState:UIControlStateNormal];
//    [skipBtn setTitle:@"Skip" forState:UIControlStateNormal];
    [skipBtn addTarget:self action:@selector(goMainView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:skipBtn];
    
    
    UIButton *lijitiyan = [[UIButton alloc] initWithFrame:CGRectMake(_x-SCREEN_WIDTH/2-115/2, SCREEN_HEIGHT-50-37-20, 115, 37)];
    [lijitiyan setBackgroundImage:[UIImage imageNamed:@"lijitiyan"] forState:UIControlStateNormal];
    
    [lijitiyan addTarget:self action:@selector(lijitiyan) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:lijitiyan];
    

    //[skipBtn addTarget:self action:@selector(launch) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > SCREEN_WIDTH * 3) {
        [self goMainView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int current = scrollView.contentOffset.x / 320;
    _pageControl.currentPage = current;
    [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
}

-(IBAction)changePage:(id)sender
{
    int page = _pageControl.currentPage;
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH* page, 0)];
}

-(void)lijitiyan
{
    self.view = nil;
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    KGTabBarViewController *vc= [[KGTabBarViewController alloc] init];
    [vc goFPFamilyPhotoMainViewController];
    window.rootViewController =vc;
    
}

-(void)goMainView
{
    self.view = nil;
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    KGTabBarViewController *vc= [[KGTabBarViewController alloc] init];
    
    window.rootViewController =vc;
}


+(void) firstLaunch{
    //判断是不是第一次启动应用
    NSString *firstLaunch =@"firstLaunch2";
     UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if(![[NSUserDefaults standardUserDefaults] boolForKey:firstLaunch])
    {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:firstLaunch];
        NSLog(@"第一次启动");
        //如果是第一次启动的话,使用UserGuideViewController (用户引导页面) 作为根视图
        GuidePageController *userGuideViewController = [[GuidePageController alloc] init];
       
        window.rootViewController = userGuideViewController;
        
    }else{
        if([ window.rootViewController isKindOfClass:[KGTabBarViewController class]]){
            return;
        }
       
        window.rootViewController = [[KGTabBarViewController alloc] init];
    }
    
    
}
@end
