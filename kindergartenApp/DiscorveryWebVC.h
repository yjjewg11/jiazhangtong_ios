//
//  DiscorveryWebVC.h
//  kindergartenApp
//
//  Created by Mac on 15/12/14.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "BaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@class DiscorveryWebVC;
@protocol DiscorveryWebVCDelegate <NSObject>

@required
- (void)hideWebVC:(DiscorveryWebVC *)webVC;

@end

@protocol TestJSExport <JSExport>
JSExportAs
(setShareContent  /** handleFactorialCalculateWithNumber 作为js方法的别名 */,
 - (void)setShareContent:(NSString *)title content:(NSString *)content pathurl:(NSString *)pathurl httpurl:(NSString *)httpurl
 );

JSExportAs
(selectImgPic  /** handleFactorialCalculateWithNumber 作为js方法的别名 */,
 - (void)selectImgPic:(NSString *)groupuuid
 );

JSExportAs
(finishProject  /** handleFactorialCalculateWithNumber 作为js方法的别名 */,
 - (void)finishProject:(NSString *)url
 );

JSExportAs
(jsessionToPhone  /** handleFactorialCalculateWithNumber 作为js方法的别名 */,
 - (void)jsessionToPhone:(NSString *)id
 );

JSExportAs
(getJsessionid  /** handleFactorialCalculateWithNumber 作为js方法的别名 */,
 - (NSString *)getJsessionid:(NSString *)id
 );

@end

@interface DiscorveryWebVC : BaseViewController

- (void)loadWithCookieSettingsUrl:(NSString *)url cookieDomain:(NSString *)cookieDomain path:(NSString *)cookiePath;

- (NSString *)cutUrlDomain:(NSString *)url;

@property (assign, nonatomic) CGRect webViewFrame;

@property (weak, nonatomic) id<DiscorveryWebVCDelegate> delegate;

@end
