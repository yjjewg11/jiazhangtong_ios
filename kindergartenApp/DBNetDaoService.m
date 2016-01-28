///Users/Mac/ios开发/jiazhangban_ios/kindergartenApp
//  DBNetDaoService.m
//  kindergartenApp
//
//  Created by Mac on 16/1/21.
//  Copyright © 2016年 funi. All rights reserved.
//
#import "DBNetDaoService.h"
#import "FPFamilyInfoDomain.h"
#import "KGDateUtil.h"
#import "MJExtension.h"
#import "FPFamilyPhotoStatusDomain.h"
#import "FPFamilyPhotoNormalDomain.h"
#import <sqlite3.h>

#define DBNAME    @"familyphoto.sqlite"

#define FAMILY_UUID     @"family_uuid"
#define MAXTIME         @"maxtime"
#define MINTIME         @"mintime"
#define TABLENAME       @"fp_familyinfo"

@interface DBNetDaoService()
{
    sqlite3 * db;
}

@end

@implementation DBNetDaoService

- (instancetype)init
{
    if (self = [super init])
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documents = [paths objectAtIndex:0];
        NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
        
        if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK)
        {
            sqlite3_close(db);
            NSLog(@"数据库打开失败");  
        }
        else
        {
            NSLog(@"数据库打开成功");
            //创建表 图片信息
            NSString * fp_photo_item_Table = @"CREATE TABLE IF NOT EXISTS fp_photo_item (uuid CHAR(45) PRIMARY KEY NOT NULL,status INT,family_uuid  CHAR(45),'create_time' datetime,'photo_time' datetime,'create_useruuid' CHAR (45),'path' CHAR (512),'address' CHAR (45),'note' CHAR (300),'md5' CHAR (512));CREATE INDEX IF NOT EXISTS index_1 ON fp_photo_item (create_time);CREATE INDEX IF NOT EXISTS index_2 ON fp_photo_item (photo_time);CREATE INDEX IF NOT EXISTS index_3 ON fp_photo_item (family_uuid);";
            
            //保存家庭相册时间信息
            NSString * fp_familyinfo_Table = @"CREATE TABLE IF NOT EXISTS fp_familyinfo (family_uuid CHAR(45) PRIMARY KEY NOT NULL,'maxtime' datetime,'mintime' datetime,'updatetime' datetime);";
            
            //上传用 上传队列信息
            NSString * fp_upload_Table = @"CREATE TABLE IF NOT EXISTS fp_upload (localpath CHAR(1024) PRIMARY KEY NOT NULL,'status' CHAR(2),'success_time' datetime);";

            
            [self execSql:fp_photo_item_Table];
            [self execSql:fp_familyinfo_Table];
        }
    }
    return self;
}


#pragma mark - 获取时间轴图片
- (void)getTimelinePhotos:(NSString *)familyUUID
{
    //从数据库查询 familyUUID 所对应的 maxTime 和 minTime 如果没有相应数据 则自动创建一条，且把maxTime和minTime设置为空
    FPFamilyInfoDomain * domain = [self queryTimeByFamilyUUID:familyUUID];
    
    if (domain.maxTime == nil && domain.minTime == nil && domain.updateTime == nil)
    {
        NSDate *localeDate = [KGDateUtil getLocalDate];
        NSString * nowTime = [KGDateUtil getFPFormatSringWithDate:localeDate];

        //从服务器请求数据
        [[KGHttpService sharedService] getPhotoCollectionUseFamilyUUID:familyUUID withTime:nowTime timeType:1 pageNo:@"1" success:^(FPFamilyPhotoLastTimeVO *lastTimeVO)
        {
            NSLog(@"请求第一次进入数据成功");
            NSArray * datas = [FPFamilyPhotoNormalDomain objectArrayWithKeyValuesArray:lastTimeVO.data];
            
            //把数据缓存到本地
            NSLog(@"缓存初次进入相片数据到数据库中");
            [self addPhotoToDatabase:(datas)];
            
            //设置maxTime 和 minTime到这个familyUUID
            NSLog(@"%@ =更新time中=  %@ === %@",[KGDateUtil getLocalDateStr],lastTimeVO.lastTime,[KGDateUtil getLocalDateStr]);
            [self updateMaxTime:familyUUID maxTime:[KGDateUtil getLocalDateStr] minTime:lastTimeVO.lastTime uptime:[KGDateUtil getLocalDateStr]];
            
            [self notiVC];
        }
        faild:^(NSString *errorMsg)
        {
            NSLog(@"请求照片数据失败");
        }];
    }
    else if (domain == nil)
    {
        NSLog(@"fpfamilyinfodomain 为 nil !");
    }
    else
    {
        [self notiVC];
        
        //调用接口10，根据这个时间范围查询新数据总数和变化数据总数
        NSString * maxTimeStr = domain.maxTime;
        NSString * minTimeStr = domain.minTime;
        NSString * updateTimeStr = domain.updateTime;
        
        //调用接口11,查询增量更新数据
        [self queryUpdateDatas:familyUUID maxTime:maxTimeStr minTime:minTimeStr updateTime:updateTimeStr];
        
        //查询最新相片条目
        [[KGHttpService sharedService] getFPPhotoUpdateCountWithFamilyUUID:familyUUID maxTime:maxTimeStr success:^(FPFamilyPhotoUpdateCount *domain)
         {
             NSLog(@"新数据的条数是:%d",domain.newDataCount);
             
             if (domain.newDataCount > 0)
             {
                 //调用接口9 查询最新相片
                 [self queryNewPhotos:familyUUID minTime:maxTimeStr];
             }
         }
         faild:^(NSString *errorMsg)
         {
             NSLog(@"FP - getTimelinePhotos:%@",errorMsg);
         }];
    }
}

