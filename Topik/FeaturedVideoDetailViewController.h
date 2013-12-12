//
//  FeaturedVideoDetailViewController.h
//  Topik
//
//  Created by Lee Haining on 13-12-1.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeaturedLecture.h"
#import "Reachability.h"
@interface FeaturedVideoDetailViewController : UIViewController<UIAlertViewDelegate>
@property(nonatomic,strong)FeaturedLecture* lecture;
@property(nonatomic,assign)NSInteger videoIndex;


@property(nonatomic,strong)UIImage* placeHolderLv1;
@property(nonatomic,strong)UIImage* placeHolderLv2;
@property(nonatomic,strong)UIImage* placeHolderLv3;
@property(nonatomic,strong)UIImage* placeHolderLv4;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UIButton *videoPlayButton;
- (IBAction)checkAndPlay:(id)sender;


- (IBAction)updateDownload:(id)sender;
@end
