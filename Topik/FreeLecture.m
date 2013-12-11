//
//  FreeLecture.m
//  Topik
//
//  Created by Lee Haining on 13-12-8.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "FreeLecture.h"

@implementation FreeLecture
-(id)initWithFreeID:(NSInteger)free_id title:(NSString*)free_title lang:(NSInteger)lecture_lang type:(NSInteger)lecture_type link:(NSString*)free_link host:(NSString *)free_host vid:(NSString*)free_vid img:(NSString*)free_img status:(NSInteger)free_status created:(NSString*)free_created updated:(NSString*)free_updated{
    if(self=[super init])
    {
        _free_id=free_id;
        _free_title=[free_title copy];
        _lecture_lang=lecture_lang;
        _lecture_type=lecture_type;
        _free_link=[free_link copy];
        _free_host=[free_host copy];
        _free_vid=[free_vid copy];
        _free_img=[free_img copy];
        _free_status=free_status;
        _free_created=free_created;
        _free_updated=free_updated;
    }
    return self;
}
-(void)print{
    /**
    NSLog(@"Free Lecture: free_id:%ld free_title:%@ lecture_lang:%d lecture_type:%d free_link:%@ free_host:%@ free_vid:%@ free_img:%@ free_status:%d free_created:%@ free_updated:%@",(long)self.free_id,self.free_title,self.lecture_lang,self.lecture_type,self.free_link,self.free_host,self.free_vid,self.free_img,self.free_status,self.free_created,self.free_updated);
     **/
}
@end
