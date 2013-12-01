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
#import "BookmarkLecture.h"
#import "RemoteData.h"
#import "FeaturedVideoDetailViewController.h"
@interface FeaturedDetailViewController ()
{
    MPMoviePlayerViewController *player;
    __weak IBOutlet UILabel *previewLabel;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *playlistLabel;
    __weak IBOutlet UITableView *playlistTableView;
}
@property (weak, nonatomic) IBOutlet UIView *videoSuper;
@property (nonatomic,assign) NSInteger selectedVideoIndex;
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
    [self updateBookmarkButton];
    [self updateDownloadButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [self updateDownloadButton];
    [self updateBookmarkButton];
    NSString *sampleUrlString=[NSString stringWithFormat:@"http://v.youku.com/player/getRealM3U8/vid/%@/type/video.m3u8",self.lecture.sample.sv_vid];
    NSLog(@"FeaturedDetail:vid:%@",self.lecture.sample.sv_vid);
   [self parepareVideo:sampleUrlString];
    
}
- (void)didReceiveMemoryWaning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"Prepare for %@",segue.identifier);
    if ([[segue identifier] isEqualToString:@"FeaturedVideoDetailSegue"])
    {
        FeaturedVideoDetailViewController *videoController=[segue destinationViewController];
        videoController.lecture=self.lecture;
        videoController.videoIndex=self.selectedVideoIndex;
    }
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
    NSString *subTitleText=@"Waiting for downloading..";
    cell.videoNameLabel.text=titleText;
    cell.videoStatusLabel.text=subTitleText;
    //cell.textLabel.text=titleText;
    //cell.statu.text=subTitleText;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedVideoIndex=indexPath.row;
    [self performSegueWithIdentifier:@"FeaturedVideoDetailSegue" sender:self];
}
- (IBAction)updateBookmark:(id)sender {
    [self insertBookMark:self.lecture];
}

- (IBAction)updateDownload:(id)sender {
    [self insertDownload:self.lecture];
}

-(void)insertBookMark:(FeaturedLecture *)lecture{
    if(![RemoteData FeaturedLectureExistsInBookmark:self.lecture])
    {
        [RemoteData InsertFeaturedLectureBookmark:lecture ];
        
    }
    else
    {
        [RemoteData RemoveFeaturedLectureFromBookmark:lecture];
        
    }
    [self updateBookmarkButton];
}
-(void)insertDownload:(FeaturedLecture*)lecture{
    if(![RemoteData FeaturedLectureExistInDownload:self.lecture])
    {
        UIAlertView* addAlert=[[UIAlertView alloc] initWithTitle:@"Download" message:@"Do you want to download all the videos of this lecture?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Download All", nil];
        addAlert.tag=10;
        [addAlert show];
        
    }
    else
    {
        UIAlertView* addAlert=[[UIAlertView alloc] initWithTitle:@"Download Lecture" message:@"You can download or remove videos of this lecture" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Download All",@"Remove All", nil];
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
                [RemoteData InsertFeaturedLectureVideoDownload:self.lecture];
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
                [RemoteData InsertFeaturedLectureVideoDownload:self.lecture];
                break;
            default:
                [RemoteData RemoveFeaturedLectureFromDownload:self.lecture];
                break;
        }
    }
    [self updateDownloadButton];
}
-(void)updateBookmarkButton{
    self.bookmarkButton.selected=[RemoteData FeaturedLectureExistsInBookmark:self.lecture];
}
-(void)updateDownloadButton{
    self.downloadButton.selected=[RemoteData FeaturedLectureExistInDownload:self.lecture];
}

@end
