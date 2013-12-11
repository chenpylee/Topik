//
//  BookmarkLecture.m
//  Topik
//
//  Created by Lee Haining on 13-11-30.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "BookmarkLecture.h"
#import "AppConfig.h"

@implementation BookmarkLecture
-(id)initWithFeaturedLecture:(FeaturedLecture*)lecture{
   if(self=[super init])
   {
       _lecture_id=lecture.lecture_id;
       _video_count=lecture.lecture_count;
       _lecture_title=lecture.lecture_title;
       _lecture_img=lecture.lecture_img_url;
       _is_paid=TRUE;
       _bm_created=[AppConfig getCurrentDateTime];
       
   }
    return self;
}
-(id)initWithFreeLecture:(FreeLecture*)lecture{
    if(self=[super init])
    {
        _lecture_id=lecture.free_id;
        _video_count=1;
        _lecture_title=lecture.free_title;
        _lecture_img=lecture.free_img;
        _is_paid=FALSE;
        _bm_created=[AppConfig getCurrentDateTime];
    }
    return self;
}
-(id)initWithLectureId:(NSInteger)lecture_id isPaid:(BOOL)is_paid title:(NSString*)lecture_title img:(NSString*)lecture_img videoCount:(NSInteger)video_count created:(NSString*)bm_created{
    if(self=[super init]){
        _lecture_id=lecture_id;
        _is_paid=is_paid;
        _lecture_title=lecture_title;
        _lecture_img=lecture_img;
        _video_count=video_count;
        _bm_created=bm_created;
    }
    return self;
}
@end
