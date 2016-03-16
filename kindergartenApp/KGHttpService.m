//
//  FuniHttpService.m
//  kindergartenApp
//
//  Created by You on 15/6/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//
#import "KGAccountTool.h"
#import "KGHttpService.h"
#import "AFAppDotNetAPIClient.h"
#import "KGHttpUrl.h"
#import "MJExtension.h"
#import "KGListBaseDomain.h"
#import "DynamicMenuDomain.h"
#import "GroupDomain.h"
#import "MessageDomain.h"
#import "StudentSignRecordDomain.h"
#import "RecipesDomain.h"
#import "EmojiDomain.h"
#import "AddressBookDomain.h"
#import "chatInfoDomain.h"
#import "KGEmojiManage.h"
#import "TimetableDomain.h"
#import "ClassDomain.h"
#import "CardInfoDomain.h"
#import "AFNetworking.h"
#import "SPTimetableDomain.h"
#import "SPCourseTypeDomain.h"
#import "SPCourseDetailDomain.h"
#import "SPSchoolDomain.h"
#import "EnrolStudentsSchoolDomain.h"
#import "FPCollegeListDomin.h"
#import "FPCollegePhotoDetailDomin.h"

@implementation KGHttpService

+ (KGHttpService *)sharedService {
    static KGHttpService *_sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedService = [[KGHttpService alloc] init];
    });
    
    return _sharedService;
}


// 1001  1009
- (void)requestErrorCode:(NSError*)error faild:(void (^)(NSString* errorMessage))faild
{
    switch (error.code) {
        case -1001:
            faild(@"网络错误，请稍后再试！");
            break;
        case -1004:
        case -1009:
            faild(@"网络错误，请稍后再试！");
            break;
        default:
            faild(@"网络错误，请稍后再试！");
            break;
    }
}

//根据组织id得到图片
- (NSString *)getGroupImgByUUID:(NSString *)groupUUID {
    NSString * str = @"group_head_def";
    for(GroupDomain * domain in self.loginRespDomain.group_list) {
        if([domain.uuid isEqualToString:groupUUID]) {
            str = domain.img;
            break;
        }
    }
    
    return str;
}


//根据组织id得到名称
- (NSString *)getGroupNameByUUID:(NSString *)groupUUID {
    NSString * str = nil;
    for(GroupDomain * domain in self.groupArray) {
        if([domain.uuid isEqualToString:groupUUID]) {
            str = domain.brand_name;
            break;
        }
    }
    
    return str;
}

//根据学生id得到班级
- (NSString *)getClassNameByUUID:(NSString *)classUUID {
    NSString * str = nil;
    for(ClassDomain * domain in self.loginRespDomain.class_list) {
        if([domain.uuid isEqualToString:classUUID]) {
            str = domain.name;
            break;
        }
    }
    
    return str;
}


//获取学生信息
- (KGUser *)getUserByUUID:(NSString *)uuid {
    for(KGUser * user in _loginRespDomain.list) {
        if([uuid isEqualToString:user.uuid]) {
            return user;
        }
    }
    return nil;
}

//根据班级获取学生信息
- (KGUser *)getUserByClassUUID:(NSString *)uuid {
    for(KGUser * user in _loginRespDomain.list) {
        if([uuid isEqualToString:user.classuuid]) {
            return user;
        }
    }
    return nil;
}

//sessionTimeout处理
- (void)sessionTimeoutHandle:(KGBaseDomain *)baseDomain
{
    if([baseDomain.ResMsg.status isEqualToString:String_SessionTimeout])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:Key_Notification_SessionTimeout object:self userInfo:nil];
        return;
    }
}


/**
 *  获取服务器数据
 *
 *  @param jsonDictionary 参数
 *  @param success
 *  @param faild
 */
-(void)getServerJson:(NSString *)path params:(NSDictionary *)jsonDictionary success:(void (^)(KGBaseDomain * baseDomain))success faild:(void (^)(NSString * errorMessage))faild
{
    NSData   * jsonData       = nil;
    
    if([NSJSONSerialization isValidJSONObject:jsonDictionary])
    {
        jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:nil];
    }
    
    NSURL * url = [NSURL URLWithString:path];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: jsonData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%ld", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSError * errorReturned = nil;
        NSString * responseString = nil;
        NSURLResponse * theResponse =[[NSURLResponse alloc]init];
        NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&errorReturned];
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        
        if (errorReturned) {
            dispatch_async(mainQueue, ^{
                faild(String_Message_RequestError);
            });
        } else {
            responseString = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:nil];
            
            dispatch_async(mainQueue, ^{
                KGBaseDomain * baseDomainResp = [KGBaseDomain objectWithKeyValues:responseString];
                if([baseDomainResp.ResMsg.status isEqualToString:String_Success]) {
                    success(baseDomainResp);
                } else {
                    [self sessionTimeoutHandle:baseDomainResp];
                    
                    NSString * errorMessage = baseDomainResp.ResMsg.message;
                    if(!errorMessage) {
                        errorMessage = String_Message_RequestError;
                    }
                    faild(errorMessage);
                }
            });
        }
    });
}


//图片上传
- (void)uploadImg:(UIImage *)img withName:(NSString *)imgName type:(NSInteger)imgType success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    NSData * imageData = UIImageJPEGRepresentation(img, 0.4);
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:imgName forKey:@"file"];
    [parameters setObject:[NSNumber numberWithInteger:imgType] forKey:@"type"];
    [parameters setObject:_loginRespDomain.JSESSIONID forKey:@"JSESSIONID"];
    
    
    [[AFAppDotNetAPIClient sharedClient] POST:[KGHttpUrl getUploadImgUrl] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:imageData name:imgName fileName:imgName mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
        [self sessionTimeoutHandle:baseDomain];
        
        if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
            
            success([responseObject objectForKey:@"imgUrl"]);
        } else {
            faild(baseDomain.ResMsg.message);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self requestErrorCode:error faild:faild];
    }];
}

//提交推送token
- (void)submitPushTokenWithStatus:(NSString *)status success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    if(_pushToken) {
        NSDictionary * dic = @{@"device_id" : _pushToken,
                               @"device_type": @"ios",
                               @"status":status};
        
        [self getServerJson:[KGHttpUrl getPushTokenUrl] params:dic success:^(KGBaseDomain *baseDomain) {
            success(baseDomain.ResMsg.message);
        } faild:^(NSString *errorMessage) {
            NSLog(@"errorMsg:%@", errorMessage);
        }];
    }
}

//获取表情
- (void)getEmojiList:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getEmojiUrl]
                                  parameters:nil
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
                                         
                                         if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                                             
                                             NSArray * emojiArrayResp = [EmojiDomain objectArrayWithKeyValuesArray:((NSDictionary *)responseObject)[@"list"]];
                                             
                                             [[KGEmojiManage sharedManage] downloadEmoji:emojiArrayResp];
                                             
                                             success(baseDomain.ResMsg.message);
                                         } else {
                                             faild(baseDomain.ResMsg.message);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask* task, NSError* error) {
                                         [self requestErrorCode:error faild:faild];
                                     }];
}


//获取首页动态菜单
- (void)getDynamicMenu:(void (^)(NSArray * menuArray))success faild:(void (^)(NSString * errorMsg))faild {
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getDynamicMenuUrl]
                                  parameters:nil
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
                                         
                                         if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                                             
                                             _dynamicMenuArray = [DynamicMenuDomain objectArrayWithKeyValuesArray:((NSDictionary *)responseObject)[@"list"]];
                                             
                                             success(_dynamicMenuArray);
                                         } else {
                                             faild(baseDomain.ResMsg.message);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask* task, NSError* error) {
                                         [self requestErrorCode:error faild:faild];
                                     }];
}


//获取机构列表
- (void)getGroupList:(void (^)(NSArray * groupArray))success faild:(void (^)(NSString * errorMsg))faild {
    if(_groupArray) {
        success(_groupArray);
    } else {
        [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getGroupUrl]
                                      parameters:nil
                                         success:^(NSURLSessionDataTask* task, id responseObject) {
                                             
                                             KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
                                             
                                             if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                                                 
                                                 NSArray * groupArrayResp = [GroupDomain objectArrayWithKeyValuesArray:(NSDictionary *)responseObject[@"list"]];
                                                 
                                                 _groupArray = groupArrayResp;
                                                 
                                                 success(groupArrayResp);
                                             } else {
                                                 faild(baseDomain.ResMsg.message);
                                             }
                                         }
                                         failure:^(NSURLSessionDataTask* task, NSError* error) {
                                             [self requestErrorCode:error faild:faild];
                                         }];
    }
}
-(BOOL)setupCookieByLocalJessionid{
    NSHTTPCookie * jessionCookie=[KGAccountTool jessionCookie];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:jessionCookie];
    
    if (jessionCookie) {//有session自动登录
        return true;
    }
    return false;
}
#pragma mark - 设置cookie
- (void)setupCookie
{
    NSMutableDictionary * cookieDic = [NSMutableDictionary dictionary];
    [cookieDic setObject:@"JSESSIONID" forKey:NSHTTPCookieName];
    [cookieDic setObject:_loginRespDomain.JSESSIONID forKey:NSHTTPCookieValue];
    [cookieDic setObject:@"wenjienet.com" forKey:NSHTTPCookiePath];
    [cookieDic setObject:@"0" forKey:NSHTTPCookieVersion];
    [cookieDic setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
    NSHTTPCookie * cookieUser = [NSHTTPCookie cookieWithProperties:cookieDic];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieUser];
}

