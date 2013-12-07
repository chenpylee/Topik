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
#import "FeaturedLecture.h"
#import "AppConfig.h"
#import "ASIHTTPRequest.h"
#import "BookmarkLecture.h"
#import "DownloadLecture.h"
#import "Downloader.h"
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
        /**
        for(id object in lectureLanguages)
        {
            [(LectureLanguage *)object print];
        }
         **/
        
        
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
        /**
        for(id object in lectureCategories)
        {
            [(LectureCategory *)object print];
        }
         **/
        
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
        /**
        for(id object in lectureLevels)
        {
            [(LectureLevel *)object print];
        }
         **/
        
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
            sv_img=[sv_img stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            LectureSample *sample=[[LectureSample alloc] initWithId:sv_id lecture:lecture_id url:sv_url host:sv_host vid:sv_vid imgUrl:sv_img];
            [lectureSamples addObject:sample];
        }
        /**
        for(id object in lectureSamples)
        {
            [(LectureSample *)object print];
        }
         **/
        
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
            video_file=[video_file stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
            //NSLog(@"dbPath:%@",dbPath);
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
                    [db executeUpdate:@"INSERT INTO topik_lang VALUES (?,?,?)", [NSNumber numberWithInteger:lang.lang_id],lang.lang_name,lang.lang_description];
                    if ([db hadError]) {
                        //NSLog(@"INSERT INTO Table:%@ Err %d: %@", @"topik_lang",[db lastErrorCode], [db lastErrorMessage]);
                    }
                }
                //print out langues
                
                FMResultSet *s = [db executeQuery:@"SELECT * FROM topik_lang"];
                /**
                while ([s next]) {
                    int lang_id=[s intForColumn:@"lang_id"];
                    NSString *lang_name=[s stringForColumn:@"lang_name"];
                    NSString *lang_description=[s stringForColumn:@"lang_description"];

                    //NSLog(@"topik_lang: lang_id=%d, lang_name=%@, lang_description=%@",lang_id,lang_name,lang_description);
                }
                **/
                
                //insert topik_lecture_cat data from lectureCategories
                //CREATE TABLE topik_lecture_cat(type_id integer,type_name text,type_sequence integer);
                for(id category in lectureCategories)
                {
                    //
                    LectureCategory *cat=(LectureCategory *)category;
                    [db executeUpdate:@"INSERT INTO topik_lecture_cat VALUES (?,?,?)", [NSNumber numberWithInteger:cat.type_id],cat.type_name, [NSNumber numberWithInteger:cat.type_sequence]];
                    if ([db hadError]) {
                        NSLog(@"INSERT INTO Table:%@ Err %d: %@", @"topik_lecture_cat",[db lastErrorCode], [db lastErrorMessage]);
                    }
                }
                //print out categories
                /**
                s = [db executeQuery:@"SELECT * FROM topik_lecture_cat"];
                while ([s next]) {
                    int type_id=[s intForColumn:@"type_id"];
                    NSString *type_name=[s stringForColumn:@"type_name"];
                    int type_sequence=[s intForColumn:@"type_sequence"];
                    
                    NSLog(@"topik_lecture_cat: type_id=%d, type_name=%@, type_sequence=%d",type_id,type_name,type_sequence);
                }
                 **/
                //insert topik_lecture_level data from lectureLevels
                //CREATE TABLE topik_lecture_level(level_id integer,level_name text,level_sequence integer);
                for(id level in lectureLevels)
                {
                    //
                    LectureLevel *lv=(LectureLevel *)level;
                    [db executeUpdate:@"INSERT INTO topik_lecture_level VALUES (?,?,?)", [NSNumber numberWithInteger:lv.level_id],lv.level_name, [NSNumber numberWithInteger:lv.level_sequence]];
                    if ([db hadError]) {
                        NSLog(@"INSERT INTO Table:%@ Err %d: %@", @"topik_lecture_level",[db lastErrorCode], [db lastErrorMessage]);
                    }
                }
                //print out levels
                /**
                s = [db executeQuery:@"SELECT * FROM topik_lecture_level"];
                while ([s next]) {
                    int level_id=[s intForColumn:@"level_id"];
                    NSString *level_name=[s stringForColumn:@"level_name"];
                    int level_sequence=[s intForColumn:@"level_sequence"];
                    
                   NSLog(@"topik_lecture_level: level_id=%d, level_name=%@, level_sequence=%d",level_id,level_name,level_sequence);
                }
                 **/

                //topik_lecture_basic
                //insert topik_lecture_basic data from lectureBasics
                //CREATE TABLE topik_lecture_basic(lecture_id integer,lecture_title text,lecture_lang integer,lecture_type integer,lecture_level integer,lecture_exam integer, lecture_status integer, lecture_created text, lecture_updated text);
                for(id lectureBasic in lectureBasics)
                {
                    //
                    LectureBasic *basic=(LectureBasic *)lectureBasic;
                    [db executeUpdate:@"INSERT INTO topik_lecture_basic VALUES (?,?,?,?,?,?,?,?,?)",
                     [NSNumber numberWithInteger:basic.lecture_id],
                     basic.lecture_title,
                     [NSNumber numberWithInteger:basic.lecture_lang],
                     [NSNumber numberWithInteger:basic.lecture_type],
                     [NSNumber numberWithInteger:basic.lecture_level],
                     [NSNumber numberWithInteger:basic.lecture_exam],
                     [NSNumber numberWithInteger:basic.lecture_status],
                     basic.lecture_created,
                     basic.lecture_updated
                     ];
                    if ([db hadError]) {
                        NSLog(@"INSERT INTO Table:%@ Err %d: %@", @"topik_lecture_basic",[db lastErrorCode], [db lastErrorMessage]);
                    }
                }
                //print out basic information
                /**
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
                **/
                
                //topik_lecture_video
                //insert topik_lecture_video data from lectureVideos
                //CREATE TABLE topik_lecture_video(video_id integer,lecture_id integer,video_file text,video_name text,video_sequence integer);
                for(id lectureVideo in lectureVideos)
                {
                    //
                    LectureVideo *video=(LectureVideo *)lectureVideo;
                    [db executeUpdate:@"INSERT INTO topik_lecture_video VALUES (?,?,?,?,?)",
                     [NSNumber numberWithInteger:video.video_id],
                     [NSNumber numberWithInteger:video.lecture_id],
                     video.video_file,
                     video.video_name,
                     [NSNumber numberWithInteger:video.video_sequence]
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
                     [NSNumber numberWithInteger:sample.sv_id],
                     [NSNumber numberWithInteger:sample.lecture_id],
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
                /**
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
                 **/

            }
            [db close];
        
        }
        
        processSuccess=true;
        [[NSNotificationCenter defaultCenter]postNotificationName:APP_NOTIFICATION_TOTAL_DATA_LOADED object:nil];
        return processSuccess;
    }
}
+(NSMutableArray*)loadFeaturedLecturesToArray{
    NSMutableArray *featuredLectures=[[NSMutableArray alloc] init];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"LectureDB.sqlite"];
    NSLog(@"dbPath:%@",dbPath);
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"Could not open db. when loadFeaturedLecturesToArray");
    }
    else
    {
        FMResultSet *s = [db executeQuery:@"SELECT * FROM topik_lecture_basic"];
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
            LectureBasic *basic=[[LectureBasic alloc] initWithId:lecture_id title:lecture_title lang:lecture_lang type:lecture_type level:lecture_level exam:lecture_exam status:lecture_status created:lecture_created updated:lecture_updated];
            NSLog(@"loadFeaturedLecturesToArray-topik_lecture_basic: lecture_id=%d, lecture_title=%@, lecture_lang=%d,  lecture_type=%d, lecture_level=%d, lecture_exam=%d, lecture_status=%d,lecture_created=%@, lecture_updated=%@,",lecture_id,lecture_title,lecture_lang,lecture_type,lecture_level,lecture_exam,lecture_status,lecture_created,lecture_updated);
            LectureSample *sample=[RemoteData getLectureSampleFromDbByLectureId:lecture_id];
            NSMutableArray *videos=[RemoteData getLectureVideosFromDbByLectureId:lecture_id];
            FeaturedLecture *featuredLecture=[[FeaturedLecture alloc] initWithBasic:basic sample:sample videos:videos];
            [featuredLectures addObject:featuredLecture];
        }

    }
    [db close];
    return featuredLectures;
}
+(LectureSample *)getLectureSampleFromDbByLectureId:(NSInteger)lecture_id
{
    LectureSample *sample=nil;
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"LectureDB.sqlite"];
    NSLog(@"dbPath:%@",dbPath);
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"Could not open db. when loadFeaturedLecturesToArray");
    }
    else
    {
        //print out sample video information
        //TABLE topik_lecture_sample(sv_id integer,lecture_id integer,sv_url text,sv_host text,sv_vid text,sv_img text);
         FMResultSet *s = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM topik_lecture_sample WHERE lecture_id=%ld",(long)lecture_id]];
        if ([s next]) {
            int sv_id=[s intForColumn:@"sv_id"];
            int lecture_id=[s intForColumn:@"lecture_id"];
            NSString *sv_url=[s stringForColumn:@"sv_url"];
            NSString *sv_host=[s stringForColumn:@"sv_host"];
            NSString *sv_vid=[s stringForColumn:@"sv_vid"];
            NSString *sv_img=[s stringForColumn:@"sv_img"];
            NSLog(@" getLectureSampleFromDbByLectureId topik_lecture_sample: sv_id=%d, lecture_id=%d,sv_url=%@, sv_host=%@,  sv_vid=%@,sv_img=%@",sv_id,lecture_id,sv_url,sv_host,sv_vid,sv_img);
            if(sv_id>0)
            {
                sample=[[LectureSample alloc] initWithId:sv_id lecture:lecture_id url:sv_url host:sv_host vid:sv_vid imgUrl:sv_img];
            }
        }

    }
    [db close];

    return sample;
}
+(NSMutableArray *)getLectureVideosFromDbByLectureId:(NSInteger)lecture_id
{
    NSMutableArray *videos=[[NSMutableArray alloc] init];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"LectureDB.sqlite"];
    NSLog(@"dbPath:%@",dbPath);
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"Could not open db. when loadFeaturedLecturesToArray");
    }
    else
    {
        //print out sample video information
        //TABLE topik_lecture_sample(sv_id integer,lecture_id integer,sv_url text,sv_host text,sv_vid text,sv_img text);
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM topik_lecture_video WHERE lecture_id=%ld",(long)lecture_id];
        FMResultSet *s = [db executeQuery:query];
        while ([s next]) {
            int video_id=[s intForColumn:@"video_id"];
            int lecture_id=[s intForColumn:@"lecture_id"];
            int video_sequence=[s intForColumn:@"video_sequence"];
            NSString *video_file=[s stringForColumn:@"video_file"];
            NSString *video_name=[s stringForColumn:@"video_name"];
            
            NSLog(@"getLectureVideosFromDbByLectureId-topik_lecture_video: video_id=%d, lecture_id=%d,video_file=%@, video_name=%@,  video_sequence=%d",video_id,lecture_id,video_file,video_name,video_sequence);
            LectureVideo *video=[[LectureVideo alloc] initWIthId:video_id lecture:lecture_id fileUrl:video_file name:video_name sequence:video_sequence];
            [videos addObject:video];
        }
        
    }
    [db close];

    return videos;
}
+(void)InsertFeaturedLectureBookmark:(FeaturedLecture*)featuredLecture{
    /**
     CREATE TABLE topik_bookmark(bm_id integer,lecture_id integer, is_paid integer, lecture_title text,lecture_img text, video_count integer,bm_created text);
     **/
    BookmarkLecture *bookmark=[[BookmarkLecture alloc] initWithFeaturedLecture:featuredLecture];
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
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM topik_bookmark WHERE lecture_id=%ld AND is_paid=1",(long)featuredLecture.lecture_id];
        FMResultSet *s = [db executeQuery:query];
        BOOL isExist=FALSE;
        while ([s next]) {
            NSInteger bookmark_id=[s intForColumn:@"bm_id"];
            NSInteger lecture_id=[s intForColumn:@"lecture_id"];
            NSInteger is_paid_int=[s intForColumn:@"is_paid"];
            BOOL is_paid=FALSE;
            if(is_paid_int==1)
            {
                is_paid=TRUE;
            }
            NSString *lecture_title=[s stringForColumn:@"lecture_title"];
            NSString *lecture_img=[s stringForColumn:@"lecture_img"];
            NSInteger video_count=[s intForColumn:@"video_count"];
            NSString *bm_created=[s stringForColumn:@"bm_created"];
            
            NSLog(@"EXIST: topik_bookmark: bookmark_id=%ld, lecture_id=%ld,is_paid_int=%ld, lecture_title=%@,  lecture_img=%@, video_count=%ld, bm_created=%@",(long)bookmark_id,(long)lecture_id,(long)is_paid_int,lecture_title,lecture_img,(long)video_count,bm_created);
            isExist=TRUE;
        }
        if(isExist)
            return;

        [db executeUpdate:@"INSERT INTO topik_bookmark(lecture_id,is_paid,lecture_title,lecture_img,video_count,bm_created) VALUES (?,?,?,?,?,?)",
         [NSNumber numberWithInteger:bookmark.lecture_id],
         [NSNumber numberWithInteger:1],
         bookmark.lecture_title,
         bookmark.lecture_img,
         [NSNumber numberWithInteger:bookmark.video_count],
         bookmark.bm_created
         ];
        if ([db hadError]) {
            NSLog(@"INSERT INTO Table:%@ Err %d: %@", @"topik_bookmark",[db lastErrorCode], [db lastErrorMessage]);
        }
        
        //print out result
        query=@"SELECT * FROM topik_bookmark";
        s = [db executeQuery:query];
        while ([s next]) {
           
            NSInteger is_paid_int=[s intForColumn:@"is_paid"];
            BOOL is_paid=FALSE;
            if(is_paid_int==1)
            {
                is_paid=TRUE;
            }
            /**
             NSInteger bookmark_id=[s intForColumn:@"bm_id"];
             NSInteger lecture_id=[s intForColumn:@"lecture_id"];
            NSString *lecture_title=[s stringForColumn:@"lecture_title"];
            NSString *lecture_img=[s stringForColumn:@"lecture_img"];
            NSInteger video_count=[s intForColumn:@"video_count"];
            NSString *bm_created=[s stringForColumn:@"bm_created"];
            
            NSLog(@"topik_bookmark: bookmark_id=%d, lecture_id=%d,is_paid_int=%d, lecture_title=%@,  lecture_img=%@, video_count=%d, bm_created=%@",bookmark_id,lecture_id,is_paid_int,lecture_title,lecture_img,video_count,bm_created);
             **/
        }

    }
    [db close];
}
+(BOOL)FeaturedLectureExistsInBookmark:(FeaturedLecture*)featuredLecture{
    BOOL isExist=FALSE;
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
        
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM topik_bookmark WHERE lecture_id=%ld AND is_paid=1",(long)featuredLecture.lecture_id];
        FMResultSet *s = [db executeQuery:query];
        while ([s next]) {
            NSInteger is_paid_int=[s intForColumn:@"is_paid"];
            BOOL is_paid=FALSE;
            if(is_paid_int==1)
            {
                is_paid=TRUE;
            }
            
            //NSLog(@"FeaturedLectureExistsInBookmark: topik_bookmark: bookmark_id=%d, lecture_id=%d,is_paid_int=%d, lecture_title=%@,  lecture_img=%@, video_count=%d, bm_created=%@",bookmark_id,lecture_id,is_paid_int,lecture_title,lecture_img,video_count,bm_created);
            isExist=TRUE;
        }
        
    }
    [db close];

    return isExist;
}
+(void)RemoveFeaturedLectureFromBookmark:(FeaturedLecture*)featuredLecture{
    
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
        deleteQuery=[NSString stringWithFormat:@"DELETE FROM topik_bookmark WHERE lecture_id=%ld AND is_paid=1",(long)featuredLecture.lecture_id];
        [db executeUpdate:deleteQuery];
        if ([db hadError]) {
            NSLog(@"Clear Table:%@ Err %d: %@", @"topik_bookmark",[db lastErrorCode], [db lastErrorMessage]);
        }
    }
    [db close];
}
+(void)InsertFeaturedLectureVideoDownload:(FeaturedLecture*)featuredLecture{
    /**
     CREATE TABLE topik_download(download_id INTEGER PRIMARY KEY AUTOINCREMENT, lecture_id INTEGER, video_id INTEGER, video_sequence INTEGER, video_url TEXT, added_time TEXT, file_size integer, downloaded_size integer, status integer);
     **/
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"LectureDB.sqlite"];
    //NSLog(@"dbPath:%@",dbPath);
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    else
    {
        NSInteger videoCount=featuredLecture.videos.count;
        NSInteger videoIndex=0;
        Downloader*downloader=[Downloader sharedInstance];
        for(videoIndex=0;videoIndex<videoCount;videoIndex++)
        {
            DownloadLecture *lecture=[[DownloadLecture alloc] initWithFeaturedLecture:featuredLecture videoIndexedAt:videoIndex];
            if(![RemoteData VideoExistInDownload:lecture.video_id])
            {
                [db executeUpdate:@"INSERT INTO topik_download(lecture_id,video_id,video_sequence,video_url,video_name,added_time,file_size,downloaded_size,status) VALUES (?,?,?,?,?,?,?,?,?)",
                 [NSNumber numberWithInteger:lecture.lecture_id],
                 [NSNumber numberWithInteger:lecture.video_id],
                 [NSNumber numberWithInteger:lecture.video_sequence],
                 lecture.video_url,
                 lecture.video_name,
                 lecture.added_time,
                 [NSNumber numberWithInteger:lecture.file_size],
                 [NSNumber numberWithInteger:lecture.downloaded_size],
                 [NSNumber numberWithInteger:lecture.status]
                 ];
                
            }
            [downloader addDownloadLecture:lecture];
        }
    }
    
    //print all download record out
    /**
    NSString *query=@"SELECT * FROM topik_download";
    FMResultSet *s = [db executeQuery:query];
    while ([s next]) {
        NSInteger download_id=[s intForColumn:@"download_id"];
        NSInteger lecture_id=[s intForColumn:@"lecture_id"];
        NSInteger video_id=[s intForColumn:@"video_id"];
        NSInteger video_sequence=[s intForColumn:@"video_sequence"];
        NSString *video_url=[s stringForColumn:@"video_url"];
        NSString *video_name=[s stringForColumn:@"video_name"];
        NSString *added_time=[s stringForColumn:@"added_time"];
        NSInteger file_size=[s intForColumn:@"file_size"];
        NSInteger downloaded_size=[s intForColumn:@"downloaded_size"];
        NSInteger status=[s intForColumn:@"status"];
        
        NSLog(@"topik_download: download_id=%d, lecture_id=%d,video_id=%d, video_sequence=%d,  video_url=%@, video_name=%@, added_time=%@, file_size=%d, downloaded_size=%d, status=%d",download_id,lecture_id,video_id,video_sequence,video_url,video_name,added_time,file_size,downloaded_size,status);
    }
     **/

    [db close];
}
+(void)InsertSingleDowloadVideoDownload:(DownloadLecture*)downloadVideo
{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"LectureDB.sqlite"];
    //NSLog(@"dbPath:%@",dbPath);
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    else
    {
        DownloadLecture *lecture=downloadVideo;
        Downloader*downloader=[Downloader sharedInstance];
        if(![RemoteData VideoExistInDownload:lecture.video_id])
        {
            [db executeUpdate:@"INSERT INTO topik_download(lecture_id,video_id,video_sequence,video_url,video_name,added_time,file_size,downloaded_size,status) VALUES (?,?,?,?,?,?,?,?,?)",
             [NSNumber numberWithInteger:lecture.lecture_id],
             [NSNumber numberWithInteger:lecture.video_id],
             [NSNumber numberWithInteger:lecture.video_sequence],
             lecture.video_url,
             lecture.video_name,
             lecture.added_time,
             [NSNumber numberWithInteger:lecture.file_size],
             [NSNumber numberWithInteger:lecture.downloaded_size],
             [NSNumber numberWithInteger:lecture.status]
             ];
            
        }
        [downloader addDownloadLecture:lecture];
    }
    
    //print all download record out
    /**
    NSString *query=@"SELECT * FROM topik_download";
    FMResultSet *s = [db executeQuery:query];
    while ([s next]) {
        NSInteger download_id=[s intForColumn:@"download_id"];
        NSInteger lecture_id=[s intForColumn:@"lecture_id"];
        NSInteger video_id=[s intForColumn:@"video_id"];
        NSInteger video_sequence=[s intForColumn:@"video_sequence"];
        NSString *video_url=[s stringForColumn:@"video_url"];
        NSString *video_name=[s stringForColumn:@"video_name"];
        NSString *added_time=[s stringForColumn:@"added_time"];
        NSInteger file_size=[s intForColumn:@"file_size"];
        NSInteger downloaded_size=[s intForColumn:@"downloaded_size"];
        NSInteger status=[s intForColumn:@"status"];
        
        NSLog(@"topik_download: download_id=%d, lecture_id=%d,video_id=%d, video_sequence=%d,  video_url=%@, video_name=%@, added_time=%@, file_size=%d, downloaded_size=%d, status=%d",download_id,lecture_id,video_id,video_sequence,video_url,video_name,added_time,file_size,downloaded_size,status);
    }
     **/
    
    [db close];

}
+(void)InsertSingleFeaturedLectureVideoDownload:(FeaturedLecture*)featuredLecture indexAt:(NSInteger)videoIndex{
    /**
     CREATE TABLE topik_download(download_id INTEGER PRIMARY KEY AUTOINCREMENT, lecture_id INTEGER, video_id INTEGER, video_sequence INTEGER, video_url TEXT, added_time TEXT, file_size integer, downloaded_size integer, status integer);
     **/
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"LectureDB.sqlite"];
    //NSLog(@"dbPath:%@",dbPath);
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    else
    {
        Downloader*downloader=[Downloader sharedInstance];
        DownloadLecture *lecture=[[DownloadLecture alloc] initWithFeaturedLecture:featuredLecture videoIndexedAt:videoIndex];
        if(![RemoteData VideoExistInDownload:lecture.video_id])
        {
            [db executeUpdate:@"INSERT INTO topik_download(lecture_id,video_id,video_sequence,video_url,video_name,added_time,file_size,downloaded_size,status) VALUES (?,?,?,?,?,?,?,?,?)",
             [NSNumber numberWithInteger:lecture.lecture_id],
             [NSNumber numberWithInteger:lecture.video_id],
             [NSNumber numberWithInteger:lecture.video_sequence],
             lecture.video_url,
             lecture.video_name,
             lecture.added_time,
             [NSNumber numberWithInteger:lecture.file_size],
             [NSNumber numberWithInteger:lecture.downloaded_size],
             [NSNumber numberWithInteger:lecture.status]
             ];
            
        }
        [downloader addDownloadLecture:lecture];
    }
    
    //print all download record out
    /**
    NSString *query=@"SELECT * FROM topik_download";
    FMResultSet *s = [db executeQuery:query];
    while ([s next]) {
        NSInteger download_id=[s intForColumn:@"download_id"];
        NSInteger lecture_id=[s intForColumn:@"lecture_id"];
        NSInteger video_id=[s intForColumn:@"video_id"];
        NSInteger video_sequence=[s intForColumn:@"video_sequence"];
        NSString *video_url=[s stringForColumn:@"video_url"];
        NSString *video_name=[s stringForColumn:@"video_name"];
        NSString *added_time=[s stringForColumn:@"added_time"];
        NSInteger file_size=[s intForColumn:@"file_size"];
        NSInteger downloaded_size=[s intForColumn:@"downloaded_size"];
        NSInteger status=[s intForColumn:@"status"];
        
        NSLog(@"topik_download: download_id=%d, lecture_id=%d,video_id=%d, video_sequence=%d,  video_url=%@, video_name=%@, added_time=%@, file_size=%d, downloaded_size=%d, status=%d",download_id,lecture_id,video_id,video_sequence,video_url,video_name,added_time,file_size,downloaded_size,status);
    }
    **/
    [db close];
}

