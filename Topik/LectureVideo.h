//
//  LectureVideo.h
//  Topik
//
//  Created by Lee Haining on 13-11-24.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LectureVideo : NSObject
//{"video_id":"8","lecture_id":"13","video_file":"\/test1.mp4","video_name":"TOPIK \u7b2c36\u56de\u4e2d\u7ea7\uff0d\u542c\u529b1","video_sequence":"1","delete":1}
//topik_lecture_video(video_id integer,lecture_id integer,video_file text,video_name text,video_sequence integer);
@property(nonatomic,assign)NSInteger video_id;
@property(nonatomic,assign)NSInteger lecture_id;
@property(nonatomic,copy)NSString *video_file;
@property(nonatomic,copy)NSString *video_name;
@property(nonatomic,assign)NSInteger video_sequence;

-(id)initWIthId:(NSInteger)video_id lecture:(NSInteger)lecture_id fileUrl:(NSString *)video_file name:(NSString *)video_name sequence:(NSInteger)video_sequence;
-(void)print;
@end