- (NSString *)cutUrlDomain:(NSString *)url
{
    NSMutableString * tempurl = [[NSMutableString alloc] initWithString:url];
    
    NSString * myUrl = [tempurl componentsSeparatedByString:@"//"][1];
    NSString * secondUrl = [myUrl componentsSeparatedByString:@"/"][0];
    
    NSString * domain = nil;
    
    if ([secondUrl rangeOfString:@":"].location != NSNotFound)
    {
        domain = [secondUrl componentsSeparatedByString:@":"][0];
    }
    else
    {
        domain = secondUrl;
    }
    
    return domain;
}

#pragma mark - 自动登陆调用
- (void)cheakUserJessionID:(NSString *)jid success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild
{
    NSLog(@"aa  %@",[self cutUrlDomain:[KGHttpUrl getUserInfoWithJessionID:jid]]);
    
    NSMutableDictionary * cookieDic = [NSMutableDictionary dictionary];
    [cookieDic setObject:@"JSESSIONID" forKey:NSHTTPCookieName];
    [cookieDic setObject:jid forKey:NSHTTPCookieValue];
    [cookieDic setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieDic setObject:[self cutUrlDomain:[KGHttpUrl getUserInfoWithJessionID:jid]] forKey:NSHTTPCookieDomain];
    NSHTTPCookie * cookieUser = [NSHTTPCookie cookieWithProperties:cookieDic];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieUser];
    
    AFHTTPRequestOperationManager * mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getUserInfoWithJessionID:jid] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             _loginRespDomain = [LoginRespDomain objectWithKeyValues:responseObject];
             
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             [defaults setObject:_loginRespDomain.JSESSIONID forKey:@"loginJessionID"];
             [defaults synchronize];
             
             success(baseDomain.ResMsg.status);
         }
         else
         {
             faild(baseDomain.ResMsg.status);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
//         [self requestErrorCode:error faild:faild];
     }];
}

#pragma mark 账号相关 begin
- (void)login:(KGUser *)user success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
//        if([[KGHttpService sharedService] setupCookieByLocalJessionid]){
////            return;
//        }
    [[AFAppDotNetAPIClient sharedClient] POST:[KGHttpUrl getLoginUrl]
                                   parameters:user.keyValues
                                      success:^(NSURLSessionDataTask* task, id responseObject) {
                                          
                                          _loginRespDomain = [LoginRespDomain objectWithKeyValues:responseObject];
                                          
                                          
                                          NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                          [defaults setObject:_loginRespDomain.JSESSIONID forKey:@"loginJessionID"];
                                          [defaults synchronize];
                                          
                                          if([_loginRespDomain.ResMsg.status isEqualToString:String_Success]) {
                                              
                                              //save cookie
//                                              NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//                                              for (NSHTTPCookie *cookie in [cookieJar cookies]) {
//                                                  if ([Key_JSESSIONID isEqualToString:cookie.name]&&[Key_CookiePxMobilePath isEqualToString:cookie.path]) {
//                                                          
//                                                     
//                                                          
//                                                      [KGAccountTool saveCookieJession:cookie   ];
//                                                 
//                                                  }
//                                                  
                                              
//                                              }
                                              //取到服务器返回的cookies
//                                              [self setupCookie];
//                                              [self userCookie:cookies];
                                              
                                              //默热门选中第一个机构
                                              if([_loginRespDomain.group_list count] > Number_Zero) {
                                                  _groupDomain = [_loginRespDomain.group_list objectAtIndex:Number_Zero];
                                              }
                                              
                                              //获取首页动态菜单
                                              [self getDynamicMenu:^(NSArray *menuArray) {
                                                  
                                              } faild:^(NSString *errorMsg) {
                                                  
                                              }];
                                              
                                              [self getGroupList:^(NSArray *groupArray) {
                                                  
                                              } faild:^(NSString *errorMsg) {
                                                  
                                              }];
                                              
                                              [self getEmojiList:^(NSString *msgStr) {
                                                  
                                              } faild:^(NSString *errorMsg) {
                                                  
                                              }];
                                              
                                              success(_loginRespDomain.ResMsg.message);
                                          } else {
                                              faild(_loginRespDomain.ResMsg.message);
                                          }
                                          
                                      }
                                      failure:^(NSURLSessionDataTask* task, NSError* error) {
                                          [self requestErrorCode:error faild:faild];
                                      }];
}


- (void)logout:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    [self getServerJson:[KGHttpUrl getLogoutUrl] params:nil success:^(KGBaseDomain *baseDomain) {
        success(baseDomain.ResMsg.message);
    } faild:^(NSString *errorMsg) {
        faild(errorMsg);
    }];
}


- (void)reg:(KGUser *)user success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild
{
    [self getServerJson:[KGHttpUrl getRegUrl] params:user.keyValues success:^(KGBaseDomain * baseDomain)
    {
        success(baseDomain.ResMsg.message);
        
    } faild:^(NSString *errorMessage)
    {
        faild(errorMessage);
    }];
}



- (void)updatePwd:(KGUser *)user success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    [self getServerJson:[KGHttpUrl getUpdatepasswordUrl] params:user.keyValues success:^(KGBaseDomain * baseDomain) {
        [self sessionTimeoutHandle:baseDomain];
        success(baseDomain.ResMsg.message);
    } faild:^(NSString *errorMsg) {
        faild(errorMsg);
    }];
}


//获取指定学生绑定的卡号信息
- (void)getBuildCardList:(NSString *)useruuid success:(void (^)(NSArray * cardArray))success faild:(void (^)(NSString * errorMsg))faild {
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getBuildCardUrl:useruuid]
                                  parameters:nil
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
                                         
                                         [self sessionTimeoutHandle:baseDomain];
                                         
                                         if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                                             
                                             NSArray * arrayResp = [CardInfoDomain objectArrayWithKeyValuesArray:baseDomain.data];
                                             
                                             success(arrayResp);
                                         } else {
                                             faild(baseDomain.ResMsg.message);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask* task, NSError* error) {
                                         [self requestErrorCode:error faild:faild];
                                     }];
}

//获取用户信息
- (void)getUserInfo:(NSString *)useruuid success:(void (^)(KGUser * userInfo))success faild:(void (^)(NSString * errorMsg))faild {
    
    NSString * url = [KGHttpUrl getUserInfoUrl:useruuid];
    [[AFAppDotNetAPIClient sharedClient] GET:url
                                  parameters:nil
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
                                         [self sessionTimeoutHandle:baseDomain];
                                         
                                         if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                                             
                                             KGUser * user = [KGUser objectWithKeyValues:baseDomain.data];
                                             
                                             success(user);
                                         } else {
                                             faild(baseDomain.ResMsg.message);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask* task, NSError* error) {
                                         [self requestErrorCode:error faild:faild];
                                     }];
}


- (void)getPhoneVlCode:(NSString *)phone type:(NSInteger)type success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    NSDictionary * dic = @{@"tel"  : phone,
                           @"type" : [NSNumber numberWithInteger:type]};
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getPhoneCodeUrl]
                                  parameters:dic
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
                                         
                                         if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                                             success(baseDomain.ResMsg.message);
                                         } else {
                                             faild(baseDomain.ResMsg.message);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask* task, NSError* error) {
                                         [self requestErrorCode:error faild:faild];
                                     }];

}

// 账号相关 end
#pragma mark  互动相关


// 根据互动id获取互动详情
- (void)getClassNewsByUUID:(NSString *)uuid success:(void (^)(TopicDomain * classNewInfo))success faild:(void (^)(NSString * errorMsg))faild {
    
}

// 新增互动
- (void)saveClassNews:(TopicDomain *)topicDomain success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild
{
    [self getServerJson:[KGHttpUrl getSaveClassNewsUrl] params:topicDomain.keyValues success:^(KGBaseDomain *baseDomain) {
        
        [self sessionTimeoutHandle:baseDomain];
        
        success(baseDomain.ResMsg.message);
    } faild:^(NSString *errorMessage) {
        faild(errorMessage);
    }];
}


