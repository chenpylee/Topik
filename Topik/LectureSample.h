//
//  LectureSample.h
//  Topik
//
//  Created by Lee Haining on 13-11-24.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LectureSample : NSObject
//CREATE TABLE topik_lecture_sample(sv_id integer,lecture_id integer,sv_url text,sv_host text,sv_vid text,sv_img text);
@property(nonatomic,assign)NSInteger sv_id;
@property(nonatomic,assign)NSInteger lecture_id;
@property(nonatomic,copy)NSString *sv_url;
@property(nonatomic,copy)NSString *sv_host;
@property(nonatomic,copy)NSString *sv_vid;
@property(nonatomic,copy)NSString *sv_img;
-(id)initWithId:(NSInteger)sv_id lecture:(NSInteger)lecture_id url:(NSString *)sv_url host:(NSString *)sv_host vid:(NSString *)sv_vid imgUrl:(NSString *)sv_img;
-(void)print;
@end
