//
//  DownloadProgress.h
//  Topik
//
//  Created by Lee Haining on 13-12-3.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadProgress : NSObject
@property(nonatomic,assign)unsigned long long totalSize;
@property(nonatomic,assign)unsigned long long received;
@property(nonatomic,readonly)float progressInFloat;
@property(nonatomic,assign)NSInteger lecture_id;
@property(nonatomic,assign)NSInteger video_id;
@property(nonatomic,copy)NSString *video_url;
@end
