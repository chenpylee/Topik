//
//  FeaturedDetailViewController.h
//  Topik
//
//  Created by Lee Haining on 13-11-27.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeaturedLecture.h"
#import "Reachability.h"
@interface FeaturedDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *bookmarkButton;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property(nonatomic,strong)FeaturedLecture *lecture;


@property(nonatomic,strong)UIImage* placeHolderLv1;
@property(nonatomic,strong)UIImage* placeHolderLv2;
@property(nonatomic,strong)UIImage* placeHolderLv3;
@property(nonatomic,strong)UIImage* placeHolderLv4;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UIButton *videoPlayButton;
- (IBAction)checkAndPlay:(id)sender;


- (IBAction)updateBookmark:(id)sender;
- (IBAction)updateDownload:(id)sender;
-(void)insertBookMark:(FeaturedLecture*) lecture;
@end
