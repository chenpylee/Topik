//
//  FreeLectureDetailViewController.h
//  Topik
//
//  Created by Lee Haining on 13-12-8.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FreeLecture.h"
#import "Reachability.h"
@interface FreeLectureDetailViewController : UIViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *bookmarkButton;
@property(nonatomic,strong)FreeLecture *lecture;
- (IBAction)updateBookmark:(id)sender;
-(void)insertBookMark:(FreeLecture*) lecture;

@property(nonatomic,strong)UIImage* placeHolderVG;
@property(nonatomic,strong)UIImage* placeHolderW;
@property(nonatomic,strong)UIImage* placeHolderL;
@property(nonatomic,strong)UIImage* placeHolderR;
@property(nonatomic,strong)UIImage* placeHolderO;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UIButton *videoPlayButton;
- (IBAction)checkAndPlay:(id)sender;
@end
