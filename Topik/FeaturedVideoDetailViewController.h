//
//  FeaturedVideoDetailViewController.h
//  Topik
//
//  Created by Lee Haining on 13-12-1.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeaturedLecture.h"
@interface FeaturedVideoDetailViewController : UIViewController<UIAlertViewDelegate>
@property(nonatomic,strong)FeaturedLecture* lecture;
@property(nonatomic,assign)NSInteger videoIndex;
- (IBAction)updateDownload:(id)sender;
@end
