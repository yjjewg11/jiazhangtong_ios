//
//  RouteDetailVC.m
//  kindergartenApp
//
//  Created by Mac on 16/1/11.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "RouteDetailVC.h"
#import "RouteDetailInfoCell.h"
#import "UIImage+Rotate.h"
#import "ShowRouteVC.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;

@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;

@end


@interface RouteDetailVC () <UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UIView *_detailView;
    
    __weak IBOutlet UITableView *_tableView;
    
    __weak IBOutlet UILabel *titleLbl;
    
    __weak IBOutlet UILabel *infoLbl;
    
    __weak IBOutlet NSLayoutConstraint *detailViewBottomConstrints;
}

@property (assign, nonatomic) BOOL detailViewOpen;

@end

@implementation RouteDetailVC

- (NSString*)getMyBundlePath1:(NSString *)filename
{
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}

- (void)dealloc
{
    if (_mapView) {
        _mapView = nil;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [self drawRouteLine];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (RouteDomain *)domain
{
    if (_domain == nil)
    {
        _domain = [[RouteDomain alloc] init];
    }
    return _domain;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.detailViewOpen = YES;
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (self.domain.type == 1)
    {
        titleLbl.text = @"驾车方案";
        
    }else if (self.domain.type == 2)
    {
        titleLbl.text = @"步行方案";
    }
    else
    {
        titleLbl.text = @"公交方案";
    }
    
    self.title = titleLbl.text;
    
    infoLbl.text = [NSString stringWithFormat:@"%@ | %@ | %@",self.domain.routeTime,self.domain.routeFar,self.domain.routeWalkMiles];
}

- (IBAction)scaleBtnClick:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^
    {
        if (self.detailViewOpen == YES)
        {
            [_detailView setOrigin:CGPointMake(0, APPWINDOWHEIGHT - 64 - 75)];
            self.detailViewOpen = NO;
            
        }else
        {
            [_detailView setOrigin:CGPointMake(0, APPWINDOWHEIGHT - 64 - 75 - 175)];
            self.detailViewOpen = YES;
        }
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.domain.instructionArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * routeDetailCellID = @"rdid";
    
    RouteDetailInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:routeDetailCellID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RouteDetailInfoCell" owner:nil options:nil] firstObject];
    }
    
    cell.titleLbl.text = self.domain.instructionArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


#pragma mark - 路径显示相关
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation *)routeAnnotation
{
    BMKAnnotationView * view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]])
    {
        return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation *)annotation];
    }
    
    return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}

#pragma mark - 画线了
- (void)drawRouteLine
{
    switch (self.domain.type)
    {
        case 0:
            [self drawBusLine];
            break;
        case 1:
            [self drawDriveLine];
            break;
        case 2:
            [self drawWalkLine];
            break;
        default:
            break;
    }
}

- (void)drawBusLine
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    
    BMKTransitRouteLine * plan = (BMKTransitRouteLine *)self.domain.plan;
    // 计算路线方案中的路段数目
    NSInteger size = [plan.steps count];
    int planPointCounts = 0;
    
    for (int i = 0; i < size; i++)
    {
        BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
        if(i==0){
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = plan.starting.location;
            item.title = @"起点";
            item.type = 0;
            [_mapView addAnnotation:item]; // 添加起点标注
            
        }else if(i==size-1){
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = plan.terminal.location;
            item.title = @"终点";
            item.type = 1;
            [_mapView addAnnotation:item]; // 添加起点标注
        }
        RouteAnnotation* item = [[RouteAnnotation alloc]init];
        item.coordinate = transitStep.entrace.location;
        item.title = transitStep.instruction;
        item.type = 3;
        [_mapView addAnnotation:item];
        
        //轨迹点总数累计
        planPointCounts += transitStep.pointsCount;
    }
    
    //轨迹点
    BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
    int i = 0;
    for (int j = 0; j < size; j++) {
        BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
        int k=0;
        for(k=0;k<transitStep.pointsCount;k++) {
            temppoints[i].x = transitStep.points[k].x;
            temppoints[i].y = transitStep.points[k].y;
            i++;
        }
        
    }
    // 通过points构建BMKPolyline
    BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
    [_mapView addOverlay:polyLine]; // 添加路线overlay
    delete []temppoints;
    [self mapViewFitPolyLine:polyLine];

}