+(BOOL)VideoExistInDownload:(NSInteger)videoId{
    BOOL isExist=FALSE;
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"LectureDB.sqlite"];
    //NSLog(@"dbPath:%@",dbPath);
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"VideoExistInDownload Could not open db.");
    }
    else
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT download_id FROM topik_download WHERE video_id=%ld",(long)videoId];
        FMResultSet *s = [db executeQuery:query];
        while ([s next]) {
            isExist=TRUE;
        }
        
    }
    [db close];
    
    return isExist;
}
+(BOOL)FeaturedLectureExistInDownload:(FeaturedLecture*)lecture{
    BOOL isExist=FALSE;
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"LectureDB.sqlite"];
    //NSLog(@"dbPath:%@",dbPath);
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"LectureExistInDownload Could not open db.");
    }
    else
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT download_id FROM topik_download WHERE lecture_id=%ld",(long)lecture.lecture_id];
        FMResultSet *s = [db executeQuery:query];
        while ([s next]) {
            isExist=TRUE;
            break;
        }
        
    }
    [db close];
    
    return isExist;
}
+(void)RemoveVideoFromDownloadByVideoId:(NSInteger)videoId{
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
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM topik_download WHERE video_id=%ld",(long)videoId];
        FMResultSet *s = [db executeQuery:query];
        Downloader*downloader=[Downloader sharedInstance];
        while ([s next]) {
            NSInteger video_id=[s intForColumn:@"video_id"];
            NSString *video_url=[s stringForColumn:@"video_url"];
            NSString *downloadPath=[docsPath stringByAppendingFormat:@"/Lectures/%ld.mp4",(long)video_id];
            NSString *tempPath=[docsPath stringByAppendingFormat:@"/LectureTmp/%ld.download",(long)video_id];
            if([[NSFileManager defaultManager] fileExistsAtPath:downloadPath])
            {
                [[NSFileManager defaultManager] removeItemAtPath:downloadPath error:Nil];
            }
            [downloader removeRequestWithUrl:video_url];
            if([[NSFileManager defaultManager] fileExistsAtPath:tempPath])
            {
                [[NSFileManager defaultManager] removeItemAtPath:tempPath error:Nil];
            }
        }

        NSString *deleteQuery =@"";//@"DELETE FROM user WHERE age = 25";
        deleteQuery=[NSString stringWithFormat:@"DELETE FROM topik_download WHERE video_id=%ld",(long)videoId];
        [db executeUpdate:deleteQuery];
        if ([db hadError]) {
            NSLog(@"RemoveLectureVideoFromDownload:%@ Err %d: %@", @"topik_download",[db lastErrorCode], [db lastErrorMessage]);
        }
    }
    [db close];
}
+(void)RemoveFeaturedLectureFromDownload:(FeaturedLecture*)featuredLecture{
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
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM topik_download WHERE lecture_id=%ld",(long)featuredLecture.lecture_id];
        FMResultSet *s = [db executeQuery:query];
        Downloader*downloader=[Downloader sharedInstance];
        while ([s next]) {
            NSInteger video_id=[s intForColumn:@"video_id"];
            NSString *video_url=[s stringForColumn:@"video_url"];
            NSString *downloadPath=[docsPath stringByAppendingFormat:@"/Lectures/%ld.mp4",(long)video_id];
            NSString *tempPath=[docsPath stringByAppendingFormat:@"/LectureTmp/%ld.download",(long)video_id];
            if([[NSFileManager defaultManager] fileExistsAtPath:downloadPath])
            {
                [[NSFileManager defaultManager] removeItemAtPath:downloadPath error:Nil];
            }
            [downloader removeRequestWithUrl:video_url];
            if([[NSFileManager defaultManager] fileExistsAtPath:tempPath])
            {
                [[NSFileManager defaultManager] removeItemAtPath:tempPath error:Nil];
            }
        }
        
        NSString *deleteQuery =@"";//@"DELETE FROM user WHERE age = 25";
        deleteQuery=[NSString stringWithFormat:@"DELETE FROM topik_download WHERE lecture_id=%ld",(long)featuredLecture.lecture_id];
        [db executeUpdate:deleteQuery];
        if ([db hadError]) {
            NSLog(@"Clear Table:%@ Err %d: %@", @"topik_download",[db lastErrorCode], [db lastErrorMessage]);
        }
    }
    [db close];

}
+(BOOL)LectureVideoExistInDownload:(LectureVideo*)video
{
    BOOL isExist=FALSE;
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"LectureDB.sqlite"];
    //NSLog(@"dbPath:%@",dbPath);
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"LectureExistInDownload Could not open db.");
    }
    else
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT download_id FROM topik_download WHERE video_id=%ld",(long)video.video_id];
        FMResultSet *s = [db executeQuery:query];
        while ([s next]) {
            isExist=TRUE;
            break;
        }
        
    }
    [db close];
    
    return isExist;
}
+(void)RemoveLectureVideoFromDownload:(LectureVideo*)video{
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
        Downloader* downloader=[Downloader sharedInstance];
        NSString *video_url=video.video_file;
        NSString *downloadPath=[docsPath stringByAppendingFormat:@"/Lectures/%ld.mp4",(long)video.video_id];
        NSString *tempPath=[docsPath stringByAppendingFormat:@"/LectureTmp/%ld.download",(long)video.video_id];
        if([[NSFileManager defaultManager] fileExistsAtPath:downloadPath])
        {
            [[NSFileManager defaultManager] removeItemAtPath:downloadPath error:Nil];
        }
        [downloader removeRequestWithUrl:video_url];
        if([[NSFileManager defaultManager] fileExistsAtPath:tempPath])
        {
            [[NSFileManager defaultManager] removeItemAtPath:tempPath error:Nil];
        }

        
        deleteQuery=[NSString stringWithFormat:@"DELETE FROM topik_download WHERE video_id=%ld",(long)video.video_id];
        [db executeUpdate:deleteQuery];
        if ([db hadError]) {
            NSLog(@"RemoveLectureVideoFromDownload:%@ Err %d: %@", @"topik_download",[db lastErrorCode], [db lastErrorMessage]);
        }
        
        
    }
    [db close];
    
}
#pragma mark-MyLectures DataSource
+(void)updateFileSizeForVideoID:(NSInteger)videoID withFileSize:(long long)totalSize{
    NSString *updateQuery=[NSString stringWithFormat:@"Update topik_download SET file_size=%lli WHERE video_id=%ld",totalSize,(long)videoID];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"LectureDB.sqlite"];
    //NSLog(@"dbPath:%@",dbPath);
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    else
    {
        [db executeUpdate:updateQuery];
        if ([db hadError]) {
            NSLog(@"updateFileSizeForVideoID:%@ Err %d: %@", @"topik_download",[db lastErrorCode], [db lastErrorMessage]);
        }
    }
    [db close];
    
}
+(void)updateDownloadStatusForVideoID:(NSInteger)videoID withStatus:(NSInteger)status{
    NSString *updateQuery=[NSString stringWithFormat:@"Update topik_download SET status=%ld WHERE video_id=%ld",(long)status,(long)videoID];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"LectureDB.sqlite"];
    //NSLog(@"dbPath:%@",dbPath);
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    else
    {
        [db executeUpdate:updateQuery];
        if ([db hadError]) {
            NSLog(@"updateDownloadStatusForDownloadID:%@ Err %d: %@", @"topik_download",[db lastErrorCode], [db lastErrorMessage]);
        }
    }
    [db close];

}
+(void)updateDownloadStatusForDownloadID:(NSInteger)downloadId withStatus:(NSInteger)status
{
    NSString *updateQuery=[NSString stringWithFormat:@"Update topik_download SET status=%ld WHERE download_id=%ld",(long)status,(long)downloadId];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"LectureDB.sqlite"];
    //NSLog(@"dbPath:%@",dbPath);
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    else
    {
        [db executeUpdate:updateQuery];
        if ([db hadError]) {
            NSLog(@"updateDownloadStatusForDownloadID:%@ Err %d: %@", @"topik_download",[db lastErrorCode], [db lastErrorMessage]);
        }
    }
    [db close];
}
+(NSMutableArray *)loadDownloadingListData{
    NSMutableArray *downloadList=[[NSMutableArray alloc] init];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"LectureDB.sqlite"];
    //NSLog(@"dbPath:%@",dbPath);
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    else
    {
        
        //status==0 prepare
        //status==1 downloading
        //status==2 fail
        //status==3 done
        NSString *query=@"SELECT * FROM topik_download WHERE status!=3 ORDER BY download_id ASC";
        FMResultSet *innerS = [db executeQuery:query];
            while ([innerS next]) {
                NSInteger download_id=[innerS intForColumn:@"download_id"];
                NSInteger lecture_id=[innerS intForColumn:@"lecture_id"];
                NSInteger video_id=[innerS intForColumn:@"video_id"];
                NSString *video_name=[innerS stringForColumn:@"video_name"];
                NSInteger video_sequence=[innerS intForColumn:@"video_sequence"];
                NSString *video_url=[innerS stringForColumn:@"video_url"];
                NSString *added_time=[innerS stringForColumn:@"added_time"];
                NSInteger file_size=[innerS intForColumn:@"file_size"];
                NSInteger downloaded_size=[innerS intForColumn:@"downloaded_size"];
                NSInteger status=[innerS intForColumn:@"status"];
                DownloadLecture* video=[[DownloadLecture alloc] initWithDownloadId:download_id LectureId:lecture_id VideoId:video_id VideoSequence:video_sequence VideoUrl:video_url VideoName:video_name AddedTime:added_time FileSize:file_size DownloadedSize:downloaded_size Status:status];
                //NSLog(@"download id:%d",download_id);
                [downloadList addObject:video];
            }
    }
    [db close];
    
    return downloadList;
}
+(NSMutableArray *)loadDownloadingVideoListForFeaturedLecture:(FeaturedLecture*)lecture{
    NSMutableArray *videos=[[NSMutableArray alloc] init];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"LectureDB.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    else
    {
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM topik_download WHERE lecture_id=%ld ORDER BY video_sequence ASC",(long)lecture.lecture_id];
        FMResultSet *innerS = [db executeQuery:query];
        while ([innerS next]) {
            NSInteger download_id=[innerS intForColumn:@"download_id"];
            //NSInteger lecture_id=[innerS intForColumn:@"lecture_id"];
            NSInteger video_id=[innerS intForColumn:@"video_id"];
            NSString *video_name=[innerS stringForColumn:@"video_name"];
            NSInteger video_sequence=[innerS intForColumn:@"video_sequence"];
            NSString *video_url=[innerS stringForColumn:@"video_url"];
            NSString *added_time=[innerS stringForColumn:@"added_time"];
            NSInteger file_size=[innerS intForColumn:@"file_size"];
            NSInteger downloaded_size=[innerS intForColumn:@"downloaded_size"];
            NSInteger status=[innerS intForColumn:@"status"];
            DownloadLecture* video=[[DownloadLecture alloc] initWithDownloadId:download_id LectureId:lecture.lecture_id VideoId:video_id VideoSequence:video_sequence VideoUrl:video_url VideoName:video_name AddedTime:added_time FileSize:file_size DownloadedSize:downloaded_size Status:status];
            [videos addObject:video];
            
        }

    }
    [db close];
    return videos;
}
+(DownloadListData *)loadDownloadListData{
    DownloadListData *listData=[[DownloadListData alloc] init];
     listData.lectureArray=[[NSMutableArray alloc] init];
    listData.lectureDictionary=[[NSMutableDictionary alloc] init];
    listData.videoLectureDictionary=[[NSMutableDictionary alloc] init];
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"LectureDB.sqlite"];
    //NSLog(@"dbPath:%@",dbPath);
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    else
    {
        NSString *query=@"SELECT DISTINCT lecture_id FROM topik_download ORDER BY download_id DESC";
        FMResultSet *s = [db executeQuery:query];
        while ([s next]) {
            NSInteger download_id=[s intForColumn:@"download_id"];
            NSInteger lecture_id=[s intForColumn:@"lecture_id"];
             NSString * lecture_title=@"";
            NSLog(@"topik_download: download_id=%ld, lecture_id=%ld",(long)download_id,(long)lecture_id);
            //get lecture information
            //CREATE TABLE topik_lecture_basic(lecture_id integer,lecture_title text,lecture_lang integer,lecture_type integer,lecture_level integer,lecture_exam integer, lecture_status integer, lecture_created text, lecture_updated text);
            NSString *innerQuery=[NSString stringWithFormat:@"SELECT lecture_title FROM topik_lecture_basic WHERE lecture_id=%ld",(long)lecture_id];;
            FMResultSet *innerS = [db executeQuery:innerQuery];
            while ([innerS next]) {
               lecture_title=[innerS stringForColumn:@"lecture_title"];
                break;
            }
            NSString *lecture_id_str=[NSString stringWithFormat:@"%ld",(long)lecture_id];
            [listData.lectureArray addObject:[NSNumber numberWithInteger:lecture_id]];
            [listData.lectureDictionary setObject:lecture_title forKey:lecture_id_str];
            
            innerQuery=[NSString stringWithFormat:@"SELECT * FROM topik_download WHERE lecture_id=%ld ORDER BY video_sequence ASC",(long)lecture_id];
            innerS = [db executeQuery:innerQuery];
            NSMutableArray *videos=[[NSMutableArray alloc] init];
            while ([innerS next]) {
                NSInteger download_id=[innerS intForColumn:@"download_id"];
                //NSInteger lecture_id=[innerS intForColumn:@"lecture_id"];
                NSInteger video_id=[innerS intForColumn:@"video_id"];
                NSString *video_name=[innerS stringForColumn:@"video_name"];
                NSInteger video_sequence=[innerS intForColumn:@"video_sequence"];
                NSString *video_url=[innerS stringForColumn:@"video_url"];
                NSString *added_time=[innerS stringForColumn:@"added_time"];
                NSInteger file_size=[innerS intForColumn:@"file_size"];
                NSInteger downloaded_size=[innerS intForColumn:@"downloaded_size"];
                NSInteger status=[innerS intForColumn:@"status"];
                DownloadLecture* video=[[DownloadLecture alloc] initWithDownloadId:download_id LectureId:lecture_id VideoId:video_id VideoSequence:video_sequence VideoUrl:video_url VideoName:video_name AddedTime:added_time FileSize:file_size DownloadedSize:downloaded_size Status:status];
                [videos addObject:video];
                
            }
            [listData.videoLectureDictionary setObject:videos forKey:lecture_id_str];

        }

    }
    [db close];
    
    return listData;
}

