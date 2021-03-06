//
//  AppDelegate.h
//  Topik
//
//  Created by Lee Haining on 13-11-23.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "TopikIAPHelper.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Reachability *internetReach;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,assign)BOOL needLanspace;
@property(nonatomic,assign) BOOL isDebugMode;
@property(nonatomic,strong)SKProduct *product;
@end
