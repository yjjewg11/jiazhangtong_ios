//
//  FuniHttpService.m
//  kindergartenApp
//
//  Created by You on 15/6/1.
//  Copyright (c) 2015年 funi. All rights reserved.
//

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


//获取学生信息
- (KGUser *)getUserByUUID:(NSString *)uuid {
    for(KGUser * user in _loginRespDomain.list) {
        if([uuid isEqualToString:user.uuid]) {
            return user;
        }
    }
    return nil;
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
                    faild(baseDomainResp.ResMsg.message);
                }
            });
        }
    });
}



- (void)POST:(NSString *)url param:(NSDictionary *)param success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    AFAppDotNetAPIClient * client = [AFAppDotNetAPIClient sharedClient];
    
    
    [client POST:url parameters:param success:^(NSURLSessionDataTask* task, id responseObject) {
    
        _loginRespDomain = [LoginRespDomain objectWithKeyValues:responseObject];
        if([_loginRespDomain.ResMsg.status isEqualToString:String_Success]) {
            success(_loginRespDomain.ResMsg.message);
        } else {
            faild(_loginRespDomain.ResMsg.message);
        }
        
    } failure:^(NSURLSessionDataTask* task, NSError* error) {
         [self requestErrorCode:error faild:faild];
    }];
}


//图片上传
- (void)uploadImg:(UIImage *)img withName:(NSString *)imgName type:(NSInteger)imgType success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    NSData * imageData = UIImageJPEGRepresentation(img, 1.0);
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:imgName forKey:@"file"];
    [parameters setObject:[NSNumber numberWithInteger:imgType] forKey:@"type"];
    [parameters setObject:_loginRespDomain.JSESSIONID forKey:@"JSESSIONID"];
    
    [[AFAppDotNetAPIClient sharedClient] POST:[KGHttpUrl getUploadImgUrl] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
//        [formData appendPartWithFileData:imageData name:imgName fileName:imgName mimeType:@"multipart/form-data"];
        
        [formData appendPartWithFileData:imageData name:imgName fileName:imgName mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
        NSLog(@"respon:%@", responseObject);
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
- (void)submitPushToken:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    NSDictionary * dic = @{@"device_id" : _pushToken,
                           @"device_type": @"ios"};
    
    [self getServerJson:[KGHttpUrl getPushTokenUrl] params:dic success:^(KGBaseDomain *baseDomain) {
        
    } faild:^(NSString *errorMessage) {
        
    }];
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
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getGroupUrl]
                                  parameters:nil
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
                                         
                                         if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                                             
                                             NSArray * groupArrayResp = [GroupDomain objectArrayWithKeyValuesArray:(NSDictionary *)responseObject[@"list"]];
                                             
                                             _groupArray = groupArrayResp;
                                             
                                             if(groupArrayResp && [groupArrayResp count]>Number_Zero) {
                                                 _groupDomain = [groupArrayResp objectAtIndex:Number_Zero];
                                             }
                                             
                                             success(groupArrayResp);
                                         } else {
                                             faild(baseDomain.ResMsg.message);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask* task, NSError* error) {
                                         [self requestErrorCode:error faild:faild];
                                     }];
}


#pragma mark 账号相关 begin