// 分页获取班级互动列表
- (void)getClassNews:(PageInfoDomain *)pageObj success:(void (^)(PageInfoDomain * pageInfo))success faild:(void (^)(NSString * errorMsg))faild {
    
    NSDictionary * dict = @{@"pageNo":[NSString stringWithFormat:@"%ld",(long)pageObj.pageNo]};
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getClassNewsMyByClassIdUrl]
                                   parameters:dict
                                      success:^(NSURLSessionDataTask* task, id responseObject) {
                                          
                                          KGListBaseDomain * baseDomain = [KGListBaseDomain objectWithKeyValues:responseObject];
                                          
                                          [self sessionTimeoutHandle:baseDomain];
                                          
                                          if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                                              
                                              baseDomain.list.data = [TopicDomain objectArrayWithKeyValuesArray:baseDomain.list.data];
                                              
                                              success(baseDomain.list);
                                          } else {
                                              faild(baseDomain.ResMsg.message);
                                          }
                                      }
                                      failure:^(NSURLSessionDataTask* task, NSError* error) {
                                          [self requestErrorCode:error faild:faild];
                                      }];
}
// 班级互动 end

//分页获取班级 或者 学校互动列表
- (void)getClassOrSchoolNews:(PageInfoDomain *)pageObj groupuuid:(NSString *)groupuuid courseuuid:(NSString *)courseuuid success:(void (^)(PageInfoDomain * pageInfo))success faild:(void (^)(NSString * errorMsg))faild
{
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getSchoolOrClassNewsUrl:groupuuid courseuuid:courseuuid]
                                  parameters:pageObj.keyValues
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGListBaseDomain * baseDomain = [KGListBaseDomain objectWithKeyValues:responseObject];
                                         
                                         [self sessionTimeoutHandle:baseDomain];
                                         
                                         if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                                             
                                             baseDomain.list.data = [TopicDomain objectArrayWithKeyValuesArray:baseDomain.list.data];
                                             
                                             success(baseDomain.list);
                                         } else {
                                             faild(baseDomain.ResMsg.message);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask* task, NSError* error) {
                                         [self requestErrorCode:error faild:faild];
                                     }];
}

#pragma mark 学生相关 begin
- (void)saveStudentInfo:(KGUser *)user success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    [self getServerJson:[KGHttpUrl getSaveChildrenUrl] params:user.keyValues success:^(KGBaseDomain *baseDomain) {
        
        [self sessionTimeoutHandle:baseDomain];
        success(baseDomain.ResMsg.message);
    } faild:^(NSString *errorMessage) {
        faild(errorMessage);
    }];
}

- (void)addStudentInfo:(KGUser *)user success:(void (^)(NSString * uuid))success faild:(void (^)(NSString * errorMsg))faild
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [mgr POST:[KGHttpUrl getAddChildrenUrl] parameters:user.keyValues success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             KGUser * user = [KGUser objectWithKeyValues:[responseObject objectForKey:@"data"]];
             
             success(user.uuid);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self requestErrorCode:error faild:faild];
     }];
    
}


//学生相关 end


#pragma mark 点赞相关 begin

//保存点赞
- (void)saveDZ:(NSString *)newsuid type:(KGTopicType)dzype success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    NSDictionary * dic = @{@"type":[NSNumber numberWithInteger:dzype], @"newsuuid":newsuid};
    
    [self getServerJson:[KGHttpUrl getSaveDZUrl] params:dic success:^(KGBaseDomain *baseDomain) {
        
        [self sessionTimeoutHandle:baseDomain];
        success(baseDomain.ResMsg.message);
    } faild:^(NSString *errorMessage) {
        faild(errorMessage);
    }];
}

//取消点赞
- (void)delDZ:(NSString *)newsuid success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    NSDictionary * dic = @{@"newsuuid":newsuid};
    
    [self getServerJson:[KGHttpUrl getDelDZUrl] params:dic success:^(KGBaseDomain *baseDomain) {
        
        [self sessionTimeoutHandle:baseDomain];
        success(baseDomain.ResMsg.message);
    } faild:^(NSString *errorMessage) {
        faild(errorMessage);
    }];
}


//点赞列表
- (void)getDZList:(NSString *)newsuid success:(void (^)(DianZanDomain * dzDomain))success faild:(void (^)(NSString * errorMsg))faild {
    
    NSDictionary * dic = @{@"newsuuid":newsuid};
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getDZListUrl]
                                  parameters:dic
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         DianZanDomain * baseDomain = [DianZanDomain objectWithKeyValues:responseObject];
                                         
                                         [self sessionTimeoutHandle:baseDomain];
                                         
                                         if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                                             
                                             success(baseDomain);
                                         } else {
                                             faild(baseDomain.ResMsg.message);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask* task, NSError* error) {
                                         [self requestErrorCode:error faild:faild];
                                     }];
}

//点赞相关 end


#pragma 回复相关 begin

//保存回复
- (void)saveReply:(ReplyDomain *)reply success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    [self getServerJson:[KGHttpUrl getSaveReplyUrl] params:reply.keyValues success:^(KGBaseDomain *baseDomain) {
        
        [self sessionTimeoutHandle:baseDomain];
        success(baseDomain.ResMsg.message);
    } faild:^(NSString *errorMessage) {
        faild(errorMessage);
    }];
}

//取消回复
- (void)delReply:(NSString *)uuid success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    NSDictionary * dic = @{@"uuid":uuid};
    
    [self getServerJson:[KGHttpUrl getDelReplyUrl] params:dic success:^(KGBaseDomain *baseDomain) {
        
        [self sessionTimeoutHandle:baseDomain];
        success(baseDomain.ResMsg.message);
    } faild:^(NSString *errorMessage) {
        faild(errorMessage);
    }];
}

//分页获取回复列表
- (void)getReplyList:(PageInfoDomain *)pageInfo topicUUID:(NSString *)topicUUID success:(void (^)(PageInfoDomain * pageInfo))success faild:(void (^)(NSString * errorMsg))faild {
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:pageInfo.keyValues];
    [dic setValue:topicUUID forKey:@"newsuuid"];
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getReplyListUrl]
                                  parameters:dic
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGListBaseDomain * baseDomain = [KGListBaseDomain objectWithKeyValues:responseObject];
                                         
                                         [self sessionTimeoutHandle:baseDomain];
                                         
                                         if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                                             
                                             baseDomain.list.data = [ReplyDomain objectArrayWithKeyValuesArray:baseDomain.list.data];
                                             
                                             success(baseDomain.list);
                                         } else {
                                             faild(baseDomain.ResMsg.message);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask* task, NSError* error) {
                                         [self requestErrorCode:error faild:faild];
                                     }];
}

//回复相关 end



#pragma 公告相关 begin

//获取单个公告详情
- (void)getAnnouncementInfo:(NSString *)uuid success:(void (^)(AnnouncementDomain * announcementObj))success faild:(void (^)(NSString * errorMsg))faild {
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getAnnouncementInfoUrl:uuid]
                                  parameters:nil
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
                                         
                                         [self sessionTimeoutHandle:baseDomain];
                                         
                                         if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                                             
                                             AnnouncementDomain * announcement = [AnnouncementDomain objectWithKeyValues:baseDomain.data];
                                             
                                             success(announcement);
                                         } else {
                                             faild(baseDomain.ResMsg.message);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask* task, NSError* error) {
                                         [self requestErrorCode:error faild:faild];
                                     }];
}

//分页获取公告列表
- (void)getAnnouncementList:(PageInfoDomain *)pageInfo success:(void (^)(NSArray * announcementArray))success faild:(void (^)(NSString * errorMsg))faild {
    
    NSDictionary * dict = @{@"pageNo":[NSString stringWithFormat:@"%ld",(long)pageInfo.pageNo]};
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getAnnouncementListUrl]
                                  parameters:dict
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGListBaseDomain * baseDomain = [KGListBaseDomain objectWithKeyValues:responseObject];
                                         
                                         [self sessionTimeoutHandle:baseDomain];
                                         
                                         if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                                             
                                             baseDomain.list.data = [AnnouncementDomain objectArrayWithKeyValuesArray:baseDomain.list.data];
                                             
                                             success(baseDomain.list.data);
                                         } else {
                                             faild(baseDomain.ResMsg.message);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask* task, NSError* error) {
                                         [self requestErrorCode:error faild:faild];
                                     }];
}

//公告相关 end



