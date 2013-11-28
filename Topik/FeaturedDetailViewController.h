//
//  FeaturedDetailViewController.h
//  Topik
//
//  Created by Lee Haining on 13-11-27.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeaturedLecture.h"
@interface FeaturedDetailViewController : UIViewController<UITableViewDataSource,UITableViewDataSource>
@property(nonatomic,strong)FeaturedLecture *lecture;
@end
