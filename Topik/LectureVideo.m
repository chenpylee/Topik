//
//  LectureVideo.m
//  Topik
//
//  Created by Lee Haining on 13-11-24.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "LectureVideo.h"

@implementation LectureVideo
-(id)initWIthId:(NSInteger)video_id lecture:(NSInteger)lecture_id fileUrl:(NSString *)video_file name:(NSString *)video_name sequence:(NSInteger)video_sequence{
    if(self=[super init])
    {
        if(video_id>0)
        {
            self.video_id=video_id;
            self.lecture_id=lecture_id;
            self.video_file=video_file;
            self.video_name=video_name;
            self.video_sequence=video_sequence;
        }
    }
    return self;
}
-(void)print{
    //NSLog(@"Video id:%d lecture id:%d fileUrl:%@ name:%@ sequence:%d",self.video_id,self.lecture_id,self.video_file,self.video_name,self.video_sequence);
}
@end
