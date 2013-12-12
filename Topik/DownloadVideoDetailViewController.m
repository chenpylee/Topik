//
//  DownloadVideoDetailViewController.m
//  Topik
//
//  Created by Lee Haining on 13-12-1.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "DownloadVideoDetailViewController.h"
#import "FeaturedVideoDetailViewController.h"
#import "AppConfig.h"
#import "RemoteData.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"
#import "RemoteData.h"
#import "UIImageView+WebCache.h"
@interface DownloadVideoDetailViewController ()
{
    MPMoviePlayerViewController *player;
    __weak IBOutlet UILabel *previewLabel;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UIButton *downloadButton;
    Reachability *internetReach;
}
@property (weak, nonatomic) IBOutlet UIView *videoSuper;
@end

@implementation DownloadVideoDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIColor* tabBarTintColor=[AppConfig getTabBarTintColor];
    self.navigationController.navigationBar.tintColor = tabBarTintColor;
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    tabBarTintColor, NSForegroundColorAttributeName,nil];
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    
    self.navigationItem.title=NSLocalizedString(@"Video Detail", nil);
    [self updateVideoMode];
    titleLabel.text=self.selectedVideo.video_name;
    [self updateDownloadButton];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Download Video Detail"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
-(void) setupVideoPlay{
    self.lecture=[RemoteData getFeaturedLectureByLectureID:self.selectedVideo.lecture_id];
    self.placeHolderLv1=[UIImage imageNamed:@"topik_placeholder_1.png"];
    self.placeHolderLv2=[UIImage imageNamed:@"topik_placeholder_2.png"];
    self.placeHolderLv3=[UIImage imageNamed:@"topik_placeholder_3.png"];
    self.placeHolderLv4=[UIImage imageNamed:@"topik_placeholder_4.png"];
    UIImage *placeholder=nil;
    switch (self.lecture.level_id) {
        case 1:
            placeholder=self.placeHolderLv1;
            break;
        case 2:
            placeholder=self.placeHolderLv2;
            break;
        case 3:
            placeholder=self.placeHolderLv3;
            break;
        case 4:
            placeholder=self.placeHolderLv4;
            break;
        default:
            placeholder=self.placeHolderLv4;
            break;
    }
    if(![self.lecture.lecture_img_url isEqualToString:@""])
    {
        [self.videoImageView setImageWithURL:[NSURL URLWithString:self.lecture.lecture_img_url]
                            placeholderImage:placeholder];
    }
    else
    {
        self.videoImageView.image=placeholder;
    }
    
    [self.videoSuper bringSubviewToFront:self.videoImageView];
    [self.videoSuper bringSubviewToFront:self.videoPlayButton];
}
- (IBAction)checkAndPlay:(id)sender{
    
    internetReach=[Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    NetworkStatus netStatus=[internetReach currentReachabilityStatus];
    switch(netStatus)
    {
        case ReachableViaWiFi:
        {
            NSLog(@"Current NetStatus:%@",@"Wifi connected");
            [self playVideo];
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"Current NetStatus:%@",@"WWAN connected");
            if([AppConfig isInDebugMode])//for review, 3G/GPRS is not allowed
            {
                [self showForbiddenMsg];
            }
            else
            {
                [self showOptionMsg];
            }
            break;
        }
        case NotReachable:
        {
            NSLog(@"Current NetStatus:%@",@"Not connected");
            [self showForbiddenMsg];
            break;
        }
        default:
            break;
    }
    
}
-(void)showForbiddenMsg{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Check Network", nil)
                                                      message:NSLocalizedString(@"Wifi Only", nil)
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}
-(void)showOptionMsg{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Check Network", nil)
                                                      message:NSLocalizedString(@"3G and continue", nil)
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"Abort", nil)
                                            otherButtonTitles:NSLocalizedString(@"Continue Playing", nil),nil];
    message.tag=20;
    [message show];
}