//分页获取消息列表
- (void)getMessageList:(PageInfoDomain *)pageInfo success:(void (^)(NSArray * messageArray))success faild:(void (^)(NSString * errorMsg))faild {
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getMessageListUrl]
                                  parameters:pageInfo.keyValues
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGListBaseDomain * baseDomain = [KGListBaseDomain objectWithKeyValues:responseObject];
                                         
                                         [self sessionTimeoutHandle:baseDomain];
                                         
                                         if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                                             
                                             baseDomain.list.data = [MessageDomain objectArrayWithKeyValuesArray:baseDomain.list.data];
                                             
                                             success(baseDomain.list.data);
                                         } else {
                                             faild(baseDomain.ResMsg.message);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask* task, NSError* error) {
                                         [self requestErrorCode:error faild:faild];
                                     }];
}

//读取消息
- (void)readMessage:(NSString *)msguuid success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    NSString * url = [NSString stringWithFormat:@"%@?uuid=%@", [KGHttpUrl getReadMsgUrl], msguuid];
    [self getServerJson:url params:nil success:^(KGBaseDomain *baseDomain) {
        
        if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
            success(baseDomain.ResMsg.message);
        } else {
            faild(baseDomain.ResMsg.message);
        }
        
    } faild:^(NSString *errorMessage) {
        faild(errorMessage);
    }];
}


#pragma 评价老师 begin

//获取评价老师列表
- (void)getTeacherList:(void (^)(NSArray * teacherArray))success faild:(void (^)(NSString * errorMsg))faild {
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getTeacherListUrl]
                                  parameters:nil
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
                                         
                                         [self sessionTimeoutHandle:baseDomain];
                                         
                                         if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                                             
                                             success([self packageTeacherVO:responseObject]);
                                         } else {
                                             faild(baseDomain.ResMsg.message);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask* task, NSError* error) {
                                         [self requestErrorCode:error faild:faild];
                                     }];

}

- (NSArray *)packageTeacherVO:(id)responseObject {
    NSArray * teacherArray1 = [TeacherVO objectArrayWithKeyValuesArray:responseObject[@"list"]];
    NSArray * teacherArray2 = [TeacherVO objectArrayWithKeyValuesArray:responseObject[@"list_judge"]];
    
    for(TeacherVO * teacherVO in teacherArray1) {
//        teacherVO.teacheruuid = teacherVO.uuid;
        
        for(TeacherVO * teacherVO2 in teacherArray2) {
            if([teacherVO.teacher_uuid isEqualToString:teacherVO2.teacheruuid]) {
                teacherVO.content = teacherVO2.content;
                teacherVO.type = teacherVO2.type;
                teacherVO.teacheruuid = teacherVO2.teacheruuid;
                break;
            }
        }
    }
    return teacherArray1;
}


//评价老师
- (void)saveTeacherJudge:(TeacherVO *)teacherVO success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    [self getServerJson:[KGHttpUrl getSaveTeacherJudgeUrl] params:teacherVO.keyValues success:^(KGBaseDomain *baseDomain) {
        
        [self sessionTimeoutHandle:baseDomain];
        
        if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
            success(baseDomain.ResMsg.message);
        } else {
            faild(baseDomain.ResMsg.message);
        }
        
    } faild:^(NSString *errorMessage) {
        faild(errorMessage);
    }];
}


// 评价老师 end



#pragma 精品文章 begin

//获取单个文章详情
- (void)getArticlesInfo:(NSString *)uuid success:(void (^)(AnnouncementDomain * announcementObj))success faild:(void (^)(NSString * errorMsg))faild {
    
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getArticleInfoListUrl:uuid]
                                  parameters:nil
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
                                         
                                         [self sessionTimeoutHandle:baseDomain];
                                         
                                         if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                                             
                                             AnnouncementDomain * announcement = [AnnouncementDomain objectWithKeyValues:baseDomain.data];
                                             announcement.share_url = [responseObject objectForKey:@"share_url"];
                                             announcement.isFavor = [[responseObject objectForKey:@"isFavor"] boolValue];
                                             announcement.count = [[responseObject objectForKey:@"count"] integerValue];
                                             
                                             success(announcement);
                                         } else {
                                             faild(baseDomain.ResMsg.message);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask* task, NSError* error) {
                                         [self requestErrorCode:error faild:faild];
                                     }];
}

//分页获取文章列表
- (void)getArticlesList:(PageInfoDomain *)pageInfo success:(void (^)(NSArray * articlesArray))success faild:(void (^)(NSString * errorMsg))faild {
    
    NSDictionary * dict = @{@"pageNo":[NSString stringWithFormat:@"%ld",(long)pageInfo.pageNo]};
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getArticleListUrl]
                                  parameters:dict
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGListBaseDomain * baseDomain = [KGListBaseDomain objectWithKeyValues:responseObject];
                                         
                                         [self sessionTimeoutHandle:baseDomain];
                                         
                                         if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                                             
                                             baseDomain.list.data = [AnnouncementDomain objectArrayWithKeyValuesArray:baseDomain.list.data];
                                             
                                             success(baseDomain.list.data);
                                         } else {
                                             faild(baseDomain.ResMsg.message);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask* task, NSError* error) {
                                         [self requestErrorCode:error faild:faild];
                                     }];
}

//精品文章 end


#pragma 签到记录 begin

//签到记录列表
- (void)getStudentSignRecordList:(NSInteger)pageNo  success:(void (^)(NSArray * recordArray))success faild:(void (^)(NSString * errorMsg))faild {
    
    NSDictionary * dic = @{@"pageNo":[NSString stringWithFormat:@"%ld",(long)pageNo]};
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getStudentSignRecordUrl]
                                  parameters:dic
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGListBaseDomain * baseDomain = [KGListBaseDomain objectWithKeyValues:responseObject];
                                         
                                         [self sessionTimeoutHandle:baseDomain];
                                         
                                         if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                                             
                                             NSArray * tempRecordArray = [StudentSignRecordDomain objectArrayWithKeyValuesArray:baseDomain.list.data];
                                             
                                             success(tempRecordArray);
                                         } else {
                                             faild(baseDomain.ResMsg.message);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask* task, NSError* error) {
                                         [self requestErrorCode:error faild:faild];
                                     }];
    
}

//签到记录 end


#pragma 食谱 begin

//食谱列表
- (void)getRecipesList:(NSString *)groupuuid beginDate:(NSString *)beginDate endDate:(NSString *)endDate success:(void (^)(NSArray * recipesArray))success faild:(void (^)(NSString * errorMsg))faild {
    
    NSDictionary * dic = @{@"begDateStr" : beginDate,
                           @"endDateStr" : endDate ? endDate : beginDate,
                           @"groupuuid"  : groupuuid};
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getRecipesListUrl]
                                  parameters:dic
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
                                         
                                         [self sessionTimeoutHandle:baseDomain];
                                         
                                         if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                                             
                                             NSArray * arrayResp = [responseObject objectForKey:@"list"];
                                             
                                             NSArray * tempRecipesArray = [RecipesDomain objectArrayWithKeyValuesArray:arrayResp];
                                             
                                             success(tempRecipesArray);
                                         } else {
                                             faild(baseDomain.ResMsg.message);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask* task, NSError* error) {
                                         [self requestErrorCode:error faild:faild];
                                     }];
}

//食谱 end



#pragma 通讯录 begin

//通讯录列表
- (void)getAddressBookList:(void (^)(AddressBookResp * addressBookResp))success faild:(void (^)(NSString * errorMsg))faild {
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getTeacherPhoneBookUrl]
                                  parameters:nil
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         AddressBookResp * baseDomain = [AddressBookResp objectWithKeyValues:responseObject];
                                         
                                         [self sessionTimeoutHandle:baseDomain];
                                         
                                         if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                                             
                                             success(baseDomain);
                                         } else {
                                             faild(baseDomain.ResMsg.message);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask* task, NSError* error) {
                                         [self requestErrorCode:error faild:faild];
                                     }];
}

//查询和老师或者园长的信息列表
- (void)getTeacherOrLeaderMsgList:(QueryChatsVO *)queryChatsVO success:(void (^)(NSArray * msgArray))success faild:(void (^)(NSString * errorMsg))faild {
    
    NSString * url = [KGHttpUrl getQueryLeaderUrl];
    if(queryChatsVO.isTeacher) {
        url = [KGHttpUrl getQueryByTeacherUrl];
    }
    
    [[AFAppDotNetAPIClient sharedClient] GET:url
                                  parameters:queryChatsVO.keyValues
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGListBaseDomain * baseDomain = [KGListBaseDomain objectWithKeyValues:responseObject];
                                         
                                         [self sessionTimeoutHandle:baseDomain];
                                         
                                         if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                                             NSArray * tempResp = [ChatInfoDomain objectArrayWithKeyValuesArray:baseDomain.list.data];
                                             
                                             success(tempResp);
                                         } else {
                                             faild(baseDomain.ResMsg.message);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask* task, NSError* error) {
                                         [self requestErrorCode:error faild:faild];
                                     }];
}

