//
//  LectureBasic.m
//  Topik
//
//  Created by Lee Haining on 13-11-24.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "LectureBasic.h"

@implementation LectureBasic
-(id)initWithId:(NSInteger)lecture_id title:(NSString*)lecture_title lang:(NSInteger)lecture_lang type:(NSInteger)lecture_type level:(NSInteger)lecture_level exam:(NSInteger)lecture_exam status:(NSInteger)lecture_status created:(NSString *)lecture_created updated:(NSString *)lecture_updated{
    if(self=[super init]){
        if(lecture_id>0)
        {
            self.lecture_id=lecture_id;
            self.lecture_title=lecture_title;
            self.lecture_lang=lecture_lang;
            self.lecture_type=lecture_type;
            self.lecture_level=lecture_level;
            self.lecture_exam=lecture_exam;
            self.lecture_status=lecture_status;
            self.lecture_created=lecture_created;
            self.lecture_updated=lecture_updated;
        }
    }
    return self;
}
-(void)print{
    NSLog(@"Basic Info id:%ld title:%@ lang:%ld type:%ld level:%ld exam:%ld status:%ld created:%@ updated:%@",(long)self.lecture_id,self.lecture_title,(long)self.lecture_lang,(long)self.lecture_type,(long)self.lecture_level,(long)self.lecture_exam,(long)self.lecture_status,self.lecture_created,self.lecture_updated);
}
@end