- (void)login:(KGUser *)user success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    [[AFAppDotNetAPIClient sharedClient] POST:[KGHttpUrl getLoginUrl]
                                   parameters:user.keyValues
                                      success:^(NSURLSessionDataTask* task, id responseObject) {
                                          
                                          _loginRespDomain = [LoginRespDomain objectWithKeyValues:responseObject];
                                          if([_loginRespDomain.ResMsg.status isEqualToString:String_Success]) {
                                              
                                              //取到服务器返回的cookies
                                              NSString * cookies = ((NSHTTPURLResponse *)task.response).allHeaderFields[@"Set-Cookie"];
                                              NSLog(@"response cookies:%@",cookies);
//                                              [self userCookie:cookies];
                                              
                                              
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
    
    [self POST:[KGHttpUrl getLogoutUrl] param:nil success:^(NSString *msgStr) {
        success(msgStr);
    } faild:^(NSString *errorMsg) {
        faild(errorMsg);
    }];
}


- (void)reg:(KGUser *)user success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    [self getServerJson:[KGHttpUrl getRegUrl] params:user.keyValues success:^(KGBaseDomain * baseDomain) {
       
        success(baseDomain.ResMsg.message);
        NSLog(@"message:%@", baseDomain.ResMsg.message);
    } faild:^(NSString *errorMessage) {
        faild(errorMessage);
    }];
}



- (void)updatePwd:(KGUser *)user success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    [self getServerJson:[KGHttpUrl getUpdatepasswordUrl] params:user.keyValues success:^(KGBaseDomain * baseDomain) {
        success(baseDomain.ResMsg.message);
    } faild:^(NSString *errorMsg) {
        faild(errorMsg);
    }];
}


- (void)getPhoneVlCode:(NSString *)phone success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    NSDictionary * dic = @{@"tel" : phone};
    [self getServerJson:[KGHttpUrl getPhoneCodeUrl] params:dic success:^(KGBaseDomain *baseDomain) {
        success(baseDomain.ResMsg.message);
    } faild:^(NSString *errorMessage) {
        faild(errorMessage);
    }];

}

// 账号相关 end

#pragma mark  互动相关


// 根据互动id获取互动详情
- (void)getClassNewsByUUID:(NSString *)uuid success:(void (^)(TopicDomain * classNewInfo))success faild:(void (^)(NSString * errorMsg))faild {
    
}


// 分页获取班级互动列表
- (void)getClassNews:(PageInfoDomain *)pageObj success:(void (^)(PageInfoDomain * pageInfo))success faild:(void (^)(NSString * errorMsg))faild {
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getClassNewsMyByClassIdUrl]
                                   parameters:pageObj.keyValues
                                      success:^(NSURLSessionDataTask* task, id responseObject) {
                                          
                                          [KGListBaseDomain setupObjectClassInArray:^NSDictionary* {
                                              return @{ @"list.data" : @"ClassNewsDomain" };
                                          }];
                                          
                                          KGListBaseDomain * baseDomain = [KGListBaseDomain objectWithKeyValues:responseObject];
                                          
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



#pragma mark 学生相关 begin

- (void)saveStudentInfo:(KGUser *)user success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    [self getServerJson:[KGHttpUrl getSaveChildrenUrl] params:user.keyValues success:^(KGBaseDomain *baseDomain) {
        success(baseDomain.ResMsg.message);
    } faild:^(NSString *errorMessage) {
        faild(errorMessage);
    }];
}


//学生相关 end


#pragma mark 点赞相关 begin

//保存点赞
- (void)saveDZ:(NSString *)newsuid type:(KGTopicType)dzype success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    NSDictionary * dic = @{@"type":[NSNumber numberWithInteger:dzype], @"newsuuid":newsuid};
    
    [self getServerJson:[KGHttpUrl getSaveDZUrl] params:dic success:^(KGBaseDomain *baseDomain) {
        success(baseDomain.ResMsg.message);
    } faild:^(NSString *errorMessage) {
        faild(errorMessage);
    }];
}

//取消点赞
- (void)delDZ:(NSString *)newsuid success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    NSDictionary * dic = @{@"newsuuid":newsuid};
    
    [self getServerJson:[KGHttpUrl getDelDZUrl] params:dic success:^(KGBaseDomain *baseDomain) {
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
        success(baseDomain.ResMsg.message);
    } faild:^(NSString *errorMessage) {
        faild(errorMessage);
    }];
}

