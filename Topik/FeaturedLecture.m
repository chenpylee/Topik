//
//  FeaturedLecture.m
//  Topik
//
//  Created by Lee Haining on 13-11-25.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "FeaturedLecture.h"

@implementation FeaturedLecture
-(id)initWithBasic:(LectureBasic *)basic sample:(LectureSample *)sample videos:(NSMutableArray *)videos
{
    if(self=[super init])
    {
        _lecture_id=basic.lecture_id;
        _type_id=basic.lecture_type;
        _level_id=basic.lecture_level;
        _lecture_exam=basic.lecture_exam;
        _lecture_title=basic.lecture_title;
        _lecture_img_url=sample.sv_img;
        _lecture_count=videos.count;
        _sample=sample;
        _videos=videos;
        
    }
    return self;
}
@end
