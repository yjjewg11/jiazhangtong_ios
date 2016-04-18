//
//  KGAccountService.h
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/17.
//  Copyright © 2016年 funi. All rights reserved.
//

#import "KGHttpService.h"
#import "TaobaoIMAccountDomain.h"
#import "SPKitExample.h"
@interface KGAccountService : KGHttpService
+ (KGAccountService *)sharedService;

+ (void)login;
+ (void)logout;
-(void)im_getMyLoginUser :(void (^)(TaobaoIMAccountDomain * success))success faild:(void (^)(NSString * errorMessage))faild;
@end
