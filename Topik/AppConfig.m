//
//  AppConfig.m
//  Topik
//
//  Created by Lee Haining on 13-11-23.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "AppConfig.h"

@implementation AppConfig
+(UIColor*)getTabBarTintColor{
    UIColor* tintColor=nil;
    NSString *colorHex=(NSString*)[[AppConfig sharedSettings] objectForKey:@"tabBarTintColor"];
    NSLog(@"tabBarTintColor from Plist:%@",colorHex);
    tintColor=[AppConfig getUIColorObjectFromHexString:colorHex alpha:1.0];
    return tintColor;
}
+(NSString*)getFullDataUrl{
    NSString *url=(NSString*)[[AppConfig sharedSettings] objectForKey:@"fullDataUrl"];
    NSLog(@"AppConfig getFullDataUrl:%@",url);
    return url;
}
+(NSDictionary*)sharedSettings{
    static NSDictionary *_settings;
    static dispatch_once_t once_mark;
    dispatch_once(&once_mark,^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
        _settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    });

    return _settings;
}
+(UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
    // Convert hex string to an integer
    unsigned int hexint = [AppConfig intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}
+ (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}
@end