//给老师或者园长写信
- (void)saveAddressBookInfo:(WriteVO *)writeVO success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    NSString * url = [KGHttpUrl getSaveLeaderUrl];
    if(writeVO.isTeacher) {
        url = [KGHttpUrl getSaveTeacherUrl];
    }
    
    [self getServerJson:url params:writeVO.keyValues success:^(KGBaseDomain *baseDomain) {
        if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
            
            [self sessionTimeoutHandle:baseDomain];
            
            success(baseDomain.ResMsg.message);
        } else {
            faild(baseDomain.ResMsg.message);
        }
    } faild:^(NSString *errorMessage) {
        faild(errorMessage);
    }];
}

//通讯录 end



#pragma mark - 课程表 begin
//课程表列表
- (void)getTeachingPlanList:(NSString *)beginDate endDate:(NSString *)endDate cuid:(NSString *)classuuid success:(void (^)(NSArray * teachPlanArray))success faild:(void (^)(NSString * errorMsg))faild {
    
    NSDictionary * dic = @{@"begDateStr" : beginDate,
                           @"endDateStr" : endDate,
                           @"classuuid" : classuuid};
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getTeachingPlanUrl]
                                  parameters:dic
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
                                         
                                         [self sessionTimeoutHandle:baseDomain];
                                        
                                         if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                                             NSArray * tempResp = [TimetableDomain objectArrayWithKeyValuesArray:[responseObject objectForKey:@"list"]];
                                             
                                             success(tempResp);
                                         } else {
                                             faild(baseDomain.ResMsg.message);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask* task, NSError* error) {
                                         [self requestErrorCode:error faild:faild];
                                     }];
}
/**
 *  特长课程表 无请求参数
 *  @param success     success
 *  @param faild       faild
 */
- (void)getSPTeachingPlanList:(void (^)(NSArray * spTeachPlanArray))success faild:(void (^)(NSString * errorMsg))faild
{
    AFHTTPRequestOperationManager *req = [AFHTTPRequestOperationManager manager];
    
    [req GET:[KGHttpUrl getSpecialtyCoursesUrl] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
    {
        //获取到字典数据
        KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
        //控制超时
        [self sessionTimeoutHandle:baseDomain];
        
        if([baseDomain.ResMsg.status isEqualToString:String_Success])
        {
            //把list存进去
            NSArray * tempResp = [SPTimetableDomain objectArrayWithKeyValuesArray:[responseObject objectForKey:@"list"]];
            success(tempResp);
        }
        else
        {
            faild(baseDomain.ResMsg.message);
        }
    }
    failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
    {
        [self requestErrorCode:error faild:faild];
    }];
}
//课程表 end

#pragma 收藏 begin

//收藏列表
- (void)getFavoritesList:(NSInteger)pageNo success:(void (^)(NSArray * favoritesArray))success faild:(void (^)(NSString * errorMsg))faild
{
    NSDictionary * dic = @{@"pageNo" : [NSNumber numberWithInteger:pageNo]};
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getFavoritesListUrl]
                                  parameters:dic
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGListBaseDomain * baseDomain = [KGListBaseDomain objectWithKeyValues:responseObject];
                                         
                                         [self sessionTimeoutHandle:baseDomain];
                                         
                                         if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                                             NSArray * tempResp = [FavoritesDomain objectArrayWithKeyValuesArray:baseDomain.list.data];
                                             
                                             success(tempResp);
                                         } else {
                                             faild(baseDomain.ResMsg.message);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask* task, NSError* error) {
                                         [self requestErrorCode:error faild:faild];
                                     }];
}

//保存收藏
- (void)saveFavorites:(FavoritesDomain *)favoritesDomain success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    [self getServerJson:[KGHttpUrl getsaveFavoritesUrl] params:favoritesDomain.keyValues success:^(KGBaseDomain *baseDomain) {
        [self sessionTimeoutHandle:baseDomain];
        success(baseDomain.ResMsg.message);
    } faild:^(NSString *errorMessage) {
        faild(errorMessage);
    }];
}

//取消收藏
- (void)delFavorites:(NSString *)uuid success:(void(^)(NSString *msgStr))success failed:(void(^)(NSString *errorMsg))faild{
    NSDictionary * dic = @{@"reluuid":uuid};

    [[AFAppDotNetAPIClient sharedClient] POST:[KGHttpUrl getDelFavoritesUrl] parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
        
        [self sessionTimeoutHandle:baseDomain];
        success(baseDomain.ResMsg.message);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        faild(error.localizedDescription);
    }];
}

//收藏 end

#pragma mark - 修改密码
- (void)modifyPassword:(KGUser *)user success:(void(^)(NSString * msg))success faild:(void(^)(NSString * errorMsg))faild{
    
    NSDictionary * dic = @{@"oldpassword":user.oldpassowrd,@"password":user.password};
    
    [self getServerJson:[KGHttpUrl getModidyPWDUrl] params:dic success:^(KGBaseDomain *baseDomain) {
        if ([baseDomain.ResMsg.status isEqualToString:String_Success]) {
            success(baseDomain.ResMsg.message);
        }else{
            faild(baseDomain.ResMsg.message);
        }
        NSLog(@"s:%@",baseDomain.ResMsg.message);
    } faild:^(NSString *errorMessage) {
        NSLog(@"f:%@",errorMessage);
        faild(errorMessage);
    }];
    
}

#pragma mark - 特长课程

//特长课程首页 start
- (void)getSPCourseType:(void(^)(NSArray * spCourseTypeArr))success faild:(void(^)(NSString * errorMsg))faild
{
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getCourseTypeUrl]
                                  parameters:nil
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGListBaseDomain * baseDomain = [KGListBaseDomain objectWithKeyValues:responseObject];
                                         
                                         [self sessionTimeoutHandle:baseDomain];
                                         
                                         if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                                             NSArray * tempResp = [SPCourseTypeDomain objectArrayWithKeyValuesArray:[responseObject objectForKey:@"list"]];
                                             success(tempResp);
                                         } else {
                                             faild(baseDomain.ResMsg.message);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask* task, NSError* error) {
                                         [self requestErrorCode:error faild:faild];
                                     }];

}

- (void)getSPHotCourse:(NSString *)map_point pageNo:(NSString *)pageNo success:(void(^)(SPDataListVO * hotCourseList))success faild:(void(^)(NSString * errorMsg))faild
{
    NSDictionary *dic = @{@"map_point":map_point,@"pageNo":pageNo};
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getSpecialtyCoursesListURL] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             SPDataListVO * tempResp = [SPDataListVO objectWithKeyValues:[responseObject objectForKey:@"list"]];
             success(tempResp);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}

//特长课程首页 end


//特长课程列表 start

//班级列表
- (void)getSPCourseList:(NSString *)groupuuid map_point:(NSString *)map_point type:(NSString *)type sort:(NSString *)sort teacheruuid:(NSString *)teacheruuid pageNo:(NSString *)pageNo success:(void(^)(SPDataListVO * spCourseList))success faild:(void(^)(NSString * errorMsg))faild
{
    NSDictionary * dic = @{@"groupuuid":groupuuid,@"type":type,@"sort":sort,@"teacheruuid":teacheruuid,@"map_point":map_point,@"pageNo":pageNo};
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getSpecialtyCoursesListURL] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
 
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             SPDataListVO * tempResp = [SPDataListVO objectWithKeyValues:[responseObject objectForKey:@"list"]];
             success(tempResp);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
    
}

//学校列表
- (void)getSPSchoolList:(NSString *)mapPoint pageNo:(NSString *)pageNo sort:(NSString *)sort success:(void(^)(SPDataListVO * spSchoolList))success faild:(void(^)(NSString * errorMsg))faild
{
    NSDictionary * dic = @{@"sort":sort,@"pageNo":pageNo};
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getSpecialtySchoolListURL] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             SPDataListVO * tempResp = [SPDataListVO objectWithKeyValues:[responseObject objectForKey:@"list"]];
             success(tempResp);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
    
}

//特长课程列表 end

//特长课程 - 课程详情start
- (void)getSPCourseDetail:(NSString *)uuid success:(void(^)(SPCourseDetailVO * detailVO))success faild:(void(^)(NSString * errorMsg))faild
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getSpecialtyCourseDetailURL:uuid] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             SPCourseDetailVO * tempResp = [SPCourseDetailVO objectWithKeyValues:responseObject];
             
             success(tempResp);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
    
}

