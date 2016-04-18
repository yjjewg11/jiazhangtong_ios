//
//  KGAccountService.m
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/17.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "KGAccountService.h"

@implementation KGAccountService

+ (KGAccountService *)sharedService {
    static KGAccountService *_sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedService = [[KGAccountService alloc] init];
    });
    
    return _sharedService;
}
+ (void)logout
{
    [[SPKitExample sharedInstance] exampleLogout];
}
+ (void)login
{
    
    [[KGAccountService sharedService] im_getMyLoginUser:^(TaobaoIMAccountDomain *success) {
        SPKitExample *sPKitExample=[SPKitExample sharedInstance];
        sPKitExample.userinfo=[KGHttpService sharedService].userinfo;
        [sPKitExample callThisAfterISVAccountLoginSuccessWithYWLoginId:success.userid passWord:success.password preloginedBlock:^{
            
        } successBlock:^{
            NSLog(@"KGAccountService.login.success=%@",success.userid);
            
        } failedBlock:^(NSError * aError) {
            NSLog(@"KGAccountService.login.aError=%@",aError.description);
        }];
        
        
    } faild:^(NSString *errorMessage) {
        NSLog(@"KGAccountService.login.error=%@",errorMessage);
    }];
  
    
}

-(void)im_getMyLoginUser :(void (^)(TaobaoIMAccountDomain * success))success faild:(void (^)(NSString * errorMessage))faild
{
    
     NSString * url=[NSString stringWithFormat:@"%@%@", [KGHttpUrl getBaseServiceURL], @"rest/im/getMyLoginUser.json"];
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    
    [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         
         
         NSDictionary *responseObjectDic=responseObject;
         NSData * jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
         NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                      encoding:NSUTF8StringEncoding];
         NSLog(@"responseObject= %@",jsonString);
         
         KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues: responseObject];
         [self sessionTimeoutHandle:baseDomain];
         
         //         NSLog(@"%@",responseObject);
         
         if([baseDomain.ResMsg.status isEqualToString:String_Success])
         {
             
             NSArray * userinfos= [TaobaoIMAccountDomain objectArrayWithKeyValuesArray:((NSDictionary *)responseObject)[@"userinfos"]];
             TaobaoIMAccountDomain * account=nil;
             if(userinfos.count>0){
                 account=userinfos[0];
             }
             
             success(account);
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

@end
