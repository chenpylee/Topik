//
//  LectureSample.m
//  Topik
//
//  Created by Lee Haining on 13-11-24.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "LectureSample.h"

@implementation LectureSample
-(id)initWithId:(NSInteger)sv_id lecture:(NSInteger)lecture_id url:(NSString *)sv_url host:(NSString *)sv_host vid:(NSString *)sv_vid imgUrl:(NSString *)sv_img{
    if(self=[super init])
    {
        if(sv_id>0)
        {
            self.sv_id=sv_id;
            self.lecture_id=lecture_id;
            self.sv_url=sv_url;
            self.sv_host=sv_host;
            self.sv_vid=sv_vid;
            self.sv_img=sv_img;
            
        }
    }
    return self;
}
-(void)print{
    //NSLog(@"Sample id:%d lecture id:%d url:%@ host:%@ vid:%@ img:%@",self.sv_id,self.lecture_id,self.sv_url,self.sv_host,self.sv_vid,self.sv_img);
}
@end
