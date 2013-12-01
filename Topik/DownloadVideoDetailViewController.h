//
//  DownloadVideoDetailViewController.h
//  Topik
//
//  Created by Lee Haining on 13-12-1.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadLecture.h"
@interface DownloadVideoDetailViewController : UIViewController
@property(nonatomic,strong)DownloadLecture *selectedVideo;
- (IBAction)updateDownload:(id)sender;
@end
