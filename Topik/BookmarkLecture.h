//
//  BookmarkLecture.h
//  Topik
//
//  Created by Lee Haining on 13-11-30.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeaturedLecture.h"
#import "FreeLecture.h"
@interface BookmarkLecture : NSObject
/**
CREATE TABLE topik_bookmark(bm_id integer,lecture_id integer, is_paid integer, lecture_title text,lecture_img text, video_count integer,bm_created text);
 **/
@property(nonatomic,assign,readonly)NSInteger bm_id;
@property(nonatomic,assign,readonly)NSInteger lecture_id;
@property(nonatomic,assign,readonly)BOOL is_paid;
@property(nonatomic,copy,readonly)NSString *lecture_title;
@property(nonatomic,copy,readonly)NSString *lecture_img;
@property(nonatomic,assign,readonly)NSInteger video_count;
@property(nonatomic,copy,readonly)NSString *bm_created;
-(id)initWithFeaturedLecture:(FeaturedLecture*)lecture;
-(id)initWithFreeLecture:(FreeLecture*)lecture;
-(id)initWithLectureId:(NSInteger)lecture_id isPaid:(BOOL)is_paid title:(NSString*)lecture_title img:(NSString*)lecture_img videoCount:(NSInteger)video_count created:(NSString*)bm_created;
@end