#pragma mark - 根据 familyuuid 尝试从本地数据库获取相册数据 不存在的话 新创建一个 并把maxTime和minTime设置为nil
- (FPFamilyInfoDomain *)queryTimeByFamilyUUID:(NSString *)familyUUID
{
    NSString * sqlQuery = [NSString stringWithFormat:@"SELECT * FROM fp_familyinfo WHERE family_uuid='%@'",familyUUID];
    
    sqlite3_stmt * statement;
    
    FPFamilyInfoDomain * domain = [FPFamilyInfoDomain new];
    
    char *err;
    if (sqlite3_exec(db, [sqlQuery UTF8String], NULL, NULL, &err) != SQLITE_OK)
    {
        fprintf( stderr , " SQL error : %s\n " , err);
        return NO;
    }
    else
    {
        if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSLog(@"找到 familyinfo domain 了!");
                char * familyuuid = (char *)sqlite3_column_text(statement, 0);
                NSString *familyuuidStr = [[NSString alloc] initWithUTF8String:familyuuid];
                
                char * maxTime = (char *)sqlite3_column_text(statement, 1);
                NSString * maxTimeStr = [[NSString alloc] initWithUTF8String:maxTime];
                
                char * minTime = (char *)sqlite3_column_text(statement, 2);
                NSString * minTimeStr = [[NSString alloc] initWithUTF8String:minTime];
                
                char * updateTime = (char *)sqlite3_column_text(statement, 3);
                NSString * updateTimeStr = [[NSString alloc] initWithUTF8String:updateTime];
                
                NSLog(@"uuid:%@  maxTime:%@  minTime:%@  updateTime:%@",familyuuidStr,maxTimeStr, minTimeStr,updateTimeStr);
                
                domain.family_uuid = familyuuidStr;
                domain.maxTime = maxTimeStr;
                domain.minTime = minTimeStr;
                domain.updateTime = updateTimeStr;
                
                return domain;
            }
        }
        
        NSLog(@"没找到 familyinfo domain,插入domain");
        //插入数据
        NSString *sql = [NSString stringWithFormat:
                         @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%@', '%@')",
                         TABLENAME, FAMILY_UUID, MAXTIME, MINTIME, familyUUID, nil, nil];
        
        domain.family_uuid = familyUUID;
        domain.maxTime = nil;
        domain.minTime = nil;
        
        if([self execSql:sql])
        {
            return domain;
        }
        else
        {
            return nil;
        }
    }
}

#pragma mark - 根据familyuuid 更新maxTime 和 minTime
- (void)updateMaxTime:(NSString *)familyUUID maxTime:(NSString *)maxTime minTime:(NSString *)minTime uptime:(NSString *)updateTime
{
    //组织SQL语句
    NSString *sql = [NSString stringWithFormat:@"update fp_familyinfo set maxtime=datetime('%@'),mintime=datetime('%@'),updatetime=datetime('%@') WHERE family_uuid='%@'",maxTime,minTime,updateTime,familyUUID];
    
    [self execSql:sql];
}