//取消回复
- (void)delReply:(NSString *)uuid success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    NSDictionary * dic = @{@"uuid":uuid};
    
    [self getServerJson:[KGHttpUrl getDelReplyUrl] params:dic success:^(KGBaseDomain *baseDomain) {
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
                                         
                                         [KGListBaseDomain setupObjectClassInArray:^NSDictionary* {
                                             return @{ @"list.data" : @"TopicDomain" };
                                         }];
                                         
                                         KGListBaseDomain * baseDomain = [KGListBaseDomain objectWithKeyValues:responseObject];
                                         
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

//回复相关 end



#pragma 公告相关 begin

//获取单个公告详情
- (void)getAnnouncementInfo:(NSString *)uuid success:(void (^)(AnnouncementDomain * announcementObj))success faild:(void (^)(NSString * errorMsg))faild {
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getAnnouncementInfoUrl:uuid]
                                  parameters:nil
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
                                         
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
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getAnnouncementListUrl]
                                  parameters:pageInfo.keyValues
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGListBaseDomain * baseDomain = [KGListBaseDomain objectWithKeyValues:responseObject];
                                         
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


#pragma 评价老师 begin

//获取评价老师列表
- (void)getTeacherList:(void (^)(NSArray * teacherArray))success faild:(void (^)(NSString * errorMsg))faild {
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getTeacherListUrl]
                                  parameters:nil
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
                                         
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

//分页获取文章列表
- (void)getArticlesList:(PageInfoDomain *)pageInfo success:(void (^)(NSArray * articlesArray))success faild:(void (^)(NSString * errorMsg))faild {
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getArticleListUrl]
                                  parameters:pageInfo.keyValues
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGListBaseDomain * baseDomain = [KGListBaseDomain objectWithKeyValues:responseObject];
                                         
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
- (void)getStudentSignRecordList:(void (^)(NSArray * recordArray))success faild:(void (^)(NSString * errorMsg))faild {
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getStudentSignRecordUrl]
                                  parameters:nil
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGListBaseDomain * baseDomain = [KGListBaseDomain objectWithKeyValues:responseObject];
                                         
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
- (void)getRecipesList:(NSString *)beginDate endDate:(NSString *)endDate success:(void (^)(NSArray * recipesArray))success faild:(void (^)(NSString * errorMsg))faild {
    
    NSDictionary * dic = @{@"begDateStr" : beginDate,
                           @"endDateStr" : endDate ? endDate : beginDate,
                           @"groupuuid"  : _groupDomain.uuid};
    
//    NSDictionary * dic = @{@"begDateStr" : @"2015-07-01",
//                           @"endDateStr" : @"2015-08-01",
//                           @"groupuuid"  : _groupDomain.uuid};
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getRecipesListUrl]
                                  parameters:dic
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
                                         
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
    
    NSString * url = [KGHttpUrl getSaveLeaderUrl];
    if(queryChatsVO.isTeacher) {
        url = [KGHttpUrl getSaveTeacherUrl];
    }
    
    [[AFAppDotNetAPIClient sharedClient] GET:url
                                  parameters:queryChatsVO.keyValues
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGListBaseDomain * baseDomain = [KGListBaseDomain objectWithKeyValues:responseObject];
                                         
                                         if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                                             NSArray * tempResp = [ChatInfoDomain objectArrayWithKeyValuesArray:baseDomain.data];
                                             
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
            
            success(baseDomain.ResMsg.message);
        } else {
            faild(baseDomain.ResMsg.message);
        }
    } faild:^(NSString *errorMessage) {
        faild(errorMessage);
    }];
}

//通讯录 end



#pragma 课程表 begin

//课程表列表
- (void)getTeachingPlanList:(NSString *)beginDate endDate:(NSString *)endDate success:(void (^)(NSArray * teachPlanArray))success faild:(void (^)(NSString * errorMsg))faild {
    
    NSString * classuuid = @"";
    
    for(KGUser * user in _loginRespDomain.list) {
        classuuid = user.classuuid;
        break;
    }
    
    NSDictionary * dic = @{@"begDateStr" : beginDate,
                           @"endDateStr" : endDate ? endDate : beginDate,
                           @"classuuid" : classuuid};
    
    [[AFAppDotNetAPIClient sharedClient] GET:[KGHttpUrl getTeachingPlanUrl]
                                  parameters:dic
                                     success:^(NSURLSessionDataTask* task, id responseObject) {
                                         
                                         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
                                         
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

//课程表 end


@end
