//
//  DownloadLecture.m
//  Topik
//
//  Created by Lee Haining on 13-12-1.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "DownloadLecture.h"
#import "LectureVideo.h"
#import "AppConfig.h"
@implementation DownloadLecture
-(id)initWithFeaturedLecture:(FeaturedLecture*)lecture videoIndexedAt:(NSInteger)index{
    if(self=[super init])
    {
        _lecture_id=lecture.lecture_id;
        LectureVideo* video =lecture.videos[index];
        _video_id=video.video_id;
        _video_name=video.video_name;
        _video_sequence=video.video_sequence;
        _video_url=video.video_file;
        _added_time=[AppConfig getCurrentDateTime];
        _file_size=0;
        _downloaded_size=0;
        _status=0;
    }
    return self;
}
-(id)initWithDownloadId:(NSInteger)download_id LectureId:(NSInteger)lecture_id VideoId:(NSInteger)video_id VideoSequence:(NSInteger)video_sequence VideoUrl:(NSString*)video_url VideoName:(NSString*)video_name AddedTime:(NSString*)added_time FileSize:(NSInteger)file_size DownloadedSize:(NSInteger)downloaded_size Status:(NSInteger)status;
{
    if(self=[super init])
    {
    _download_id=download_id;
    _lecture_id=lecture_id;
    _video_id=video_id;
    _video_sequence=video_sequence;
    _video_url=video_url;
    _video_name=video_name;
    _added_time=added_time;
    _file_size=file_size;
    _downloaded_size=downloaded_size;
    _status=status;
    }
    return self;
}
@end