#pragma mark - 保存新的图片到数据库
- (void)addPhotoToDatabase:(NSArray *)photos
{
    NSMutableArray * transactionSql = [[NSMutableArray alloc] init];
    
    NSLog(@"需要保存的图片数量:%d",photos.count);
    
    for (NSInteger i=0; i<photos.count; i++)
    {
        FPFamilyPhotoNormalDomain * dataDomain = photos[i];
        
        NSString * sql = [NSString stringWithFormat:@"insert into fp_photo_item (uuid,status,family_uuid,create_time,photo_time,create_useruuid,path,address,note,md5) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",dataDomain.uuid,dataDomain.status,dataDomain.family_uuid,dataDomain.create_time,dataDomain.photo_time,dataDomain.create_useruuid,dataDomain.path,dataDomain.address,dataDomain.note,dataDomain.md5];
        
        [transactionSql addObject:sql];
    }
    
    [self execInsertTransactionSql:transactionSql];
}

#pragma mark -  查询增量更新数据（缓存本地）
- (void)queryUpdateDatas:(NSString *)familyUUID maxTime:(NSString *)maxTime minTime:(NSString *)minTime updateTime:(NSString *)updateTime;
{
    [[KGHttpService sharedService] getFPPhotoUpdateDataWithFamilyUUID:familyUUID maxTime:maxTime minTime:minTime updateTime:updateTime success:^(NSArray *needUpDateDatas)
    {
        if (needUpDateDatas.count > 0)
        {
            [self updatePhotoStatus:needUpDateDatas];
            //这里更新updatetime
            [self updateUpdateTime:familyUUID updatetime:[KGDateUtil getLocalDateStr]];
        }
        
    } faild:^(NSString *errorMsg)
    {
        
    }];
}

#pragma mark - 根据uuid 更新photo的status
- (void)updatePhotoStatus:(NSArray *)infos
{
    NSLog(@"找到需要更新的相片数量:%d",infos.count);
    
    NSMutableArray * transactionSql = [[NSMutableArray alloc] init];
    
    for (NSInteger i=0; i<infos.count; i++)
    {
        FPFamilyPhotoStatusDomain * domain = infos[i];
        
        NSString * sql = [NSString stringWithFormat:@"update fp_photo_item set maxtime = '%@' WHERE uuid = %@",domain.s,domain.u];
        
        [transactionSql addObject:sql];
    }
    
    [self execInsertTransactionSql:transactionSql];
}

