//
//  AppConfig.h
//  Topik
//
//  Created by Lee Haining on 13-11-23.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAI.h"
#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
#define APP_NOTIFICATION_TOTAL_DATA_LOADED @"app_notification_total_data_loaded"
#define kAppIsInDebugMode @"IS_DEBUG_MODE"
#define kBackgroundDownloadSetting @"BACKGROUND_DOWNLOAD_KEY"
#define kStoreProductTitle @"IN_APP_PRODUCT_TITLE"
#define kStoreProductDescription @"IN_APP_PRODUCT_DESCRIPTION"
#define kStoreProductPrice @"IN_APP_PRODUCT_PRICE"
#define kStoreProductLocale @"IN_APP_PRODUCT_PRICE_LOCALE"
#define kStoreProductIdentifier @"next.total.0"
#define KStoreProductInforNotificationIdentifier @"PRODUCT_INFOR_ARRIVED"
#define kStoreProductObject @"IN_APP_PRODUCT_OBJECT"
#define kStoreProductPurchasedNotification @"IN_APP_PURCHASED_NOTIFICATION"
#define kStoreProductCompleteTransactionNotification @"completeTransaction"
#define kStoreProductRestoreTransactionNotification @"restoreTransaction"
#define kStoreProductFailTransactionNotification @"failTransaction"
#define kStoreProductFailErrorKey @"failTransactionError"
@interface AppConfig : NSObject
+(UIColor*)getTabBarTintColor;
+(UIColor*)getLevelColor1;
+(UIColor*)getLevelColor2;
+(UIColor*)getLevelColor3;
+(UIColor*)getLevelColor4;
+(NSString*)getFullDataUrl;
+(BOOL)isPaidVersion;
+(NSString*)getCurrentDateTime;
+(BOOL)isInDebugMode;
+(BOOL)isBackgroundDownloadOn;
@end
