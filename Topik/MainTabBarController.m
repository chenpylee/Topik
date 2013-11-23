//
//  MainTabBarController.m
//  Topik
//
//  Created by Lee Haining on 13-11-23.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	UIColor *tabBarTintColor=[AppConfig getTabBarTintColor];
    //[[UITabBar appearance] setTintColor:tabBarTintColor];
    [self.tabBar setTintColor: tabBarTintColor];

    NSLog(@"self.tabBar=%@, self.tabBarController.tabBar=%@",self.tabBar,self.tabBarController.tabBar);
    NSLog(@"MainTabBarController started");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

@end
