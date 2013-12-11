//
//  FreeLecture.h
//  Topik
//
//  Created by Lee Haining on 13-12-8.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 "free_id": "20",
 "free_title": "sfdfdffdfdf",
 "lecture_lang": "10",
 "lecture_type": "10",
 "free_link": "http://v.youku.com/v_show/id_XNjIwMDA0MDA4.html",
 "free_host": "v.youku.com",
 "free_vid": "XNjIwMDA0MDA4",
 "free_img": "http://bcs.duapp.com/topikexam/sample/1386423797_home_wifi.jpg",
 "free_status": "2",
 "free_created": "2013-12-07 22:43:18",
 "free_updated": "2013-12-07 22:43:25"
 **/
@interface FreeLecture : NSObject
@property(nonatomic,assign,readonly)NSInteger free_id;
@property(nonatomic,copy,readonly)NSString *free_title;
@property(nonatomic,assign,readonly)NSInteger lecture_lang;
@property(nonatomic,assign,readonly)NSInteger lecture_type;
@property(nonatomic,copy,readonly)NSString *free_link;
@property(nonatomic,copy,readonly)NSString *free_host;
@property(nonatomic,copy,readonly)NSString *free_vid;
@property(nonatomic,copy,readonly)NSString *free_img;
@property(nonatomic,assign,readonly)NSInteger free_status;
@property(nonatomic,copy,readonly)NSString *free_created;
@property(nonatomic,copy,readonly)NSString *free_updated;
-(id)initWithFreeID:(NSInteger)free_id title:(NSString*)free_title lang:(NSInteger)lecture_lang type:(NSInteger)lecture_type link:(NSString*)free_link host:(NSString *)free_host vid:(NSString*)free_vid img:(NSString*)free_img status:(NSInteger)free_status created:(NSString*)free_created updated:(NSString*)free_updated;
@end
