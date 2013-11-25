//
//  LectureSample.m
//  Topik
//
//  Created by Lee Haining on 13-11-24.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "LectureLevel.h"

@implementation LectureLevel
-(id)initWithId:(NSInteger)level_id name:(NSString *)level_name sequence:(NSInteger)level_sequence{
    if(self=[super init])
    {
        if(level_id>0)
        {
            self.level_id=level_id;
            self.level_name=level_name;
            self.level_sequence=level_sequence;
        }
    }
    return self;
}
-(void)print{
    NSLog(@"Level id:%d name:%@ sequence:%d",self.level_id,self.level_name,self.level_sequence);
}
@end
