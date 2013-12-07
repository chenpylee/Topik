//
//  LectureCategory.m
//  Topik
//
//  Created by Lee Haining on 13-11-24.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "LectureCategory.h"

@implementation LectureCategory

-(id)initWithId:(NSInteger)type_id name:(NSString *)type_name sequence:(NSInteger)type_sequence{
    if(self=[super init])
    {
        if(type_id>0)
        {
            self.type_id=type_id;
            self.type_name=type_name;
            self.type_sequence=type_sequence;
        }
    }
    return self;
}
-(void)print{
    NSLog(@"Category id:%ld name:%@ sequence:%ld",(long)self.type_id,self.type_name,(long)self.type_sequence);
}
@end
