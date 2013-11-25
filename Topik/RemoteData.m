//
//  RemoteData.m
//  Topik
//
//  Created by Lee Haining on 13-11-25.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "RemoteData.h"
#import "LectureLanguage.h"
#import "LectureCategory.h"
#import "LectureLevel.h"
#import "LectureSample.h"
#import "LectureBasic.h"
#import "LectureVideo.h"
@implementation RemoteData
+(BOOL)processTotalJsonData:(NSData *)responseData
{
    NSError* error=nil;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    BOOL processSuccess=false;
    if(error!=NULL)
    {
        NSLog(@"json parsing error:%@",error);
        processSuccess=false;
        return processSuccess;
    }
    else
    {
        //Languages
        
        NSArray* jsonLanguages = [json objectForKey:@"languages"]; //languages setting
        NSArray* jsonCategories = [json objectForKey:@"categories"]; //lecture categories setting
        NSArray* jsonLevels = [json objectForKey:@"levels"]; //lecture levels setting
        NSArray* jsonSamples= [json objectForKey:@"lecture_samples"]; //lecture sample videos
        NSArray* jsonBasics= [json objectForKey:@"lecture_basics"]; //lecture basic information
        NSArray* jsonVideos= [json objectForKey:@"lecture_videos"]; //lecture basic information
        //lecture languages
        NSMutableArray *lectureLanguages=[[NSMutableArray alloc] init];
        for(id object in jsonLanguages)
        {
            NSDictionary* dictionary=(NSDictionary*)object;
            NSInteger lang_id=[[dictionary objectForKey:@"lang_id"] intValue];
            NSString *lang_name=[dictionary objectForKey:@"lang_name"];
            NSString *lang_description=[dictionary objectForKey:@"lang_description"];
            LectureLanguage *language=[[LectureLanguage alloc] initWithId:lang_id name:lang_name description:lang_description];
            [lectureLanguages addObject:language];
        }
        
        for(id object in lectureLanguages)
        {
            [(LectureLanguage *)object print];
        }
        
        
        //lecture categories
        NSMutableArray *lectureCategories=[[NSMutableArray alloc] init];
        for(id object in jsonCategories)
        {
            NSDictionary* dictionary=(NSDictionary*)object;
            NSInteger type_id=[[dictionary objectForKey:@"type_id"] intValue];
            NSString *type_name=[dictionary objectForKey:@"type_name"];
            NSInteger type_sequence=[[dictionary objectForKey:@"type_sequence"] intValue];
            LectureCategory *category=[[LectureCategory alloc] initWithId:type_id name:type_name sequence:type_sequence];
            [lectureCategories addObject:category];
        }
        for(id object in lectureCategories)
        {
            [(LectureCategory *)object print];
        }
        
        //lecture levels
        NSMutableArray *lectureLevels=[[NSMutableArray alloc] init];
        for(id object in jsonLevels)
        {
            NSDictionary* dictionary=(NSDictionary*)object;
            NSInteger level_id=[[dictionary objectForKey:@"level_id"] intValue];
            NSString *level_name=[dictionary objectForKey:@"level_name"];
            NSInteger level_sequence=[[dictionary objectForKey:@"level_sequence"] intValue];
            LectureLevel *level=[[LectureLevel alloc] initWithId:level_id name:level_name sequence:level_sequence];
            [lectureLevels addObject:level];
        }
        for(id object in lectureLevels)
        {
            [(LectureLevel *)object print];
        }
        
        //lecture sample videos
        NSMutableArray *lectureSamples=[[NSMutableArray alloc] init];
        for(id object in jsonSamples)
        {
            NSDictionary* dictionary=(NSDictionary*)object;
            NSInteger sv_id=[[dictionary objectForKey:@"sv_id"] intValue];
            NSInteger lecture_id=[[dictionary objectForKey:@"lecture_id"] intValue];
            NSString *sv_url=[dictionary objectForKey:@"sv_url"];
            NSString *sv_host=[dictionary objectForKey:@"sv_host"];
            NSString *sv_vid=[dictionary objectForKey:@"sv_vid"];
            NSString *sv_img=[dictionary objectForKey:@"sv_img"];
            LectureSample *sample=[[LectureSample alloc] initWithId:sv_id lecture:lecture_id url:sv_url host:sv_host vid:sv_vid imgUrl:sv_img];
            [lectureSamples addObject:sample];
        }
        for(id object in lectureSamples)
        {
            [(LectureSample *)object print];
        }
        
        //lecture sample videos
        NSMutableArray *lectureBasics=[[NSMutableArray alloc] init];
        for(id object in jsonBasics)
        {
            //{"lecture_id":"13","lecture_title":"TOPIK \u7b2c36\u56de\u4e2d\u7ea7\uff0d\u542c\u529b","lecture_lang":"6","lecture_type":"9","lecture_level":"2","lecture_exam":"36","lecture_status":"2","lecture_created":"2013-11-19 03:18:04","lecture_updated":"2013-11-19 03:27:12"},
            NSDictionary* dictionary=(NSDictionary*)object;
            NSInteger lecture_id=[[dictionary objectForKey:@"lecture_id"] intValue];
            NSString *lecture_title=[dictionary objectForKey:@"lecture_title"];
            NSInteger lecture_lang=[[dictionary objectForKey:@"lecture_lang"] intValue];
            NSInteger lecture_type=[[dictionary objectForKey:@"lecture_type"] intValue];
            NSInteger lecture_level=[[dictionary objectForKey:@"lecture_level"] intValue];
            NSInteger lecture_exam=[[dictionary objectForKey:@"lecture_exam"] intValue];
            NSInteger lecture_status=[[dictionary objectForKey:@"lecture_status"] intValue];
            NSString *lecture_created=[dictionary objectForKey:@"lecture_created"];
            NSString *lecture_updated=[dictionary objectForKey:@"lecture_updated"];
            
            LectureBasic *basic=[[LectureBasic alloc] initWithId:lecture_id title:lecture_title lang:lecture_lang type:lecture_type level:lecture_level exam:lecture_exam status:lecture_status created:lecture_created updated:lecture_updated];
            [lectureBasics addObject:basic];
        }
        for(id object in lectureBasics)
        {
            [(LectureBasic *)object print];
        }
        
        //lecture videos
        NSMutableArray *lectureVideos=[[NSMutableArray alloc] init];
        for(id object in jsonVideos)
        {
            //{"video_id":"8","lecture_id":"13","video_file":"http:\/\/bcs.duapp.com\/topik-upload\/test1.mp4","video_name":"TOPIK \u7b2c36\u56de\u4e2d\u7ea7\uff0d\u542c\u529b1","video_sequence":"1","delete":1}
            
            NSDictionary* dictionary=(NSDictionary*)object;
            NSInteger video_id=[[dictionary objectForKey:@"video_id"] intValue];
            NSInteger lecture_id=[[dictionary objectForKey:@"lecture_id"] intValue];
            NSString *video_file=[dictionary objectForKey:@"video_file"];
            NSString *video_name=[dictionary objectForKey:@"video_name"];
            NSInteger video_sequence=[[dictionary objectForKey:@"video_sequence"] intValue];
            LectureVideo* video=[[LectureVideo alloc] initWIthId:video_id lecture:lecture_id fileUrl:video_file name:video_name sequence:video_sequence];
            [lectureVideos addObject:video];
        }
        for(id object in lectureVideos)
        {
            [(LectureVideo *)object print];
        }
        //FMDatabase Operation
        BOOL needUpdate=true;
        if(lectureLanguages.count>0&&lectureCategories.count>0&&lectureLevels.count>0&&lectureBasics.count>0&&lectureVideos.count>0&&lectureSamples.count>0)
            needUpdate=true;
        else
            needUpdate=false;
        
        if(needUpdate)
        {
            NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docsPath = [paths objectAtIndex:0];
            NSString *dbPath = [docsPath stringByAppendingPathComponent:@"LectureDB.sqlite"];
            NSLog(@"dbPath:%@",dbPath);
            FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
            if (![db open]) {
                NSLog(@"Could not open db.");
            }
            else
            {
                NSString *deleteQuery =@"";//@"DELETE FROM user WHERE age = 25";
                //clear old data and insert new ones
                //topik_lang            topik_lecture_cat     topik_lecture_sample
                //topik_lecture_basic   topik_lecture_level   topik_lecture_video
                NSArray *tableArray=[NSArray arrayWithObjects:@"topik_lang",@"topik_lecture_cat", @"topik_lecture_level",@"topik_lecture_basic",@"topik_lecture_sample",@"topik_lecture_video",nil];
                for(id object in tableArray)
                {
                    NSString *tableName=(NSString *)object;
                    deleteQuery=[NSString stringWithFormat:@"DELETE FROM %@",tableName];
                    [db executeUpdate:deleteQuery];
                    if ([db hadError]) {
                        NSLog(@"Clear Table:%@ Err %d: %@", tableName,[db lastErrorCode], [db lastErrorMessage]);
                    }
                    
                }
                //insert topik_lang data from lectureLanguages
                //CREATE TABLE topik_lang(lang_id integer,lang_name text,lang_description text);
                for(id language in lectureLanguages)
                {
                    //
                    LectureLanguage *lang=(LectureLanguage *)language;
                    [db executeUpdate:@"INSERT INTO topik_lang VALUES (?,?,?)", [NSNumber numberWithInt:lang.lang_id],lang.lang_name,lang.lang_description];
                    if ([db hadError]) {
                        NSLog(@"INSERT INTO Table:%@ Err %d: %@", @"topik_lang",[db lastErrorCode], [db lastErrorMessage]);
                    }
                }
                //print out langues
                FMResultSet *s = [db executeQuery:@"SELECT * FROM topik_lang"];
                while ([s next]) {
                    int lang_id=[s intForColumn:@"lang_id"];
                    NSString *lang_name=[s stringForColumn:@"lang_name"];
                    NSString *lang_description=[s stringForColumn:@"lang_description"];

                    NSLog(@"topik_lang: lang_id=%d, lang_name=%@, lang_description=%@",lang_id,lang_name,lang_description);
                }
                
                //insert topik_lecture_cat data from lectureCategories
                //CREATE TABLE topik_lecture_cat(type_id integer,type_name text,type_sequence integer);
                for(id category in lectureCategories)
                {
                    //
                    LectureCategory *cat=(LectureCategory *)category;
                    [db executeUpdate:@"INSERT INTO topik_lecture_cat VALUES (?,?,?)", [NSNumber numberWithInt:cat.type_id],cat.type_name, [NSNumber numberWithInt:cat.type_sequence]];
                    if ([db hadError]) {
                        NSLog(@"INSERT INTO Table:%@ Err %d: %@", @"topik_lecture_cat",[db lastErrorCode], [db lastErrorMessage]);
                    }
                }
                //print out categories
                s = [db executeQuery:@"SELECT * FROM topik_lecture_cat"];
                while ([s next]) {
                    int type_id=[s intForColumn:@"type_id"];
                    NSString *type_name=[s stringForColumn:@"type_name"];
                    int type_sequence=[s intForColumn:@"type_sequence"];
                    
                    NSLog(@"topik_lecture_cat: type_id=%d, type_name=%@, type_sequence=%d",type_id,type_name,type_sequence);
                }
                //insert topik_lecture_level data from lectureLevels
                //CREATE TABLE topik_lecture_level(level_id integer,level_name text,level_sequence integer);
                for(id level in lectureLevels)
                {
                    //
                    LectureLevel *lv=(LectureLevel *)level;
                    [db executeUpdate:@"INSERT INTO topik_lecture_level VALUES (?,?,?)", [NSNumber numberWithInt:lv.level_id],lv.level_name, [NSNumber numberWithInt:lv.level_sequence]];
                    if ([db hadError]) {
                        NSLog(@"INSERT INTO Table:%@ Err %d: %@", @"topik_lecture_level",[db lastErrorCode], [db lastErrorMessage]);
                    }
                }
                //print out levels
                s = [db executeQuery:@"SELECT * FROM topik_lecture_level"];
                while ([s next]) {
                    int level_id=[s intForColumn:@"level_id"];
                    NSString *level_name=[s stringForColumn:@"level_name"];
                    int level_sequence=[s intForColumn:@"level_sequence"];
                    
                    NSLog(@"topik_lecture_level: level_id=%d, level_name=%@, level_sequence=%d",level_id,level_name,level_sequence);
                }

                //topik_lecture_basic
                //insert topik_lecture_basic data from lectureBasics
                //CREATE TABLE topik_lecture_basic(lecture_id integer,lecture_title text,lecture_lang integer,lecture_type integer,lecture_level integer,lecture_exam integer, lecture_status integer, lecture_created text, lecture_updated text);
                for(id lectureBasic in lectureBasics)
                {
                    //
                    LectureBasic *basic=(LectureBasic *)lectureBasic;
                    [db executeUpdate:@"INSERT INTO topik_lecture_basic VALUES (?,?,?,?,?,?,?,?,?)",
                     [NSNumber numberWithInt:basic.lecture_id],
                     basic.lecture_title,
                     [NSNumber numberWithInt:basic.lecture_lang],
                     [NSNumber numberWithInt:basic.lecture_type],
                     [NSNumber numberWithInt:basic.lecture_level],
                     [NSNumber numberWithInt:basic.lecture_exam],
                     [NSNumber numberWithInt:basic.lecture_status],
                     basic.lecture_created,
                     basic.lecture_updated
                     ];
                    if ([db hadError]) {
                        NSLog(@"INSERT INTO Table:%@ Err %d: %@", @"topik_lecture_basic",[db lastErrorCode], [db lastErrorMessage]);
                    }
                }
                //print out basic information
                s = [db executeQuery:@"SELECT * FROM topik_lecture_basic"];
                while ([s next]) {
                    int lecture_id=[s intForColumn:@"lecture_id"];
                    NSString *lecture_title=[s stringForColumn:@"lecture_title"];
                    int lecture_lang=[s intForColumn:@"lecture_lang"];
                    int lecture_type=[s intForColumn:@"lecture_type"];
                    int lecture_level=[s intForColumn:@"lecture_level"];
                    int lecture_exam=[s intForColumn:@"lecture_exam"];
                    int lecture_status=[s intForColumn:@"lecture_status"];
                    NSString *lecture_created=[s stringForColumn:@"lecture_created"];
                    NSString *lecture_updated=[s stringForColumn:@"lecture_updated"];
                    
                    NSLog(@"topik_lecture_basic: lecture_id=%d, lecture_title=%@, lecture_lang=%d,  lecture_type=%d, lecture_level=%d, lecture_exam=%d, lecture_status=%d,lecture_created=%@, lecture_updated=%@,",lecture_id,lecture_title,lecture_lang,lecture_type,lecture_level,lecture_exam,lecture_status,lecture_created,lecture_updated);
                }

                
                //topik_lecture_video
                //insert topik_lecture_video data from lectureVideos
                //CREATE TABLE topik_lecture_video(video_id integer,lecture_id integer,video_file text,video_name text,video_sequence integer);
                for(id lectureVideo in lectureVideos)
                {
                    //
                    LectureVideo *video=(LectureVideo *)lectureVideo;
                    [db executeUpdate:@"INSERT INTO topik_lecture_video VALUES (?,?,?,?,?)",
                     [NSNumber numberWithInt:video.video_id],
                     [NSNumber numberWithInt:video.lecture_id],
                     video.video_file,
                     video.video_name,
                     [NSNumber numberWithInt:video.video_sequence]
                     ];
                    if ([db hadError]) {
                        NSLog(@"INSERT INTO Table:%@ Err %d: %@", @"topik_lecture_video",[db lastErrorCode], [db lastErrorMessage]);
                    }
                }
                //print out video information
                s = [db executeQuery:@"SELECT * FROM topik_lecture_video"];
                while ([s next]) {
                    int video_id=[s intForColumn:@"video_id"];
                    int lecture_id=[s intForColumn:@"lecture_id"];
                    int video_sequence=[s intForColumn:@"video_sequence"];
                    NSString *video_file=[s stringForColumn:@"video_file"];
                    NSString *video_name=[s stringForColumn:@"video_name"];
                    
                    NSLog(@"topik_lecture_video: video_id=%d, lecture_id=%d,video_file=%@, video_name=%@,  video_sequence=%d",video_id,lecture_id,video_file,video_name,video_sequence);
                }
                
                //topik_lecture_sample
                //insert topik_lecture_sample data from lectureSamples
                //CREATE TABLE topik_lecture_sample(sv_id integer,lecture_id integer,sv_url text,sv_host text,sv_vid text,sv_img text);
                for(id lectureSample in lectureSamples)
                {
                    //
                    LectureSample *sample=(LectureSample *)lectureSample;
                    [db executeUpdate:@"INSERT INTO topik_lecture_sample VALUES (?,?,?,?,?,?)",
                     [NSNumber numberWithInt:sample.sv_id],
                     [NSNumber numberWithInt:sample.lecture_id],
                     sample.sv_url,
                     sample.sv_host,
                     sample.sv_vid,
                     sample.sv_img
                     ];
                    if ([db hadError]) {
                        NSLog(@"INSERT INTO Table:%@ Err %d: %@", @"topik_lecture_sample",[db lastErrorCode], [db lastErrorMessage]);
                    }
                }
                //print out sample video information
                s = [db executeQuery:@"SELECT * FROM topik_lecture_sample"];
                while ([s next]) {
                    int sv_id=[s intForColumn:@"sv_id"];
                    int lecture_id=[s intForColumn:@"lecture_id"];
                    NSString *sv_url=[s stringForColumn:@"sv_url"];
                    NSString *sv_host=[s stringForColumn:@"sv_host"];
                    NSString *sv_vid=[s stringForColumn:@"sv_vid"];
                    NSString *sv_img=[s stringForColumn:@"sv_img"];
                    NSLog(@"topik_lecture_sample: sv_id=%d, lecture_id=%d,sv_url=%@, sv_host=%@,  sv_vid=%@,sv_img=%@",sv_id,lecture_id,sv_url,sv_host,sv_vid,sv_img);
                }

            }
            [db close];
        
        }
        
        processSuccess=true;
        return processSuccess;
    }
}

@end
