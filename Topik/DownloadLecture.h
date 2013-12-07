//
//  DownloadLecture.h
//  Topik
//
//  Created by Lee Haining on 13-12-1.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeaturedLecture.h"
@interface DownloadLecture : NSObject
/**
 CREATE TABLE topik_download(download_id INTEGER PRIMARY KEY AUTOINCREMENT, lecture_id INTEGER, video_id INTEGER, video_sequence INTEGER, video_url TEXT, added_time TEXT, file_size integer, downloaded_size integer, status integer);
 **/
@property(nonatomic,assign,readonly)NSInteger download_id;
@property(nonatomic,assign,readonly)NSInteger lecture_id;
@property(nonatomic,assign,readonly)NSInteger video_id;
@property(nonatomic,assign,readonly)NSInteger video_sequence;
@property(nonatomic,copy,readonly)NSString *video_url;
@property(nonatomic,copy,readonly)NSString *video_name;
@property(nonatomic,copy,readonly)NSString *added_time;
@property(nonatomic,assign,readonly)NSInteger file_size;
@property(nonatomic,assign,readonly)NSInteger downloaded_size;
@property(nonatomic,assign,readonly)NSInteger status;
-(id)initWithFeaturedLecture:(FeaturedLecture*)lecture videoIndexedAt:(NSInteger)index;
-(id)initWithDownloadId:(NSInteger)download_id LectureId:(NSInteger)lecture_id VideoId:(NSInteger)video_id VideoSequence:(NSInteger)video_sequence VideoUrl:(NSString*)video_url VideoName:(NSString*)video_name AddedTime:(NSString*)added_time FileSize:(NSInteger)file_size DownloadedSize:(NSInteger)downloaded_size Status:(NSInteger)status;
-(void)updateTotalSize:(NSInteger)file_size DownloadedSize:(NSInteger)downloaded_size;
@end
