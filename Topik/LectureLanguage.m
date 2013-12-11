//
//  LectureLanguage.m
//  Topik
//
//  Created by Lee Haining on 13-11-24.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "LectureLanguage.h"

@implementation LectureLanguage
-(id)initWithId:(NSInteger)lang_id name:(NSString *)lang_name description:(NSString *)lang_description{
    if(self=[super init])
    {
        if(lang_id>0)
        {
            _lang_id=lang_id;
            _lang_name=lang_name;
            _lang_description=lang_description;
            _featuredCount=0;
            _freeCount=0;
            
        }
    }
    return self;
}
-(void)print{
    //NSLog(@"Language id:%d name:%@ description:%@",self.lang_id,self.lang_name,self.lang_description);
}

@end
