//
//  LandscapeSupportedMPMoviePlayerController.m
//  Topik
//
//  Created by Lee Haining on 13-11-27.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "LandscapeSupportedMPMoviePlayerController.h"

@implementation LandscapeSupportedMPMoviePlayerController
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    NSLog(@"orientation called");
    return UIInterfaceOrientationMaskPortrait;
}
@end
