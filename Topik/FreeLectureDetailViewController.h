//
//  FreeLectureDetailViewController.h
//  Topik
//
//  Created by Lee Haining on 13-12-8.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FreeLecture.h"
@interface FreeLectureDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *bookmarkButton;
@property(nonatomic,strong)FreeLecture *lecture;
- (IBAction)updateBookmark:(id)sender;
-(void)insertBookMark:(FreeLecture*) lecture;
@end
