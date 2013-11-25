//
//  LectureCategory.h
//  Topik
//
//  Created by Lee Haining on 13-11-24.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LectureCategory : NSObject
//CREATE TABLE topik_lecture_cat(type_id integer,type_name text,type_sequence integer);
@property(nonatomic,assign) NSInteger type_id;
@property(nonatomic,copy) NSString *type_name;
@property(nonatomic,assign) NSInteger type_sequence;
-(id)initWithId:(NSInteger)type_id name:(NSString *)type_name sequence:(NSInteger)type_sequence;
-(void)print;
@end
