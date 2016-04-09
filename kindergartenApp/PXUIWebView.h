//
//  PXUIWebView.h
//  kindergartenApp
//
//  Created by WenJieKeJi on 16/4/9.
//  Copyright © 2016年 funi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

#import "ShareDomain.h"
#import "HLActionSheet.h"
#import "ZYQAssetPickerController.h"
#import "UMSocial.h"
#import "ShareDomain.h"
#import "HLActionSheet.h"

#import "LBXScanView.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "KGHUD.h"
#import "MJRefresh.h"
#import "KGHttpService.h"
#import "MJExtension.h"

@protocol PXUIWebViewDelegate <NSObject>
@optional
- (void)fullScreen;
- (void)exitFullScreen;
- (void)makeFPMovie;
@end

@protocol PXJSExport <JSExport>


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

JSExportAs
(fullScreen  /** handleFactorialCalculateWithNumber 作为js方法的别名 */,
 - (void)fullScreen:(NSString *)t
 );

JSExportAs
(exitFullScreen  /** handleFactorialCalculateWithNumber 作为js方法的别名 */,
 - (void)exitFullScreen:(NSString *)t
 );

JSExportAs
(makeFPMovie  /** handleFactorialCalculateWithNumber 作为js方法的别名 */,
 - (void)makeFPMovie:(NSString *)t
 );

@end
@interface PXUIWebView : UIWebView

@property (strong, nonatomic) UIViewController * parentController;

- (void)initViewByController:(UIViewController *)parentController;

@property id<PXUIWebViewDelegate> delegate1;

@end
