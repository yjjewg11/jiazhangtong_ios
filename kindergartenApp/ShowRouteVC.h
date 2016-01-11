//
//  ShowRouteVC.h
//  kindergartenApp
//
//  Created by Mac on 16/1/8.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "BaseViewController.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface ShowRouteVC : BaseViewController <BMKLocationServiceDelegate,BMKRouteSearchDelegate,BMKGeoCodeSearchDelegate>

@property (strong, nonatomic) NSString * myPosition;

@property (strong, nonatomic) NSString * destinationName;

@property (assign, nonatomic) CLLocationCoordinate2D destinationPosition;

@end

