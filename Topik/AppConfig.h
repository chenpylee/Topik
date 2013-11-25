//
//  AppConfig.h
//  Topik
//
//  Created by Lee Haining on 13-11-23.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
@interface AppConfig : NSObject
+(UIColor*)getTabBarTintColor;
+(NSString*)getFullDataUrl;
@end
