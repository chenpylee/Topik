//
//  FreeCellView.h
//  Topik
//
//  Created by Lee Haining on 13-12-8.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FreeCellView : UITableViewCell
@property(nonatomic,strong)IBOutlet UILabel *titleLabel;
@property(nonatomic,strong)IBOutlet UILabel *countLabel;
@property(nonatomic,strong)IBOutlet UIImageView *thumbImageview;
@end
