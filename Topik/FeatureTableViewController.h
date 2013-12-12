//
//  FeatureTableViewController.h
//  Topik
//
//  Created by Lee Haining on 13-11-23.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConfig.h"
#import "FeaturedLecture.h"

@interface FeatureTableViewController : UITableViewController
@property(nonatomic,strong)NSMutableArray *lectures;
@property(nonatomic,weak)UIActivityIndicatorView *activityIndicator;
@property(nonatomic,assign)NSInteger lang_id;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *unlockBtn;
- (IBAction)buyProduct:(id)sender;
@end
