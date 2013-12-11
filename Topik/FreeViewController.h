//
//  FreeViewController.h
//  Topik
//
//  Created by Lee Haining on 13-12-8.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConfig.h"
#import "FreeLecture.h"
@interface FreeViewController : UITableViewController
@property(nonatomic,strong)NSMutableArray *lectures;
@property(nonatomic,assign)NSInteger lang_id;
@end