- (void)getSPCourseExtraFun:(NSString *)uuid success:(void(^)(SPShareSaveDomain * shareSaveDomain))success faild:(void(^)(NSString * errorMsg))faild
{
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getSpecialtyCourseDetailURL:uuid] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             SPShareSaveDomain * tempResp = [SPShareSaveDomain objectWithKeyValues:responseObject];
             
             success(tempResp);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}

- (void)getSPCourseDetailSchoolInfo:(NSString *)groupuuid success:(void (^)(SPSchoolDomain * spSchoolDetail))success faild:(void (^)(NSString * errorMsg))faild
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getSpecialtyCourseDetailSchoolInfoURL:groupuuid] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             SPSchoolDomain * tempResp = [SPSchoolDomain objectWithKeyValues:[responseObject objectForKey:@"data"]];
             
             success(tempResp);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}

- (void)getSPSchoolInfoShareUrl:(NSString *)groupuuid success:(void (^)(NSString * vo))success faild:(void (^)(NSString * errorMsg))faild
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getSchoolInfoShareUrl:groupuuid] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             SPCourseDetailVO * vo = [SPCourseDetailVO objectWithKeyValues:responseObject];
             
             success(vo.share_url);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}

- (void)getSPSchoolInfoTimeTableUrl:(NSString *)groupuuid success:(void (^)(NSString * vo))success faild:(void (^)(NSString * errorMsg))faild
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getSchoolInfoShareUrl:groupuuid] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             SPCourseDetailVO * vo = [SPCourseDetailVO objectWithKeyValues:responseObject];
             
             SPSchoolDomain * dd = [SPSchoolDomain objectWithKeyValues:vo.data];
             
             success(dd.img);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}

- (void)getSPSchoolExtraFun:(NSString *)uuid success:(void(^)(SPShareSaveDomain * shareSaveDomain))success faild:(void(^)(NSString * errorMsg))faild
{
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getSpecialtyCourseDetailSchoolInfoURL:uuid] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             SPShareSaveDomain * tempResp = [SPShareSaveDomain objectWithKeyValues:responseObject];
             
             success(tempResp);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}

//特长课程 - 课程详情end

//特长课程 - 课程评价start
- (void)getSPCourseComment:(NSString *)ext_uuid pageNo:(NSString *)pageNo success:(void (^)(SPCommentVO * commentVO))success faild:(void (^)(NSString * errorMsg))faild
{
    NSDictionary * dic = @{@"ext_uuid":ext_uuid,@"pageNo":pageNo};
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getSpecialtyCourseCommentURL] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             SPCommentVO * tempResp = [SPCommentVO objectWithKeyValues:[responseObject objectForKey:@"list"]];
             success(tempResp);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}
//特长课程 - 课程评价end

//特长课程 - 教师列表 start
- (void)getSPTeacherList:(NSString *)groupuuid pageNo:(NSString *)pageNo success:(void (^)(SPDataListVO * dataListVo))success faild:(void (^)(NSString * errorMsg))faild
{
    NSDictionary * dic = @{@"groupuuid":groupuuid,@"pageNo":pageNo};
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getSpecialtyTeacherListURL] parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             SPDataListVO * tempResp = [SPDataListVO objectWithKeyValues:[responseObject objectForKey:@"list"]];
             success(tempResp);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}

//特长课程 - 教师列表 end

//特长课程 - 老师详情 start
- (void)getSPTeacherDetail:(NSString *)uuid success:(void (^)(SPTeacherDetailDomain * teacherDomain))success faild:(void (^)(NSString * errorMsg))faild
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getSpecialtyTeacherDetailURL:uuid] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             SPTeacherDetailDomain * tempResp = [SPTeacherDetailDomain objectWithKeyValues:[responseObject objectForKey:@"data"]];
             
             success(tempResp);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}

//特长课程 - 老师详情 end

//优惠活动 - start
- (void)getYouHuiList:(NSString *)map_point pageNo:(NSInteger)pageNo success:(void (^)(YouHuiDataListVO * teacherDomain))success faild:(void (^)(NSString * errorMsg))faild
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getYouHuiListURL:map_point pageNo:pageNo] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             YouHuiDataListVO * tempResp = [YouHuiDataListVO objectWithKeyValues:[responseObject objectForKey:@"list"]];
             
             success(tempResp);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         NSLog(@"%@",error);
         [self requestErrorCode:error faild:faild];
     }];
}

//获取单个活动详情
- (void)getYouHuiInfo:(NSString *)uuid success:(void (^)(AnnouncementDomain * announcementObj))success faild:(void (^)(NSString * errorMsg))faild {

    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getYouHuiInfoListUrl:uuid]
                                  parameters:nil
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
                                         
                                         [self sessionTimeoutHandle:baseDomain];

                                         if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                                             
                                             AnnouncementDomain * announcement = [AnnouncementDomain objectWithKeyValues:baseDomain.data];
                                             announcement.share_url = [responseObject objectForKey:@"share_url"];
                                             announcement.isFavor = [[responseObject objectForKey:@"isFavor"] boolValue];
                                             announcement.count = [[responseObject objectForKey:@"count"] integerValue];
                                             announcement.link_tel = [responseObject objectForKey:@"link_tel"];
                                             
                                             success(announcement);
                                         } else {
                                             faild(baseDomain.ResMsg.message);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask* task, NSError* error) {
                                         NSLog(@"%@",error);
                                         [self requestErrorCode:error faild:faild];
                                     }];
}

//优惠活动 - end

//保存电话
- (void)saveTelUserDatas:(NSString *)ext_uuid type:(NSString *)type success:(void(^)(NSString * msg))success faild:(void(^)(NSString * errorMsg))faild
{
    NSDictionary * dict = @{@"type":type,@"ext_uuid":ext_uuid};
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [mgr POST:[KGHttpUrl saveTelUserDatasURL:ext_uuid type:type] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         NSLog(@"保存用户咨询记录成功%@",responseObject);
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
         NSLog(@"%@",error);
     }];
}

//我的特长课程 - 参加的班级列表 start
- (void)MySPCourseList:(NSString *)pageNo isdisable:(NSString *)isdisable success:(void(^)(SPDataListVO * msg))success faild:(void(^)(NSString * errorMsg))faild
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getMySPCourseListURL:pageNo isdisable:isdisable] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             SPDataListVO * tempResp = [SPDataListVO objectWithKeyValues:[responseObject objectForKey:@"list"]];
             
             success(tempResp);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         NSLog(@"%@",error);
         [self requestErrorCode:error faild:faild];
     }];
}
// end

//我的特长课程 - 获取评价
- (void)MySPCourseComment:(NSString *)classuuid pageNo:(NSString *)pageNo success:(void(^)(SPDataListVO * msg))success faild:(void(^)(NSString * errorMsg))faild
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getMySPCourseComments:classuuid pageNo:pageNo] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             SPDataListVO * tempResp = [SPDataListVO objectWithKeyValues:[responseObject objectForKey:@"list"]];
             
             success(tempResp);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         NSLog(@"%@",error);
         [self requestErrorCode:error faild:faild];
     }];
}

//end

//我的特长课程 - 根据课程id请求老师列表
- (void)MySPCourseTeacherList:(NSString *)classuuid success:(void(^)(NSArray * teacherArr))success faild:(void(^)(NSString * errorMsg))faild
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getMySPCourseTeacherList:classuuid] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             NSArray * tempResp = [MySPCourseTeacherList objectArrayWithKeyValuesArray:[responseObject objectForKey:@"list"]];
             
             success(tempResp);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         NSLog(@"%@",error);
         [self requestErrorCode:error faild:faild];
     }];
}
//end

//我的特长课程 - 保存评价
- (void)MySPCourseSaveComment:(NSString *)extuuid classuuid:(NSString *)classuuid type:(NSString *)type score:(NSString *)score content:(NSString *)content success:(void(^)(NSString * mgr))success faild:(void(^)(NSString * errorMsg))faild
{
    if (extuuid == nil) extuuid=@"";
    if (classuuid == nil) classuuid=@"";
    if (type == nil) type=@"";
    if (score == nil) score=@"";
    if (content == nil) content=@"";
    
    NSDictionary * dict = @{
                                @"ext_uuid":extuuid,
                                @"class_uuid":classuuid,
                                @"type":type,
                                @"score":score,
                                @"content":content
                            };
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [mgr POST:[KGHttpUrl getSaveMySPCommentURL] parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
        [self sessionTimeoutHandle:baseDomain];
        
        if([baseDomain.ResMsg.status isEqualToString:String_Success])
        {
            success(baseDomain.ResMsg.message);
        }
        else
        {
            faild(baseDomain.ResMsg.message);
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"%@",error);
        [self requestErrorCode:error faild:faild];
    }];
}
//end

