//
//  SPBottomItemTools.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/4.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "SPBottomItemTools.h"
#import "SPBottomItem.h"
@implementation SPBottomItemTools

+(NSMutableArray *)createBottoms:(UIView *)view imageName:(NSArray *) imageName titleName:(NSArray *) titleName addTarget:(id )target action:(SEL)action{
    
    NSMutableArray * buttonItems = [NSMutableArray array];
    
    
    int totalloc = titleName.count;
    CGFloat spcoursew = 80;
    CGFloat spcourseh = 48;
    CGFloat margin = (view.frame.size.width - totalloc * spcoursew) / (totalloc + 1);
    
    for (NSInteger i = 0; i < 5; i++)
    {
        NSInteger row = (NSInteger)(i / totalloc);  //行号
        NSInteger loc = i % totalloc;               //列号
        
        SPBottomItem * item = [[[NSBundle mainBundle] loadNibNamed:@"SPBottomItem" owner:nil options:nil] firstObject];
       
        [item setPic:imageName[i] Title:titleName[i]];
        
        item.btn.tag = i;
        
        [item.btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat itemX = margin + (margin + spcoursew) * loc;
        CGFloat itemY =  (margin + spcourseh) * row;
        CGFloat itemH = item.frame.size.height;
        CGFloat itemW = item.frame.size.width;
        
        item.frame = CGRectMake(itemX, itemY, itemW, itemH);
        
        [buttonItems addObject:item];
        
        [view addSubview:item];
    }
    
    UIView * sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 1)];
    sepView.backgroundColor = [UIColor lightGrayColor];
    sepView.alpha = 0.5;
    [view addSubview:sepView];
    return buttonItems;
}





@end