#pragma mark - 获取最新时间的相片
- (void)queryNewPhotos:(NSString *)familyUUID minTime:(NSString *)minTimeStr
{
    [[KGHttpService sharedService] getPhotoCollectionUseFamilyUUID:familyUUID withTime:minTimeStr timeType:0 pageNo:@"1" success:^(FPFamilyPhotoLastTimeVO *lastTimeVO)
    {
        NSLog(@"获取到了最新相片!,更新maxtime中");
        //这里要更新maxtime;
        [self updateMaxTime:familyUUID maxTime:lastTimeVO.lastTime];
        
        NSArray * datas = [FPFamilyPhotoNormalDomain objectArrayWithKeyValuesArray:lastTimeVO.data];
        //更新数据库
        [self addPhotoToDatabase:datas];
        
        NSLog(@"通知vc有新数据了!");
        //通知VC可以更新数据了
        NSNotification * noti = [[NSNotification alloc] initWithName:@"canUpDatePhotoData" object:datas userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
    }
    faild:^(NSString *errorMsg)
    {
        NSLog(@"queryNewPhotos:%@",errorMsg);
    }];
}

#pragma mark - tools
- (BOOL)execSql:(NSString *)sql
{
    char *err;
    
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
    {
        fprintf( stderr , " SQL error : %s\n " , err);
        return NO;
    }
    else
    {
        NSLog(@"数据库操作数据成功");
        return YES;
    }
}

#pragma mark - 批量执行sql
- (void)execInsertTransactionSql:(NSMutableArray *)transactionSql
{
    //使用事务，提交插入sql语句
    @try
    {
        char *errorMsg;
        if (sqlite3_exec(db, "BEGIN", NULL, NULL, &errorMsg)==SQLITE_OK)
        {
            NSLog(@"启动事务成功");
            sqlite3_free(errorMsg);
            sqlite3_stmt *statement;
            for (int i = 0; i<transactionSql.count; i++)
            {
                if (sqlite3_prepare_v2(db,[[transactionSql objectAtIndex:i] UTF8String], -1, &statement,NULL)==SQLITE_OK)
                {
                    if (sqlite3_step(statement)!=SQLITE_DONE) sqlite3_finalize(statement);
                }
            }
            if (sqlite3_exec(db, "COMMIT", NULL, NULL, &errorMsg)==SQLITE_OK)
            {
                NSLog(@"提交事务成功");
            }
            sqlite3_free(errorMsg);
        }
        else sqlite3_free(errorMsg);
    }
    @catch(NSException *e)
    {
        char *errorMsg;
        if (sqlite3_exec(db, "ROLLBACK", NULL, NULL, &errorMsg)==SQLITE_OK)
        {
            NSLog(@"回滚事务成功");
        }
        sqlite3_free(errorMsg);
    }
    @finally
    {
        
    }
}

#pragma mark - 根据familyuuid更新updatetime
- (void)updateUpdateTime:(NSString *)familyuuid updatetime:(NSString *)updatetime
{
    NSLog(@"更新updatetime中");
    
    NSString * sql = [NSString stringWithFormat:@"update fp_familyinfo set updatetime='%@' WHERE family_uuid='%@'",updatetime,familyuuid];
    
    [self execSql:sql];
}

#pragma mark - 根据familyuuid更新maxtime
- (void)updateMaxTime:(NSString *)familyuuid maxTime:(NSString *)maxTime
{
    NSLog(@"更新updatetime中");
    
    NSString * sql = [NSString stringWithFormat:@"update fp_familyinfo set maxtime='%@' WHERE family_uuid='%@'",maxTime,familyuuid];
    
    [self execSql:sql];
}

#pragma mark - 查询列表数据用于时光轴表头显示
- (NSArray *)getListTimeHeadData:(NSString *)familyuuid
{
    NSString * sql = [NSString stringWithFormat:@"SELECT strftime('%%Y-%%m-%%d',create_time),count(1) from fp_photo_item WHERE family_uuid ='%@' GROUP BY strftime('%%Y-%%m-%%d',create_time)",familyuuid];
    
    NSMutableArray * marr = [NSMutableArray array];
    
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        while (sqlite3_step(stmt)==SQLITE_ROW)
        {
            char *time = (char *)sqlite3_column_text(stmt, 0);
            NSString *timeStr = [[NSString alloc] initWithUTF8String:time];
            
            int count = sqlite3_column_int(stmt, 1);
            NSString *countStr = [NSString stringWithFormat:@"%d",count];
            
            NSString * result = [NSString stringWithFormat:@"%@,%@",timeStr,countStr];
            
            [marr addObject:result];
        }
    }
    
    sqlite3_finalize(stmt);
    
    return [marr copy];
}

#pragma mark - 查询相片数据用于单元格显示 (6 limit)

- (NSArray *)getListTimePhotoData:(NSString *)date familyUUID:(NSString *)familyUUID
{
    NSString * sql = [NSString stringWithFormat:@"SELECT path from fp_photo_item WHERE strftime('%%Y-%%m-%%d',create_time) ='%@' and family_uuid ='%@' limit 6",date,familyUUID];
    
    NSMutableArray * marr = [NSMutableArray array];
    
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        while (sqlite3_step(stmt)==SQLITE_ROW)
        {
            char *url = (char *)sqlite3_column_text(stmt, 0);
            NSString *urlStr = [[NSString alloc] initWithUTF8String:url];
            
            [marr addObject:urlStr];
        }
    }
    
    return [marr copy];
}

- (void)notiVC
{
    NSNotification * noti = [[NSNotification alloc] initWithName:@"canLoadData" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
}

#pragma mark - 
- (void)saveUploadPicsUrl:(NSArray *)imgsurl
{
    //根据url 去数据库里面查,如果有,则不存，没有则存
    
}

@end
