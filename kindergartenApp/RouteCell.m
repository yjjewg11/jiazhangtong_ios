//
//  RouteCell.m
//  kindergartenApp
//
//  Created by Mac on 16/1/8.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "RouteCell.h"

@interface RouteCell()
{
    __weak IBOutlet UILabel *numLbl;
    
    __weak IBOutlet UILabel *nameLbl;
    
    __weak IBOutlet UILabel *infoLbl;
    
    
    
}

@end

@implementation RouteCell

- (void)setData:(RouteDomain *)domain
{
    if (domain.count < 10)
    {
        numLbl.text = [NSString stringWithFormat:@"0%ld",(long)domain.count];
    }else
    {
        numLbl.text = [NSString stringWithFormat:@"%ld",(long)domain.count];
    }
    
    if (domain.type == 0)
    {
        nameLbl.text = domain.routeName;
    }else if (domain.type == 1)
    {
        nameLbl.text = [NSString stringWithFormat:@"驾车方案%ld",(long)domain.count];
    }else
    {
        nameLbl.text = [NSString stringWithFormat:@"步行方案%ld",(long)domain.count];
    }
    
    
    if (domain.routeWalkMiles == nil)
    {
        domain.routeWalkMiles = @"";
    }
    
    infoLbl.text = [NSString stringWithFormat:@"%@ | %@ | %@",domain.routeTime,domain.routeFar,domain.routeWalkMiles];
}

@end
