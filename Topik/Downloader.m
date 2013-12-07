//
//  Downloader.m
//  Topik
//
//  Created by Lee Haining on 13-12-3.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "Downloader.h"
#import "DownloadLecture.h"
#import "RemoteData.h"
#import "DownloadProgress.h"

#define kDownloadKeyVideoId @"videoID"
#define kDownloadKeyLectureId @"lectureID"
#define kDownloadKeyDownloadId @"downloadId"
#define kDownloadKeyURL @"URL"
#define kDownloadKeyStartTime @"startTime"
#define kDownloadKeyTotalSize @"totalSize"
#define kDownloadKeyDownloadedSize @"downloadSize"
#define kDownloadKeyConnection @"connection"
#define kDownloadKeyFileName @"fileName"
#define kDownloadKeyFileHandle @"fileHandle"
@interface Downloader(){
    NSMutableArray *_downloadingArray;
    
    NSString *_downloadDirectory;
    NSString *_downloadTempDirectory;
    
    NSOperationQueue *_downloadingRequestsQueue;
    
    int _objectAtIndex;
}
@end
@implementation Downloader
+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] initWithEmptyQueue]; // or some other init method
    });
    return _sharedObject;
}
-(void) dealloc
{
    
	while (_downloadingArray.count > 0)
        [self removeRequestAtIndex:0];
    
}
-(void)clearDownloadQueue{
    [_downloadingRequestsQueue cancelAllOperations];
    [_downloadingArray removeAllObjects];
}
-(BOOL)isDownloading{
    return _downloadingRequestsQueue.operationCount>0;
}
-(id)initWithEmptyQueue{
    if(self=[super init])
    {
        _downloadingArray=[[NSMutableArray alloc] init];
        [_downloadingArray removeAllObjects];
        
        NSArray *documentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);//NSUserDomainMask: user's home directory --- place to install user's personal items (~)
        NSString *documentsDirectory = [documentPaths objectAtIndex:0];
        _downloadDirectory=[documentsDirectory stringByAppendingString:@"/Lectures"];
        [self createDirectoryIfNotExistAtPath:_downloadDirectory];
        
        _downloadTempDirectory=[documentsDirectory stringByAppendingString:@"/LectureTmp"];
        [self createDirectoryIfNotExistAtPath:_downloadTempDirectory];
        
        _downloadingRequestsQueue=[[NSOperationQueue alloc] init];
        _downloadingRequestsQueue.maxConcurrentOperationCount=3;
    }
    return self;
}
-(void)createDirectoryIfNotExistAtPath:(NSString *)path
{
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
    if(error)
        NSLog(@"Downloader Error while creating directory %@",[error localizedDescription]);
}
-(void)addDownloadLecture:(DownloadLecture*)lecture{
    BOOL isDownloading=FALSE;
    for(ASIHTTPRequest *req in _downloadingArray)
    {
        if([[req.url absoluteString] isEqualToString:lecture.video_url])
        {
            isDownloading=TRUE;
            break;
        }
    }
    if(!isDownloading)
    {
        NSURL *url=[NSURL URLWithString:lecture.video_url];
        ASIHTTPRequest *_request = [[ASIHTTPRequest alloc] initWithURL:url];
        __unsafe_unretained ASIHTTPRequest *request = _request;
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [request setUserInfo:dictionary];
        [[request userInfo] setValue:[NSNumber numberWithInteger:lecture.video_id] forKey:kDownloadKeyVideoId];
        [[request userInfo] setValue:[NSNumber numberWithInteger:lecture.lecture_id] forKey:kDownloadKeyLectureId];
        NSString *downloadPath=[_downloadDirectory stringByAppendingFormat:@"/%ld.mp4",(long)lecture.video_id];
        NSString *downloadTempPath=[_downloadTempDirectory stringByAppendingFormat:@"/%ld.download",(long)lecture.video_id];
        [request setDownloadDestinationPath:downloadPath];
        // This file has part of the download in it already
        [request setTemporaryFileDownloadPath:downloadTempPath];
        
        NSNumber* totalSize=[NSNumber numberWithInteger:0];
        [[request userInfo] setValue:totalSize forKey:kDownloadKeyTotalSize];
        [[request userInfo] setValue:[NSNumber numberWithInteger:0] forKey:kDownloadKeyDownloadedSize];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:downloadTempPath error: NULL];
        {
            if(attrs!=nil)
            {
                unsigned long long size = [attrs fileSize];
                NSString* range = @"bytes=";
                range = [range stringByAppendingString:[[NSNumber numberWithUnsignedLongLong:size] stringValue]];
                range = [range stringByAppendingString:@"-"];
                [request addRequestHeader:@"Range" value:range];
                
            }
        }
        
        [request setAllowResumeForFileDownloads:YES];
        [RemoteData updateDownloadStatusForVideoID:lecture.video_id withStatus:kDownloadDownloadingStatus];
        [self addDownloadRequest:request];
    }
}
-(void)getInterruptedDownloadsAndResume{
    //get undone download list from DB
    NSMutableArray *downloadingList=[RemoteData loadDownloadingListData];
    for(DownloadLecture* lecture in downloadingList)
    {
                BOOL isDownloading=FALSE;
        for(ASIHTTPRequest *req in _downloadingArray)
        {
            if([[req.url absoluteString] isEqualToString:lecture.video_url])
            {
                isDownloading=TRUE;
                break;
            }
        }
        if(!isDownloading)
        {
            NSLog(@"video_url:%@",lecture.video_url);
            NSURL *url=[NSURL URLWithString:lecture.video_url];
            ASIHTTPRequest *_request = [[ASIHTTPRequest alloc] initWithURL:url];
            __unsafe_unretained ASIHTTPRequest *request = _request;
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            [request setUserInfo:dictionary];
            [[request userInfo] setValue:[NSNumber numberWithInteger:lecture.video_id] forKey:kDownloadKeyVideoId];
            [[request userInfo] setValue:[NSNumber numberWithInteger:lecture.lecture_id] forKey:kDownloadKeyLectureId];
            NSString *downloadPath=[_downloadDirectory stringByAppendingFormat:@"/%ld.mp4",(long)lecture.video_id];
            NSString *downloadTempPath=[_downloadTempDirectory stringByAppendingFormat:@"/%ld.download",(long)lecture.video_id];
            [request setDownloadDestinationPath:downloadPath];
            // This file has part of the download in it already
            [request setTemporaryFileDownloadPath:downloadTempPath];
            
            NSNumber* totalSize=[NSNumber numberWithInteger:lecture.file_size];
            [[request userInfo] setValue:totalSize forKey:kDownloadKeyTotalSize];
            [[request userInfo] setValue:[NSNumber numberWithInteger:0] forKey:kDownloadKeyDownloadedSize];
            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:downloadTempPath error: NULL];
            {
                if(attrs!=nil)
                {
                    unsigned long long size = [attrs fileSize];
                    NSString* range = @"bytes=";
                    range = [range stringByAppendingString:[[NSNumber numberWithUnsignedLongLong:size] stringValue]];
                    range = [range stringByAppendingString:@"-"];
                    [request addRequestHeader:@"Range" value:range];
                    
                }
            }
            
            [request setAllowResumeForFileDownloads:YES];
            [RemoteData updateDownloadStatusForVideoID:lecture.video_id withStatus:kDownloadDownloadingStatus];
            [self addDownloadRequest:request];
        }

        
    }
    
}
-(void)addDownloadRequest:(ASIHTTPRequest*)request{
    [request setDelegate:self];
    [request setDownloadProgressDelegate:self];
    [request setAllowResumeForFileDownloads:YES];
    [request setShouldContinueWhenAppEntersBackground:YES];
    [request setNumberOfTimesToRetryOnTimeout:100];
    [request setTimeOutSeconds:20.0];
    [[request userInfo] setValue:request.url forKey:kDownloadKeyURL];
    [[request userInfo] setValue:request.connectionID forKey:kDownloadKeyConnection];
    if(![request requestHeaders])
    {
        BOOL success = [[NSFileManager defaultManager] createFileAtPath:[request temporaryFileDownloadPath] contents:Nil attributes:Nil];
        if(!success)
            NSLog(@"Failed to create file");
    }
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    
	[_downloadingArray addObject:request];
    if(!_downloadingRequestsQueue)
        _downloadingRequestsQueue = [[NSOperationQueue alloc] init];
    //[RemoteData updateDownloadStatusForDownloadID:<#(NSInteger)#> withStatus:<#(NSInteger)#>];
    [_downloadingRequestsQueue addOperation:request];
    //update download status
    
}
-(void)removeRequestWithUrl:(NSString *)url{
    for(ASIHTTPRequest *req in _downloadingArray)
    {
        if([[req.url absoluteString] isEqualToString:url])
        {
            [_downloadingArray removeObject:req];
            NSString *downloadPath=req.downloadDestinationPath;
            NSString *tempPath=req.temporaryFileDownloadPath;
            [req cancel];
            if([[NSFileManager defaultManager] fileExistsAtPath:downloadPath])
            {
                [[NSFileManager defaultManager] removeItemAtPath:downloadPath error:Nil];
            }
            if([[NSFileManager defaultManager] fileExistsAtPath:tempPath])
            {
                [[NSFileManager defaultManager] removeItemAtPath:tempPath error:Nil];
            }
            break;
        }
    }
    
}
-(void)removeRequestAtIndex:(NSInteger)index
{
    ASIHTTPRequest *req=[_downloadingArray objectAtIndex:index];
    [req cancel];
    [_downloadingArray removeObjectAtIndex:index];
}
#pragma mark - ASIHTTPRequest Delegate -
-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSLog(@"response headers %@",responseHeaders);
    for(ASIHTTPRequest *req in _downloadingArray)
    {
        if([req isEqual:request])
        {
            long long length = [[[req userInfo] objectForKey:kDownloadKeyTotalSize] longLongValue];
            if(length == 0)
            {
                length = [req contentLength];
                if (length != NSURLResponseUnknownLength)
                {
                    NSNumber *totalSize = [NSNumber numberWithUnsignedLongLong:(unsigned long long)length];
                    [[req userInfo] setValue:totalSize forKey:kDownloadKeyTotalSize];
                    NSNumber* video_id_number=[[req userInfo] objectForKey:kDownloadKeyVideoId];
                    [RemoteData updateFileSizeForVideoID:[video_id_number intValue] withFileSize:length];
                    NSLog(@"video_id:%d file_size:%lli",[video_id_number intValue],length);
                }
                [[req userInfo] setValue:[NSDate date] forKey:kDownloadKeyStartTime];
            }
            
			break;
        }
    }
}


