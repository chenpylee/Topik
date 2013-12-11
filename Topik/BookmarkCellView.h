//
//  BookmarkCellView.h
//  Topik
//
//  Created by Lee Haining on 13-12-11.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookmarkCellView : UITableViewCell
@property(nonatomic,strong)IBOutlet UILabel *titleLabel;
@property(nonatomic,strong)IBOutlet UILabel *countLabel;
@property(nonatomic,strong)IBOutlet UIImageView *thumbImageview;
@end
