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
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"
#import "RemoteData.h"
@interface DownloadVideoDetailViewController ()
{
    MPMoviePlayerViewController *player;
    __weak IBOutlet UILabel *previewLabel;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UIButton *downloadButton;
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
    for(id subView in self.videoSuper.subviews)
    {
        [subView removeFromSuperview];
    }
    NSFileManager *fm;
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *filePath = [docsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Featured/%d.mp4",self.selectedVideo.video_id]];
    NSLog(@"video path:%@",filePath);
    fm=[NSFileManager defaultManager];
    if([fm fileExistsAtPath:filePath])
    {
        NSURL* url=[NSURL URLWithString:filePath];
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
        
    }
    else
    {
        NSURL* url=[NSURL URLWithString:self.selectedVideo.video_url];
        player= [[MPMoviePlayerViewController alloc] init];
        [player.moviePlayer setFullscreen:NO];
        player.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
        [player.moviePlayer setContentURL:url];
        player.moviePlayer.controlStyle =MPMovieControlStyleEmbedded;
        [player.moviePlayer.view setFrame:self.videoSuper.bounds];
        [player.moviePlayer setScalingMode:MPMovieScalingModeAspectFit];
        [player.moviePlayer setShouldAutoplay:FALSE];
        [player.moviePlayer prepareToPlay];
        NSLog(@"video not found @ path:%@",filePath);
        previewLabel.text=NSLocalizedString(@"Online Streaming:", nil);
    }
    [self.videoSuper addSubview:player.moviePlayer.view];
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
        UIAlertView* addAlert=[[UIAlertView alloc] initWithTitle:@"Download Video" message:@"Do you want to download this video?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Download", nil];
        addAlert.tag=10;
        [addAlert show];
        
    }
    else
    {
        UIAlertView* addAlert=[[UIAlertView alloc] initWithTitle:@"Download Video" message:@"Do you want to remove this video from download list?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Remove it", nil];
        addAlert.tag=11;
        [addAlert show];
        
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Alert Tag=%d, button index=%d",alertView.tag,buttonIndex);
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
