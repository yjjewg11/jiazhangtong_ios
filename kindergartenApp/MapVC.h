//
//  MapVC.h
//  kindergartenApp
//
//  Created by Mac on 16/1/7.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "BaseViewController.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface MapVC : BaseViewController <BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate>
{
    __weak IBOutlet BMKMapView *_mapView;
    BMKPoiSearch* _poisearch;
}

@property (strong, nonatomic) NSString * map_point;

@property (strong, nonatomic) NSString * locationName;

@property (strong, nonatomic) NSString * schoolName;

@end