- (void)drawDriveLine
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    
    BMKDrivingRouteLine* plan = (BMKDrivingRouteLine *)self.domain.plan;
    // 计算路线方案中的路段数目
    NSInteger size = [plan.steps count];
    int planPointCounts = 0;
    for (int i = 0; i < size; i++) {
        BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
        if(i==0){
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = plan.starting.location;
            item.title = @"起点";
            item.type = 0;
            [_mapView addAnnotation:item]; // 添加起点标注
            
        }else if(i==size-1){
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = plan.terminal.location;
            item.title = @"终点";
            item.type = 1;
            [_mapView addAnnotation:item]; // 添加起点标注
        }
        //添加annotation节点
        RouteAnnotation* item = [[RouteAnnotation alloc]init];
        item.coordinate = transitStep.entrace.location;
        item.title = transitStep.entraceInstruction;
        item.degree = transitStep.direction * 30;
        item.type = 4;
        [_mapView addAnnotation:item];
        
        //轨迹点总数累计
        planPointCounts += transitStep.pointsCount;
    }
    // 添加途经点
    if (plan.wayPoints) {
        for (BMKPlanNode* tempNode in plan.wayPoints) {
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item = [[RouteAnnotation alloc]init];
            item.coordinate = tempNode.pt;
            item.type = 5;
            item.title = tempNode.name;
            [_mapView addAnnotation:item];
        }
    }
    //轨迹点
    BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
    int i = 0;
    for (int j = 0; j < size; j++)
    {
        BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
        int k=0;
        for(k=0;k<transitStep.pointsCount;k++)
        {
            temppoints[i].x = transitStep.points[k].x;
            temppoints[i].y = transitStep.points[k].y;
            i++;
        }
    }
    // 通过points构建BMKPolyline
    BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
    [_mapView addOverlay:polyLine]; // 添加路线overlay
    delete []temppoints;
    [self mapViewFitPolyLine:polyLine];

}

- (void)drawWalkLine
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    
    BMKWalkingRouteLine * plan = (BMKWalkingRouteLine *)self.domain.plan;
    NSInteger size = [plan.steps count];
    int planPointCounts = 0;
    for (int i = 0; i < size; i++)
    {
        BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
        if(i==0){
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = plan.starting.location;
            item.title = @"起点";
            item.type = 0;
            [_mapView addAnnotation:item]; // 添加起点标注
            
        }else if(i==size-1){
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = plan.terminal.location;
            item.title = @"终点";
            item.type = 1;
            [_mapView addAnnotation:item]; // 添加起点标注
        }
        //添加annotation节点
        RouteAnnotation* item = [[RouteAnnotation alloc]init];
        item.coordinate = transitStep.entrace.location;
        item.title = transitStep.entraceInstruction;
        item.degree = transitStep.direction * 30;
        item.type = 4;
        [_mapView addAnnotation:item];
        
        //轨迹点总数累计
        planPointCounts += transitStep.pointsCount;
    }
    
    //轨迹点
    BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
    
    int i = 0;
    
    for (int j = 0; j < size; j++)
    {
        BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
        
        int k=0;
        
        for(k=0;k<transitStep.pointsCount;k++)
        {
            temppoints[i].x = transitStep.points[k].x;
            temppoints[i].y = transitStep.points[k].y;
            i++;
        }
        
    }
    // 通过points构建BMKPolyline
    BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
    [_mapView addOverlay:polyLine]; // 添加路线overlay
    delete []temppoints;
    [self mapViewFitPolyLine:polyLine];
}

@end
