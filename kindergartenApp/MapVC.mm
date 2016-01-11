//
//  MapVC.m
//  kindergartenApp
//
//  Created by Mac on 16/1/7.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "MapVC.h"
#import "ShowRouteVC.h"

@interface MapVC ()
{
    BMKGeoCodeSearch* _geocodesearch;
    __weak IBOutlet UILabel *_schoolNameLbl;
    __weak IBOutlet UILabel *addressLbl;
    __weak IBOutlet UIView *showRoute;
    __weak IBOutlet UIView *ErrorRefact;
}

@end

@implementation MapVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    showRoute.layer.cornerRadius = 6;
    showRoute.layer.borderWidth = 1;
    showRoute.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    ErrorRefact.layer.cornerRadius = 6;
    ErrorRefact.layer.borderWidth = 1;
    ErrorRefact.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _mapView.hidden = YES;
    addressLbl.text = self.locationName;
    _schoolNameLbl.text = self.schoolName;
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    //启用编码
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    //启用poi  poi!
    _poisearch = [[BMKPoiSearch alloc]init];
    
    NSArray * arr = [self.map_point componentsSeparatedByString:@","];
    
    NSString * x = arr[0];
    NSString * y = arr[1];
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    
    pt = (CLLocationCoordinate2D){[y floatValue], [x floatValue]};
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _poisearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _geocodesearch.delegate = nil; // 不用时，置nil
    _poisearch.delegate = nil; // 不用时，置nil
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBarHidden = NO;
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    
    [_mapView removeAnnotations:array];
    
    array = [NSArray arrayWithArray:_mapView.overlays];
    
    [_mapView removeOverlays:array];
    
    if (error == 0)
    {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        
        item.coordinate = result.location;
        
        item.title = result.address;
        
        [_mapView addAnnotation:item];
        
        _mapView.centerCoordinate = result.location;
        
        _mapView.zoomLevel = 20;
        
        _mapView.hidden = NO;
    }
}

- (IBAction)showRoute:(id)sender
{
    NSArray * arr = [self.map_point componentsSeparatedByString:@","];
    NSString * x = arr[0];
    NSString * y = arr[1];
    CLLocationCoordinate2D ptend = (CLLocationCoordinate2D){0, 0};
    ptend = (CLLocationCoordinate2D){[y floatValue], [x floatValue]};
    
    ShowRouteVC * vc = [[ShowRouteVC alloc] init];
    
    vc.destinationName = self.locationName;
    
    vc.destinationPosition = ptend;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)findSth:(id)sender
{
    _mapView.isSelectedAnnotationViewFront = YES;
    
    BMKNearbySearchOption * searchOption = [[BMKNearbySearchOption alloc]init];
    
    NSArray * arr = [self.map_point componentsSeparatedByString:@","];
    
    NSString * x = arr[0];
    NSString * y = arr[1];
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){[y floatValue], [x floatValue]};
    
    searchOption.keyword = @"幼儿园";
    searchOption.location = pt;
    searchOption.radius = 5000;
    
    BOOL flag = [_poisearch poiSearchNearBy:searchOption];
    
    if(flag)
    {
        NSLog(@"检索发送成功");
    }
    else
    {
        NSLog(@"检索发送失败");
    }
}

#pragma mark implement BMKMapViewDelegate
/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil)
    {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    return annotationView;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}

#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"%d",error);
    
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    if (error == BMK_SEARCH_NO_ERROR)
    {
        NSMutableArray *annotations = [NSMutableArray array];
        for (int i = 0; i < result.poiInfoList.count; i++)
        {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [annotations addObject:item];
        }
        [_mapView addAnnotations:annotations];
        [_mapView showAnnotations:annotations animated:YES];
        
    }else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR)
    {
        NSLog(@"起始点有歧义");
        
    }else
    {
        // 各种情况的判断。。。
    }
}

- (void)dealloc
{
    if (_poisearch != nil)
    {
        _poisearch = nil;
    }
    if (_mapView)
    {
        _mapView = nil;
    }
}

- (IBAction)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
