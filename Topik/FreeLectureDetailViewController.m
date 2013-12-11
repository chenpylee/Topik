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
@interface FreeLectureDetailViewController ()
{
    MPMoviePlayerViewController *player;
    __weak IBOutlet UILabel *previewLabel;
    __weak IBOutlet UILabel *titleLabel;
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
    NSString *sampleUrlString=[NSString stringWithFormat:@"http://v.youku.com/player/getRealM3U8/vid/%@/type/video.m3u8",self.lecture.free_vid];
    [self parepareVideo:sampleUrlString];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [player.moviePlayer setShouldAutoplay:FALSE];
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
@end
