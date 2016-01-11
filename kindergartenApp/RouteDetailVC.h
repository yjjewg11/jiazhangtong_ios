//
//  RouteDetailVC.h
//  kindergartenApp
//
//  Created by Mac on 16/1/11.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "BaseViewController.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "RouteDomain.h"

@interface RouteDetailVC : BaseViewController <BMKMapViewDelegate>
{
    __weak IBOutlet BMKMapView *_mapView;
}

@property (strong, nonatomic) RouteDomain * domain;

@end
