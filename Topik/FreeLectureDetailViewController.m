//
//  FreeLectureDetailViewController.m
//  Topik
//
//  Created by Lee Haining on 13-12-8.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "FreeLectureDetailViewController.h"
#import "AppConfig.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import "RemoteData.h"
#import "UIImageView+WebCache.h"
@interface FreeLectureDetailViewController ()
{
    MPMoviePlayerViewController *player;
    __weak IBOutlet UILabel *previewLabel;
    __weak IBOutlet UILabel *titleLabel;
    Reachability *internetReach;
}
@property (weak, nonatomic) IBOutlet UIView *videoSuper;
@end

@implementation FreeLectureDetailViewController

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
    
    self.navigationItem.title=NSLocalizedString(@"Detail", nil);
    previewLabel.text=NSLocalizedString(@"Sample Video", nil);
    titleLabel.text=self.lecture.free_title;
    //[self updateBookmarkButton];


}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateBookmarkButton];
    [self setupVideoPlay];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(player)
    {
        [player.moviePlayer stop];
        [player.moviePlayer.view removeFromSuperview];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void) setupVideoPlay{
    self.placeHolderVG=[UIImage imageNamed:@"placeholder_6.png"];
    self.placeHolderW=[UIImage imageNamed:@"placeholder_8.png"];
    self.placeHolderL=[UIImage imageNamed:@"placeholder_9.png"];
    self.placeHolderR=[UIImage imageNamed:@"placeholder_10.png"];
    self.placeHolderO=[UIImage imageNamed:@"placeholder_11.png"];
    UIImage *placeholder=nil;
    switch (self.lecture.lecture_type) {
        case 6:
            placeholder=self.placeHolderVG;
            break;
        case 8:
            placeholder=self.placeHolderW;
            break;
        case 9:
            placeholder=self.placeHolderL;
            break;
        case 10:
            placeholder=self.placeHolderR;
            break;
        case 11:
            placeholder=self.placeHolderO;
            break;
        default:
            placeholder=self.placeHolderO;
            break;
    }
    if(![self.lecture.free_img isEqualToString:@""])
    {
        [self.videoImageView setImageWithURL:[NSURL URLWithString:self.lecture.free_img]
                            placeholderImage:placeholder];
    }
    else
    {
        self.videoImageView.image=placeholder;
    }
    
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
    NSString *sampleUrlString=[NSString stringWithFormat:@"http://v.youku.com/player/getRealM3U8/vid/%@/type/video.m3u8",self.lecture.free_vid];
    [self parepareVideo:sampleUrlString];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)updateBookmark:(id)sender {
    [self insertBookMark:self.lecture];
}
-(void)insertBookMark:(FreeLecture *)lecture{
    if(![RemoteData FreeLectureExistsInBookmark:lecture])
    {
        [RemoteData InsertFreeLectureBookmark:lecture];
        
    }
    else
    {
        [RemoteData RemoveFreeLectureFromBookmark:lecture];
        
    }
    [self updateBookmarkButton];
}
-(void)updateBookmarkButton{
    self.bookmarkButton.selected=[RemoteData FreeLectureExistsInBookmark:self.lecture];
}
#pragma mark- Video Playing and Fullscreen Landscape
-(void)parepareVideo:(NSString*)videoUrlString{
    
    //@"http://v.youku.com/player/getRealM3U8/vid/XNTQ5MzA0MDg4/type//video.m3u8"
    NSURL* url=[NSURL URLWithString:videoUrlString];
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
    NSLog(@"FeaturedDetailViewController dealloc+++++++++++++++++++++");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==20)
    {
        [self playVideo];
        return;
    }
}
@end
