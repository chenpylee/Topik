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
@end
