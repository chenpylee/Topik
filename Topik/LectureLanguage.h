//
//  LectureLanguage.h
//  Topik
//
//  Created by Lee Haining on 13-11-24.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LectureLanguage : NSObject
//CREATE TABLE topik_lang(lang_id integer,lang_name text,lang_description text);
@property(nonatomic,assign)NSInteger lang_id;
@property(nonatomic,copy)NSString *lang_name;
@property(nonatomic,copy)NSString *lang_description;
@property(nonatomic,assign)NSInteger featuredCount;
@property(nonatomic,assign)NSInteger freeCount;
-(id)initWithId:(NSInteger)lang_id name:(NSString *)lang_name description:(NSString *)lang_description;
-(void)print;
@end
