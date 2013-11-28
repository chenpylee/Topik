//
//  FeaturedLecture.h
//  Topik
//
//  Created by Lee Haining on 13-11-25.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LectureBasic.h"
#import "LectureSample.h"
#import "LectureVideo.h"
@interface FeaturedLecture : NSObject
@property(nonatomic,assign,readonly) NSInteger lecture_id;
@property(nonatomic,assign,readonly) NSInteger lang_id;
@property(nonatomic,assign,readonly) NSInteger type_id;
@property(nonatomic,assign,readonly) NSInteger level_id;
@property(nonatomic,assign,readonly) NSInteger lecture_exam;
@property(nonatomic,copy,readonly) NSString *lecture_title;
@property(nonatomic,copy,readonly) NSString *lecture_img_url;
@property(nonatomic,assign,readonly) NSInteger lecture_count;
@property(nonatomic,strong,readonly)LectureSample *sample;
@property(nonatomic,strong,readonly)NSMutableArray *videos;
-(id)initWithBasic:(LectureBasic *)basic sample:(LectureSample *)sample videos:(NSMutableArray *)videos;
@end