- (void)requestDone:(ASIHTTPRequest *)request
{
    NSLog(@"request success: %@ userInfo: %@",[request responseString],request.userInfo);
    
    
    NSInteger index = -1;
    NSMutableDictionary *userInfo = nil;
    for (ASIHTTPRequest *req in _downloadingArray)
    {
        if ([req isEqual:request])
        {
            userInfo = [NSMutableDictionary dictionaryWithDictionary:[req userInfo]];
            index = [_downloadingArray indexOfObject:req];
            NSInteger video_id=[(NSNumber*)[userInfo objectForKey:kDownloadKeyVideoId] intValue];
            [RemoteData updateDownloadStatusForVideoID:video_id withStatus:kDownloadFinishedStatus];
            break;
        }
    }
    if (index != -1)
    {
        [self removeRequestAtIndex:index];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"request failed: %@ userInfo: %@",[request.error localizedDescription],request.userInfo);
    
    NSInteger index = -1;
    NSMutableDictionary *userInfo = nil;
    for (ASIHTTPRequest *req in _downloadingArray)
    {
        if ([req isEqual:request])
        {
            userInfo = [NSMutableDictionary dictionaryWithDictionary:[req userInfo]];
            index = [_downloadingArray indexOfObject:req];
            break;
        }
    }
    if (index != -1)
    {
        [self removeRequestAtIndex:index];
    }
}
-(void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    //NSLog(@"didReceiveBytes:%lli",bytes);
    //NSLog(@"totalBytesRead:%lli",request.totalBytesRead);//progress
    NSNumber* totalSize=[[request userInfo] objectForKey:kDownloadKeyTotalSize];
    NSNumber* downloaedSize=[[request userInfo] objectForKey:kDownloadKeyDownloadedSize];
    DownloadProgress *progress=[[DownloadProgress alloc] init];
    progress.totalSize=[totalSize unsignedLongLongValue];
    progress.received=[downloaedSize unsignedLongLongValue]+bytes;
    [[request userInfo] setValue:[NSNumber numberWithUnsignedLongLong:progress.received] forKey:kDownloadKeyDownloadedSize];
    NSNumber* video_id_number=[[request userInfo] valueForKey:kDownloadKeyVideoId];
    NSNumber* lecture_id_number=[[request userInfo] valueForKey:kDownloadKeyLectureId];
    progress.video_id=[video_id_number intValue];
    progress.lecture_id=[lecture_id_number intValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadProgressNotification object:self userInfo:[NSDictionary dictionaryWithObject:progress forKey:@"progress"]];
    
}
@end
