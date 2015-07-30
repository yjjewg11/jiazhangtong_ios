//
//  HomeViewController.m
//  kindergartenApp
//
//  Created by yangyangxun on 15/7/18.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "HomeViewController.h"
#import "ImageCollectionView.h"
#import "Masonry.h"
#import "KGIntroductionViewController.h"
#import "UIView+Extension.h"
#import "RegViewController.h"
#import "SphereMenu.h"
#import "KGHttpService.h"
#import "KGHUD.h"
#import "AnnouncementListViewController.h"
#import "InteractViewController.h"
#import "TeacherJudgeViewController.h"

@interface HomeViewController () <ImageCollectionViewDelegate, SphereMenuDelegate> {
    
    IBOutlet UIScrollView * scrollView;
    IBOutlet UIView * photosView;
    IBOutlet UIView * funiView;
    
    IBOutlet UIView * moreView;
    IBOutlet UIImageView * moreImageView;
    SphereMenu * sphereMenu;
}

@end

@implementation HomeViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self loadMoreMenu:[KGHttpService sharedService].dynamicMenuArray];
        
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    scrollView.contentSize = CGSizeMake(self.view.width, funiView.y + funiView.height + Number_Ten);
    [self loadPhotoView];
    [self loadDynamicMenu];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


///加载动态菜单
- (void)loadDynamicMenu {
//    [[KGHttpService sharedService] getDynamicMenu:^(NSArray *menuArray) {
//        [self loadMoreMenu:menuArray];
//    } faild:^(NSString *errorMsg) {
//        
//    }];
}

- (void)loadMoreMenu:(NSArray *)menuArray {
    
    [sphereMenu removeFromSuperview];
    
    UIImage *startImage = [UIImage imageNamed:@"yuan"];
//    UIImage *image1 = [UIImage imageNamed:@"yuan"];
//    UIImage *image2 = [UIImage imageNamed:@"yuan"];
//    UIImage *image3 = [UIImage imageNamed:@"yuan"];
//    NSArray *images = @[image1, image2, image3];
    
    sphereMenu = [[SphereMenu alloc] initWithStartPoint:moreImageView.center
                                             startImage:startImage
                                          submenu:menuArray];
    sphereMenu.sphereDamping = 0.8;
    sphereMenu.sphereLength = 65;
    sphereMenu.angle = M_PI_2 / 2;
    sphereMenu.delegate = self;
    [moreView addSubview:sphereMenu];
}


- (void)loadPhotoView {
    NSMutableArray * list = [[NSMutableArray alloc] initWithObjects:@"http://f.hiphotos.baidu.com/image/pic/item/a08b87d6277f9e2fa2e847f21c30e924b999f36f.jpg", @"http://a.hiphotos.baidu.com/image/pic/item/342ac65c10385343eb8dfdb69013b07ecb8088e2.jpg", @"http://h.hiphotos.baidu.com/image/pic/item/cefc1e178a82b901e592a725708da9773912efed.jpg", @"http://g.hiphotos.baidu.com/image/pic/item/dbb44aed2e738bd40df8d727a28b87d6267ff9cf.jpg", @"http://f.hiphotos.baidu.com/image/pic/item/3801213fb80e7beca940b6b12d2eb9389a506bcc.jpg", nil];
    
    ImageCollectionView * imgcollview = [[ImageCollectionView alloc] initWithFrame:CGRectMake(Number_Zero, Number_Zero, CGRectGetWidth(self.view.frame), CGRectGetHeight(photosView.frame))];
    imgcollview.dataSource = list;
    imgcollview._delegate = self;
    
    [photosView addSubview:imgcollview];
    imgcollview.backgroundColor = [UIColor grayColor];
    [imgcollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(photosView.mas_top);
        make.left.equalTo(photosView.mas_left);
        make.right.equalTo(photosView.mas_right);
        make.bottom.equalTo(photosView.mas_bottom);
    }];
    
    [imgcollview showImageCollectionView];
}



#pragma ImageCollectionViewDelegate

//单击回调
-(void)singleTapEvent:(NSString *)pType {
    
}



- (IBAction)funBtnClicked:(UIButton *)sender {
    BaseViewController * baseVC = nil;
    switch (sender.tag) {
        case 10:
            baseVC = [[InteractViewController alloc] init];
            break;
        case 11:
            baseVC = [[KGIntroductionViewController alloc] init];
            break;
        case 12:
            baseVC = [[AnnouncementListViewController alloc] init];
            break;
        case 13:
            baseVC = [[AnnouncementListViewController alloc] init];
            break;
        case 14:
            baseVC = [[AnnouncementListViewController alloc] init];
            break;
        case 15:
            baseVC = [[AnnouncementListViewController alloc] init];
            break;
        case 16:
            baseVC = [[AnnouncementListViewController alloc] init];
            break;
        case 17:
            baseVC = [[AnnouncementListViewController alloc] init];
            break;
        case 18:
            baseVC = [[TeacherJudgeViewController alloc] init];
            break;
        case 19:
            [self loadMoreFunMenu:sender];
            break;
        default:
            break;
    }
    
    if(baseVC) {
        [self.navigationController pushViewController:baseVC animated:YES];
    }
}


- (void)loadMoreFunMenu:(UIButton *)sender {
    [sphereMenu showMenu];
}


- (void)sphereDidSelected:(int)index {
    NSLog(@"sphere %d selected", index);
}


@end
