//
//  LectureSample.h
//  Topik
//
//  Created by Lee Haining on 13-11-24.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LectureLevel : NSObject
//CREATE TABLE topik_lecture_level(level_id integer,level_name text,level_sequence integer);
@property(nonatomic,assign) NSInteger level_id;
@property(nonatomic,copy) NSString *level_name;
@property(nonatomic,assign) NSInteger level_sequence;
-(id)initWithId:(NSInteger)level_id name:(NSString *)level_name sequence:(NSInteger)level_sequence;
-(void)print;
@end
