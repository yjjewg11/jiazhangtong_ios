//
//  SystemEnum.h
//  funiiPhoneApp
//
//  Created by rockyang on 14-5-10.
//  Copyright (c) 2014年 LQ. All rights reserved.
//

#import "AppDelegate.h"

//定义配置数据类型
typedef enum {
	ConfigTypeRegion          = 1,//区域
    ConfigTypeArea            = 2,//面积
    ConfigTypeProperty        = 3,//物业类型
    ConfigTypeListPriceRange  = 4,//价格区间
    ConfigTypeRoomType        = 5,//户型
    ConfigTypeStatus          = 6,//状态
    ConfigTypeBuildUnit       = 7,//栋/单元
    ConfigTypeFloor           = 8, //楼层
    ConfigTypeOffice          = 9, //办公
    ConfigTypeBusiness        = 10,//商业
    ConfigTypeHouse           = 11 //住宅
}APPConfigType;


typedef enum {
    Topic_Interact = 0, //：互动
    Topic_Announcement = 1, //：公告
    Topic_Course = 2,  //：课程表
    Topic_Recipes =3,  //：食谱
    Topic_Articles = 4   //：文章
} KGTopicType;