//我的特长课程 - 全部课程安排
- (void)getListAll:(NSString *)classuuid pageNo:(NSString *)pageNo success:(void(^)(MySPAllCourseListVO * courseListVO))success faild:(void(^)(NSString * errorMsg))faild
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getMySPListAll:classuuid pageNo:pageNo] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];

         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             MySPAllCourseListVO * tempResp = [MySPAllCourseListVO objectWithKeyValues:[responseObject objectForKey:@"list"]];
             
             success(tempResp);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         NSLog(@"%@",error);
         [self requestErrorCode:error faild:faild];
     }];
}

#pragma mark - 招生模块

- (void)getAllSchoolList:(NSString *)groupuuid pageNo:(NSString *)pageNo mappoint:(NSString *)map_point sort:(NSString *)sort success:(void(^)(NSArray * listArr))success faild:(void(^)(NSString * errorMsg))faild
{
    
    NSDictionary * dict = @{@"groupuuid":groupuuid,@"pageNo":pageNo,@"map_point":map_point,@"sort":sort};
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getAllSchoolListUrl] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             MySPAllCourseListVO * tempResp = [MySPAllCourseListVO objectWithKeyValues:[responseObject objectForKey:@"list"]];
             
             NSArray * arr = [EnrolStudentsSchoolDomain objectArrayWithKeyValuesArray:tempResp.data];
             
             success(arr);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         NSLog(@"%@",error);
         [self requestErrorCode:error faild:faild];
     }];
}

- (void)getZhaoShengSchoolDetail:(NSString *)groupuuid mappoint:(NSString *)map_point success:(void(^)(EnrolStudentDataVO * vo))success faild:(void(^)(NSString * errorMsg))faild
{
    NSDictionary * dict = @{@"uuid":groupuuid,@"map_point":map_point};
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getZhaoShengSchoolDetailUrl] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             EnrolStudentDataVO * tempResp = [EnrolStudentDataVO objectWithKeyValues:responseObject];
             
             success(tempResp);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}

- (void)getMySchoolComment:(NSString *)groupuuid success:(void(^)(EnrolStudentDataVO * vo))success faild:(void(^)(NSString * errorMsg))faild
{
    NSDictionary * dict = @{@"groupuuid":groupuuid};
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getMySchoolCommentUrl] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             EnrolStudentDataVO * tempResp = [EnrolStudentDataVO objectWithKeyValues:[responseObject objectForKey:@"list"]];
             
             success(tempResp);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}

- (void)MySchoolSaveComment:(NSString *)extuuid classuuid:(NSString *)classuuid type:(NSString *)type score:(NSString *)score content:(NSString *)content anonymous:(NSString *)anonymous success:(void(^)(NSString * mgr))success faild:(void(^)(NSString * errorMsg))faild
{
    if (extuuid == nil) extuuid=@"";
    if (classuuid == nil) classuuid=@"";
    if (type == nil) type=@"";
    if (score == nil) score=@"";
    if (content == nil) content=@"";
    if (anonymous == nil) anonymous=@"";
    
    NSDictionary * dict = @{
                            @"ext_uuid":extuuid,
                            @"class_uuid":classuuid,
                            @"type":type,
                            @"score":score,
                            @"content":content,
                            @"anonymous":anonymous
                            };
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [mgr POST:[KGHttpUrl getSaveMySPCommentURL] parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             success(baseDomain.ResMsg.message);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}

#pragma mark - 发现模块
- (void)getMeiRiTuiJian:(void(^)(DiscorveryMeiRiTuiJianDomain * mgr))success faild:(void(^)(NSString * errorMsg))faild
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getMeiRiTuiJianUrl] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             DiscorveryMeiRiTuiJianDomain * tempResp = [DiscorveryMeiRiTuiJianDomain objectWithKeyValues:baseDomain.data];
             
             success(tempResp);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}

- (void)getReMenJingXuan:(NSString *)pageNo success:(void(^)(NSArray * remenjingxuanarr))success faild:(void(^)(NSString * errorMsg))faild
{
    NSDictionary * dict = @{@"pageNo":pageNo};
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getReMenJingXuanUrl] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             EnrolStudentDataVO * vo = [EnrolStudentDataVO objectWithKeyValues:[responseObject objectForKey:@"list"]];
             
             NSArray * tempResp = [DiscorveryReMenJingXuanDomain objectArrayWithKeyValuesArray:vo.data];
             
             success(tempResp);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}

- (void)getDiscorveryNewNumber:(void(^)(DiscorveryNewNumberDomain * newnum))success faild:(void(^)(NSString * errorMsg))faild
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getNewsNumberUrl] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             DiscorveryNewNumberDomain * tempResp = [DiscorveryNewNumberDomain objectWithKeyValues:baseDomain.data];
             
             success(tempResp);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}

//获取系统参数，是否能进入话题
- (void)getSysConfig:(NSString *)md5 success:(void(^)(SystemConfigOfTopic * sysDomain))success faild:(void(^)(NSString * errorMsg))faild
{
    if (md5 == nil || [md5 isEqualToString:@""])
    {
        md5 = @"";
    }
    
    NSDictionary * dict = @{@"md5":md5};
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getSysConfigOfTopic] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             SystemConfigOfTopic * tempResp = [[SystemConfigOfTopic alloc] init];
             
             tempResp.md5 = [responseObject objectForKey:@"md5"];
             tempResp.sns_url = [baseDomain.data objectForKey:@"sns_url"];
             
             NSLog(@"系统domain =  %@,%@",tempResp.md5,tempResp.sns_url);
             
             success(tempResp);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}

#pragma mark - 获取title 自动截取的
- (void)getTitle:(NSString *)url success:(void(^)(NSString * data))success faild:(void(^)(NSString * errorMsg))faild
{
    if (url == nil || [url isEqualToString:@""])
    {
        url = @"";
    }
    
    NSDictionary * dict = @{@"url":url};
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getTitleUrl] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
            success(baseDomain.data);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}

#pragma mark - 话题点击回调
- (void)meiRiJingXuanHuiDiao:(void(^)(NSString * data))success faild:(void(^)(NSString * errorMsg))faild
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl meiRiHuiDiaoUrl] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
    
}

#pragma mark - 家庭相册模块

//获取收藏页面
-(void)getCollegePhotoListWithPageNo:(NSInteger)pageNo success:(void(^)(FPCollegeListDomin *domin))success faild:(void(^)(NSString * errorMsg))faild{
    AFHTTPRequestOperationManager * mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary * dic = @{@"pageNo":[NSString stringWithFormat:@"%ld",(long)pageNo]};
      NSLog(@"%@",[KGHttpUrl getCollegePhotoUrl]);
    [mgr GET:[KGHttpUrl getCollegePhotoUrl] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        FPCollegeListDomin * model = [FPCollegeListDomin alloc];
        
        KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
        
        [self sessionTimeoutHandle:baseDomain];
        
        if([baseDomain.ResMsg.status isEqualToString:String_Success])
        {
            NSArray * arr = [FPCollegePhotoDetailDomin objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"list"]objectForKey:@"data"]];
            model.data = [NSArray arrayWithArray:arr];
            model = [FPCollegeListDomin objectWithKeyValues:[responseObject objectForKey:@"list"]];
            
            success(model);
            
        }
        
        else
        {
            faild(baseDomain.ResMsg.message);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestErrorCode:error faild:faild];
    }];
    
}
//获取我的家庭相册
- (void)getMyPhotoCollection:(void(^)(NSArray * datas))success faild:(void(^)(NSString * errorMsg))faild
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getMyFamilyPhotoUrl] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
//         NSLog(@"%@",responseObject);
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             
             NSArray *datas = [FPMyFamilyPhotoCollectionDomain objectArrayWithKeyValuesArray:[responseObject objectForKey:@"list"]];
              success(datas);
//             FPMyFamilyPhotoCollectionDomain * domain = datas[0];
//             
//             success(domain);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}
//获取家庭相册列表
-(void)getMyFamilyPhoto:(void(^)(FPMyFamilyPhotoListColletion * domain))success faild:(void(^)(NSString * errorMsg))faild
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr GET:[KGHttpUrl getMyFamilyPhotoUrl] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
        [self sessionTimeoutHandle:baseDomain];
        
        //         NSLog(@"%@",responseObject);
        
        if([baseDomain.ResMsg.status isEqualToString:String_Success])
        {
        NSLog(@"%@", responseObject);
        FPMyFamilyPhotoListColletion * model = [FPMyFamilyPhotoListColletion new];
        
        NSArray * arr = [FPMyFamilyPhotoCollectionDomain objectArrayWithKeyValuesArray:[responseObject objectForKey:@"list"]];
        model.list = [arr copy];
            success(model);
        }else
        {
            faild(baseDomain.ResMsg.message);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestErrorCode:error faild:faild];
    }];
}