-(void)playVideo{
    NSURL* url=[NSURL URLWithString:self.selectedVideo.video_url];
    player= [[MPMoviePlayerViewController alloc] init];
    [player.moviePlayer setFullscreen:NO];
    player.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
    [player.moviePlayer setContentURL:url];
    player.moviePlayer.controlStyle =MPMovieControlStyleEmbedded;
    [player.moviePlayer.view setFrame:self.videoSuper.bounds];
    [player.moviePlayer setScalingMode:MPMovieScalingModeAspectFit];
    [player.moviePlayer setShouldAutoplay:TRUE];
    [player.moviePlayer prepareToPlay];
    [self.videoSuper addSubview:player.moviePlayer.view];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)updateDownloadButton{
    downloadButton.selected=[RemoteData VideoExistInDownload:self.selectedVideo.video_id];
}
- (IBAction)updateDownload:(id)sender{
    [self insertDownload];
}
-(void)updateVideoMode{
    //clear videoSuper view
    NSFileManager *fm;
    /**
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    **/
    NSString *directoryPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    
    NSString *filePath = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Lectures/%ld.mp4",(long)self.selectedVideo.video_id]];
    NSLog(@"video path:%@",filePath);
    fm=[NSFileManager defaultManager];
    if([fm fileExistsAtPath:filePath])
    {
        NSURL* url=[NSURL fileURLWithPath:filePath];
        player= [[MPMoviePlayerViewController alloc] init];
        [player.moviePlayer setFullscreen:NO];
        player.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        [player.moviePlayer setContentURL:url];
        player.moviePlayer.controlStyle =MPMovieControlStyleEmbedded;
        [player.moviePlayer.view setFrame:self.videoSuper.bounds];
        [player.moviePlayer setScalingMode:MPMovieScalingModeAspectFit];
        [player.moviePlayer setShouldAutoplay:FALSE];
        [player.moviePlayer prepareToPlay];
        NSLog(@"video found @ path:%@",filePath);
        previewLabel.text=NSLocalizedString(@"Downloaded Video:", nil);
        [self.videoSuper addSubview:player.moviePlayer.view];
    }
    else
    {
        [self setupVideoPlay];
        previewLabel.text=NSLocalizedString(@"Online Streaming:", nil);
    }
    
    //[movie play];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterFullScreen:)
                                                 name:MPMoviePlayerWillEnterFullscreenNotification
                                               object:nil];
    //[movie play];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willExitFullScreen:)
                                                 name:MPMoviePlayerWillExitFullscreenNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willExitFullScreen:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
}
-(void)willEnterFullScreen:(NSNotification*)aNotification{
    NSLog(@"willEnterFullScreen");
    AppDelegate* delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.needLanspace=YES;
}
-(void)willExitFullScreen:(NSNotification*)aNotification{
    NSLog(@"willExitFullScreen");
    AppDelegate* delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.needLanspace=FALSE;
}

-(void)dealloc{
    NSLog(@"FeaturedVideoDetailViewController dealloc+++++++++++++++++++++");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)insertDownload{
    if(![RemoteData VideoExistInDownload:self.selectedVideo.video_id])
    {
        
        UIAlertView* addAlert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Download Video:", nil) message:NSLocalizedString(@"Do you want to download this video?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Download", nil), nil];
        addAlert.tag=10;
        [addAlert show];
        
    }
    else
    {
        UIAlertView* addAlert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Download Video:", nil) message:NSLocalizedString(@"You can remove this video from download list?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil)  otherButtonTitles:NSLocalizedString(@"Remove it", nil), nil];
        addAlert.tag=11;
        [addAlert show];
        
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==20)
    {
        [self playVideo];
        return;
    }
    if(alertView.tag==10)
    {
        switch(buttonIndex)
        {
            case 0:
                return;
                break;
            case 1:
                [RemoteData InsertSingleDowloadVideoDownload:self.selectedVideo];
                break;
            default:
                return;
                break;
        }
    }
    if(alertView.tag==11)
    {
        switch(buttonIndex)
        {
            case 0:
                return;
                break;
            case 1:
                [RemoteData RemoveVideoFromDownloadByVideoId:self.selectedVideo.video_id];
                break;
            default:
                break;
        }
    }
    [self updateDownloadButton];
}


@end
