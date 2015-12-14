//
//  DiscorveryWebVC.h
//  kindergartenApp
//
//  Created by Mac on 15/12/14.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "BaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol TestJSExport <JSExport>
JSExportAs
(setShareContent  /** handleFactorialCalculateWithNumber 作为js方法的别名 */,
 - (void)setShareContent:(NSString *)title content:(NSString *)content pathurl:(NSString *)pathurl httpurl:(NSString *)httpurl
 );


@end

@interface DiscorveryWebVC : BaseViewController

- (void)loadWithCookieSettingsUrl:(NSString *)url cookieDomain:(NSString *)cookieDomain path:(NSString *)cookiePath;

- (NSString *)cutUrlDomain:(NSString *)url;

@property (assign, nonatomic) CGRect webViewFrame;

@end