//查指定家庭的相片 type:0 是minTime , 1是maxTime;
- (void)getPhotoCollectionUseFamilyUUID:(NSString *)familyUUID withTime:(NSString *)time timeType:(NSInteger)type pageNo:(NSString *)pageNo success:(void(^)(FPFamilyPhotoLastTimeVO * lastTimeVO))success faild:(void(^)(NSString * errorMsg))faild
{
    if (familyUUID == nil)
    {
        return;
    }
    
    NSDictionary * dict;
    
    if (type == 0)
    {
        dict = @{@"family_uuid":familyUUID,@"minTime":time,@"pageNo":pageNo};
        
    }else if(type == 1)
    {
        dict = @{@"family_uuid":familyUUID,@"maxTime":time,@"pageNo":pageNo};
    }
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getFamilyPhotoUseFamilyUUIDAndTimeUrl] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             FPFamilyPhotoLastTimeVO * tempResp = [FPFamilyPhotoLastTimeVO objectWithKeyValues:[responseObject objectForKey:@"list"]];
             tempResp.lastTime = [responseObject objectForKey:@"lastTime"];
             
             success(tempResp);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}

//查询根据时间范围查询，新数据总数和变化数据总数
- (void)getFPPhotoUpdateCountWithFamilyUUID:(NSString *)familyUUID maxTime:(NSString *)maxTime success:(void(^)(FPFamilyPhotoUpdateCount * domain))success faild:(void(^)(NSString * errorMsg))faild
{
    if (familyUUID == nil)
    {
        familyUUID = @"";
    }
    
    NSDictionary * dict = @{@"family_uuid":familyUUID,@"maxTime":maxTime};
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getFamilyPhotoUpdateCountUrl] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             FPFamilyPhotoUpdateCount * tempResp = [FPFamilyPhotoUpdateCount objectWithKeyValues:responseObject];
             success(tempResp);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}

// 查询增量更新数据（缓存本地）
- (void)getFPPhotoUpdateDataWithFamilyUUID:(NSString *)familyUUID maxTime:(NSString *)maxTime minTime:(NSString *)minTime updateTime:(NSString *)updateTime success:(void(^)(NSArray * needUpDateDatas))success faild:(void(^)(NSString * errorMsg))faild
{
    if (familyUUID == nil)
    {
        familyUUID = @"";
    }
    
    NSDictionary * dict = @{@"family_uuid":familyUUID,@"maxTime":maxTime,@"updateTime":updateTime};
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getFamilyPhotoUpdateDataUrl] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             //借用一下
             FPFamilyPhotoLastTimeVO * tempResp = [FPFamilyPhotoLastTimeVO objectWithKeyValues:[responseObject objectForKey:@"list"]];
             
             success([FPFamilyPhotoStatusDomain objectArrayWithKeyValuesArray:tempResp.data]);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}

#pragma mark - 上传图片 
- (void)uploadFPPhotoUpdateDataWithFamilyUUID:(NSString *)familyUUID img:(UIImage *)img success:(void(^)(NSString * str))success faild:(void(^)(NSString * errorMsg))faild
{
    
}

#pragma mark - 修改照片属性
- (void)modifyFPItemInfo:(NSString *)address note:(NSString *)note success:(void(^)(NSString * mgr))success faild:(void(^)(NSString * errorMsg))faild
{
    if (address == nil) address=@"";
    if (note == nil) note=@"";
    
    NSDictionary * dict = @{
                            @"address":address,
                            @"note":note,
                            };
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [mgr POST:[KGHttpUrl modifyFPItemUrl] parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             success(baseDomain.ResMsg.message);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}

#pragma mark - 获取一张照片信息的额外信息
- (void)getFPItemExtraInfo:(NSString *)uuid success:(void(^)(FPTimeLineDZDomain * needUpDateDatas))success faild:(void(^)(NSString * errorMsg))faild
{
    if (uuid == nil)
    {
        uuid = @"";
    }
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getFPItemExtraInfoUrl:uuid] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
//         NSLog(@"%@,%@",uuid,responseObject);
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             FPTimeLineDZDomain * domain = [[FPTimeLineDZDomain alloc] init];
             domain.isFavor = [[responseObject valueForKey:@"isFavor"] integerValue];
             domain.dianzan_count = [[[responseObject valueForKey:@"dianZan"] objectForKey:@"dianzan_count"] integerValue];
             domain.yidianzan = [[[responseObject valueForKey:@"dianZan"] objectForKey:@"yidianzan"] integerValue];
             success(domain);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}

#pragma mark - 发送时光轴相片评论
- (void)saveFPItem :(NSString *)content rel_uuid:(NSString *)rel_uuid success:(void(^)(NSString * mgr))success faild:(void(^)(NSString * errorMsg))faild
{
    if (content == nil) content=@"";
    if (rel_uuid == nil) rel_uuid=@"";
    
    NSDictionary * dict = @{
                            @"content":content,
                            @"rel_uuid":rel_uuid,
                            @"type":@"21"
                            };
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [mgr POST:[KGHttpUrl saveFPItemCommentUrl] parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             success(baseDomain.ResMsg.message);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}

#pragma mark - 删除时光轴相册接口
- (void)deleteFPTimeLineItem:(NSString *)uuid success:(void(^)(NSString * mgr))success faild:(void(^)(NSString * errorMsg))faild
{
    if (uuid == nil) uuid=@"";
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [mgr POST:[KGHttpUrl deleteFPTimeLineItem:uuid] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         NSLog(@"%@",responseObject);
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             success(baseDomain.ResMsg.message);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}

#pragma mark - 请求时光轴相片评论列表 '2016-01-20-10-11-22','%Y-%m-%d-%H-%i-%s'
- (void)getFPItemCommentList:(NSString *)uuid pageNo:(NSString *)pageNo time:(NSString *)time success:(void(^)(NSArray * arr))success faild:(void(^)(NSString * errorMsg))faild
{
    if (uuid == nil)
    {
        uuid = @"";
    }
    NSDictionary * dict = @{@"rel_uuid":uuid,@"pageNo":pageNo,@"type":@"21",@"maxTime":time};
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getTimeLineItemCommentListUrl] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             MySPAllCourseListVO * vo = [MySPAllCourseListVO objectWithKeyValues:[responseObject objectForKey:@"list"]];
             
             NSArray * arr = [FPTimeLineCommentDomain objectArrayWithKeyValuesArray:vo.data];
             
             success(arr);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}

#pragma mark - 获取一张照片信息
- (void)getFPTimeLineItem:(NSString *)uuid success:(void(^)(FPFamilyPhotoNormalDomain * item))success faild:(void(^)(NSString * errorMsg))faild
{
    if (uuid == nil)
    {
        uuid = @"";
    }
    NSDictionary * dict = @{@"uuid":uuid};
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[KGHttpUrl getTimeLineItemUrl] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             FPFamilyPhotoNormalDomain * domain = [FPFamilyPhotoNormalDomain objectWithKeyValues:[responseObject objectForKey:@"data"]];
             
             success(domain);
         }
         else
         {
             faild(baseDomain.ResMsg.message);
         }
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error)
     {
         [self requestErrorCode:error faild:faild];
     }];
}

#pragma mark - 点赞
//保存点赞
- (void)saveFPDZ:(NSString *)newsuid type:(KGTopicType)dzype success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild
{
    if (newsuid == nil)
    {
        newsuid = @"";
    }
    NSDictionary * dict = @{@"rel_uuid":newsuid,@"type":@"21"};
    
    NSLog(@"%@",dict);
    
    [self getServerJson:[KGHttpUrl getFPSaveDZUrl:newsuid] params:dict success:^(KGBaseDomain *baseDomain)
    {
        [self sessionTimeoutHandle:baseDomain];
        success(baseDomain.ResMsg.message);
        
    } faild:^(NSString *errorMessage)
    {
        faild(errorMessage);
    }];
}

//取消点赞
- (void)delFPDZ:(NSString *)newsuid success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild
{
    [self getServerJson:[KGHttpUrl getFPDelDZUrl:newsuid] params:nil success:^(KGBaseDomain *baseDomain)
    {
        [self sessionTimeoutHandle:baseDomain];
        success(baseDomain.ResMsg.message);
        
    } faild:^(NSString *errorMessage)
    {
        faild(errorMessage);
    }];
}


@end
