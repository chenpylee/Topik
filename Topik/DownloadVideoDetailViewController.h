//
//  DownloadVideoDetailViewController.h
//  Topik
//
//  Created by Lee Haining on 13-12-1.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadLecture.h"
#import "FeaturedLecture.h"
#import "Reachability.h"
@interface DownloadVideoDetailViewController : UIViewController<UIAlertViewDelegate>
@property(nonatomic,strong)DownloadLecture *selectedVideo;
@property(nonatomic,strong)FeaturedLecture *lecture;
- (IBAction)updateDownload:(id)sender;

@property(nonatomic,strong)UIImage* placeHolderLv1;
@property(nonatomic,strong)UIImage* placeHolderLv2;
@property(nonatomic,strong)UIImage* placeHolderLv3;
@property(nonatomic,strong)UIImage* placeHolderLv4;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UIButton *videoPlayButton;
- (IBAction)checkAndPlay:(id)sender;
@end
