//
//  LectureBasic.h
//  Topik
//
//  Created by Lee Haining on 13-11-24.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LectureBasic : NSObject
//CREATE TABLE topik_lecture_basic(lecture_id integer,lecture_title text,lecture_lang integer,lecture_type integer,lecture_level integer,lecture_exam integer, lecture_status integer, lecture_created text, lecture_updated text);
@property(nonatomic,assign)NSInteger lecture_id;
@property(nonatomic,copy)NSString *lecture_title;
@property(nonatomic,assign)NSInteger lecture_lang;
@property(nonatomic,assign)NSInteger lecture_type;
@property(nonatomic,assign)NSInteger lecture_level;
@property(nonatomic,assign)NSInteger lecture_exam;
@property(nonatomic,assign)NSInteger lecture_status;
@property(nonatomic,copy)NSString *lecture_created;
@property(nonatomic,copy)NSString *lecture_updated;

-(id)initWithId:(NSInteger)lecture_id title:(NSString*)lecture_title lang:(NSInteger)lecture_lang type:(NSInteger)lecture_type level:(NSInteger)lecture_level exam:(NSInteger)lecture_exam status:(NSInteger)lecture_status created:(NSString *)lecture_created updated:(NSString *)lecture_updated;
-(void)print;
@end
