//
//  Downloader.h
//  Topik
//
//  Created by Lee Haining on 13-12-3.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "DownloadLecture.h"
#define kDownloadProgressNotification @"DownloadProgressNotification"
#define kDownloadToStartStatus 0
#define kDownloadDownloadingStatus 1
#define kDownloadFinishedStatus 3
#define kDownloadFailedStatus 2
@interface Downloader : NSObject<ASIProgressDelegate>
+ (id)sharedInstance;
-(void)clearDownloadQueue;
-(BOOL)isDownloading;
-(void)getInterruptedDownloadsAndResume;
-(void)removeRequestWithUrl:(NSString *)url;
-(void)addDownloadLecture:(DownloadLecture*)lecture;
@end