+(void)updateDownloadProgressFromDisk{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *downloadPath = [docsPath stringByAppendingPathComponent:@"Lectures"];
    NSString *tmpPath = [docsPath stringByAppendingPathComponent:@"LectureTmp"];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"LectureDB.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    NSString *updateStatusQuery=@"";
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
    //Downloaded Files
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:downloadPath error:NULL];
    int count=0;
    NSString *fileName=@"";
     NSString *videoIDString=@"";
    NSInteger videoId=0;
    for (count = 0; count < (int)[directoryContent count]; count++)
    {
        fileName=[directoryContent objectAtIndex:count];
        if([fileName hasSuffix:@".mp4"])
        {
            //NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
            //update video status to Done status
            fileName=[directoryContent objectAtIndex:count];
            videoIDString=[fileName substringToIndex:([fileName length]-4)];
            videoId=[videoIDString intValue];
            
            updateStatusQuery=[NSString stringWithFormat:@"Update topik_download SET status=%d WHERE video_id=%ld",kDownloadFinishedStatus,(long)videoId];
            //[RemoteData updateDownloadStatusForVideoID:(NSInteger)videoID withStatus:(NSInteger)status
            [db executeUpdate:updateStatusQuery];
            if ([db hadError]) {
                NSLog(@"updateDownloadProgressFromDisk:%@ Err %d: %@", @"topik_download",[db lastErrorCode], [db lastErrorMessage]);
            }
        }
    }
    
    //Tmp files
    directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:tmpPath error:NULL];
    count=0;
    fileName=@"";
    videoIDString=@"";
    videoId=0;
    NSString *downloadTempPath=@"";
    for (count = 0; count < (int)[directoryContent count]; count++)
    {
        fileName=[directoryContent objectAtIndex:count];
        if([fileName hasSuffix:@".download"])
        {
            //NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
            //update video status to Done status
            fileName=[directoryContent objectAtIndex:count];
            videoIDString=[fileName substringToIndex:([fileName length]-9)];
            videoId=[videoIDString intValue];
            
            updateStatusQuery=[NSString stringWithFormat:@"Update topik_download SET status=%d WHERE video_id=%ld",kDownloadDownloadingStatus,(long)videoId];
            //[RemoteData updateDownloadStatusForVideoID:(NSInteger)videoID withStatus:(NSInteger)status
            [db executeUpdate:updateStatusQuery];
            if ([db hadError]) {
                NSLog(@"updateDownloadProgressFromDisk:%@ Err %d: %@", @"topik_download",[db lastErrorCode], [db lastErrorMessage]);
            }
            
            //update downloaded file size
            downloadTempPath=[tmpPath stringByAppendingFormat:@"/%ld.download",(long)videoId];
            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:downloadTempPath error: NULL];
            {
                if(attrs!=nil)
                {
                    unsigned long long size = [attrs fileSize];
                    updateStatusQuery=[NSString stringWithFormat:@"Update topik_download SET downloaded_size=%lli WHERE video_id=%ld",size,(long)videoId];
                    NSLog(@"%@",updateStatusQuery);
                    //[RemoteData updateDownloadStatusForVideoID:(NSInteger)videoID withStatus:(NSInteger)status
                    [db executeUpdate:updateStatusQuery];
                    if ([db hadError]) {
                        NSLog(@"updateDownloadProgressFromDisk:%@ Err %d: %@", @"topik_download",[db lastErrorCode], [db lastErrorMessage]);
                    }

                }
            }

        }
    }

    
    [db close];
}
@end
