//
//  DownloadProgress.m
//  Topik
//
//  Created by Lee Haining on 13-12-3.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "DownloadProgress.h"

@implementation DownloadProgress
-(float)progressInFloat{
    return (float)((float)_received/(float)_totalSize);
}
@end
