//
//  FeaturedDetailViewController.m
//  Topik
//
//  Created by Lee Haining on 13-11-27.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "FeaturedDetailViewController.h"
#import "AppConfig.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import "LandscapeSupportedMPMoviePlayerController.h"
#import "LectureVideo.h"
#import "FeaturedPlaylistCell.h"
@interface FeaturedDetailViewController ()
{
    MPMoviePlayerViewController *player;
    __weak IBOutlet UILabel *previewLabel;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UIButton *downloadButton;
    __weak IBOutlet UIButton *bookmarkButton;
    __weak IBOutlet UILabel *playlistLabel;
    __weak IBOutlet UITableView *playlistTableView;
}
@property (weak, nonatomic) IBOutlet UIView *videoSuper;
@end

@implementation FeaturedDetailViewController

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
    UIColor* tabBarTintColor=[AppConfig getTabBarTintColor];
    self.navigationController.navigationBar.tintColor = tabBarTintColor;
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    tabBarTintColor, NSForegroundColorAttributeName,nil];
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    
    self.navigationItem.title=NSLocalizedString(@"Detail", nil);
    previewLabel.text=NSLocalizedString(@"Sample Video", nil);
    titleLabel.text=self.lecture.lecture_title;
    playlistLabel.text=NSLocalizedString(@"Playlist", nil);
    
    playlistTableView.dataSource=self;
    playlistTableView.delegate=self;
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    NSString *sampleUrlString=[NSString stringWithFormat:@"http://v.youku.com/player/getRealM3U8/vid/%@/type/video.m3u8",self.lecture.sample.sv_vid];
    NSLog(@"FeaturedDetail:vid:%@",self.lecture.sample.sv_vid);
   [self parepareVideo:sampleUrlString];
}
- (void)didReceiveMemoryWaning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
     [self.videoSuper addSubview:player.moviePlayer.view];
     //[movie play];
     [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(willExitFullScreen:)
                                                  name:MPMoviePlayerWillExitFullscreenNotification
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
#pragma mark- Playlist TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lecture.videos.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FeaturedPlayListCell";
    FeaturedPlaylistCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if(!cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FeaturedPlaylistCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        
    }

    LectureVideo* video=self.lecture.videos[indexPath.row];
    NSString *titleText=video.video_name;
    //NSString *status=NSLocalizedstring}
    NSString *subTitleText=@"Downloading..";
    cell.videoNameLabel.text=titleText;
    cell.videoStatusLabel.text=subTitleText;
    //cell.textLabel.text=titleText;
    //cell.statu.text=subTitleText;
    return cell;
}
@end
