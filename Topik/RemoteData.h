//
//  RemoteData.h
//  Topik
//
//  Created by Lee Haining on 13-11-25.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"
#import "FeaturedLecture.h"
#import "LectureVideo.h"
#import "DownloadListData.h"
#import "DownloadLecture.h"
#import "FreeLecture.h"
#define kAppIsInDebugMode @"IS_DEBUG_MODE"
@interface RemoteData : NSObject
+(BOOL)processTotalJsonData:(NSData *)data;
+(NSMutableArray *)loadFeaturedLecturesToArray;
+(NSMutableArray*)loadFeaturedLecturesToArrayByLang:(NSInteger)lang_id;
+(NSMutableArray*)loadFreeLecturesToArrayByLang:(NSInteger)lang_id;
+(NSMutableArray *)loadFreeLecturesToArray;
+(NSMutableArray *)loadBookmarkLecturesToArray;
+(void)InsertFeaturedLectureBookmark:(FeaturedLecture*)featuredLecture;
+(BOOL)FeaturedLectureExistsInBookmark:(FeaturedLecture*)featuredLecture;
+(void)RemoveFeaturedLectureFromBookmark:(FeaturedLecture*)featuredLecture;
+(void)InsertFeaturedLectureVideoDownload:(FeaturedLecture*)featuredLecture;
+(BOOL)FeaturedLectureExistInDownload:(FeaturedLecture*)lecture;
+(void)RemoveFeaturedLectureFromDownload:(FeaturedLecture*)featuredLecture;
+(BOOL)LectureVideoExistInDownload:(LectureVideo*)video;
+(BOOL)VideoExistInDownload:(NSInteger)videoId;
+(void)InsertSingleFeaturedLectureVideoDownload:(FeaturedLecture*)featuredLecture indexAt:(NSInteger)videoIndex;
+(void)InsertSingleDowloadVideoDownload:(DownloadLecture*)downloadVideo;
+(void)RemoveLectureVideoFromDownload:(LectureVideo*)video;
+(void)RemoveVideoFromDownloadByVideoId:(NSInteger)videoId;
+(DownloadListData *)loadDownloadListData;
+(NSMutableArray *)loadDownloadingListData;
+(void)updateDownloadStatusForDownloadID:(NSInteger)downloadId withStatus:(NSInteger)status;
+(void)updateDownloadStatusForVideoID:(NSInteger)videoID withStatus:(NSInteger)status;
+(void)updateFileSizeForVideoID:(NSInteger)videoID withFileSize:(long long)totalSize;
+(void)updateDownloadProgressFromDisk;
+(NSMutableArray *)loadDownloadingVideoListForFeaturedLecture:(FeaturedLecture*)lecture;
+(BOOL)FreeLectureExistsInBookmark:(FreeLecture*)freeLecture;
+(void)InsertFreeLectureBookmark:(FreeLecture*)freeLecture;
+(void)RemoveFreeLectureFromBookmark:(FreeLecture*)freeLecture;
+(void)RemoveBookmarkByLectureId:(NSInteger)lecture_id isPaid:(BOOL)is_paid;
+(FeaturedLecture*)getFeaturedLectureByLectureID:(NSInteger)lecture_id;
+(FreeLecture*)getFreeLectureByLectureID:(NSInteger)lecture_id;
+(NSMutableArray*)loadLanguagesToArray;
@end
