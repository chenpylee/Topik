//
//  AppConfig.h
//  Topik
//
//  Created by Lee Haining on 13-11-23.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
#define APP_NOTIFICATION_TOTAL_DATA_LOADED @"app_notification_total_data_loaded"
@interface AppConfig : NSObject
+(UIColor*)getTabBarTintColor;
+(UIColor*)getLevelColor1;
+(UIColor*)getLevelColor2;
+(UIColor*)getLevelColor3;
+(UIColor*)getLevelColor4;
+(NSString*)getFullDataUrl;
+(BOOL)isPaidVersion;
@end
