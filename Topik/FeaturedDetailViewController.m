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
#import "Downloader.h"
#import "DownloadLecture.h"
#import "FeaturedPlaylistCell.h"
#import "DownloadProgress.h"
#import "UIImageView+WebCache.h"
@interface FeaturedDetailViewController ()
{
    MPMoviePlayerViewController *player;
    __weak IBOutlet UILabel *previewLabel;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *playlistLabel;
    __weak IBOutlet UITableView *playlistTableView;
    NSMutableArray *videosFromDB;
    
    Reachability *internetReach;
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
-(void) setupVideoPlay{
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
    NSString *sampleUrlString=[NSString stringWithFormat:@"http://v.youku.com/player/getRealM3U8/vid/%@/type/video.m3u8",self.lecture.sample.sv_vid];
    NSLog(@"FeaturedDetail:vid:%@",self.lecture.sample.sv_vid);
    [self parepareVideo:sampleUrlString];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setProgress:) name:kDownloadProgressNotification object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [self updateDownloadButton];
    [self updateBookmarkButton];
    
    [self setupVideoPlay];
    [RemoteData updateDownloadProgressFromDisk];
    [self updateProgressDataFromDB];
    [playlistTableView reloadData];
    //register DownloadProgressNotification
    
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
- (void)didReceiveMemoryWaning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setProgress:(NSNotification *) notification
{
   
        DownloadProgress *progress=(DownloadProgress*)[notification.userInfo objectForKey:@"progress"];
        //NSLog(@"Progress Updated:%f",progress.progressInFloat);
        NSInteger lecture_id=progress.lecture_id;
        NSInteger video_id=progress.video_id;
        //NSLog(@"Lecture id:%d Video id:%d %.2f%%",lecture_id,video_id,progress.progressInFloat*100);
        //get Section and Row for IndexPath
        NSInteger section_index=0;
        //NSLog(@"section_index=%d",section_index);
       // NSString *lecture_id_str=[NSString stringWithFormat:@"%ld",(long)lecture_id];
        NSInteger row_index=0;
        for(DownloadLecture * video in videosFromDB)
        {
            
            if(video.video_id==video_id)
            {
                [video updateTotalSize:(NSInteger)progress.totalSize DownloadedSize:(NSInteger)progress.received];
                break;
            }
        }
        for(LectureVideo *video in self.lecture.videos)
        {
            if(video.video_id==video_id)
            {
                break;
            }
            row_index++;
        }
        NSLog(@"section_index=%ld row_index=%ld Lecture id:%ld Video id:%ld %.2f%%",(long)section_index,(long)row_index,(long)lecture_id,(long)video_id,progress.progressInFloat*100);
        FeaturedPlaylistCell *cell = (FeaturedPlaylistCell *)[playlistTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row_index inSection:section_index]];
        [self updateCellProgress:cell withProgress:progress];
    
}
- (void)updateCellProgress:(FeaturedPlaylistCell *)cell withProgress:(DownloadProgress*)progress{
    
    
    if(cell)
    {
        float downloadedF, totalF;
		char prefix;
        float total=(float)progress.totalSize;
        float downloaded=(float)progress.received;
		if (total >= 1024 * 1024 * 1024)
        {
			downloadedF = (float)downloaded / (1024 * 1024 * 1024);
			totalF = (float)total / (1024 * 1024 * 1024);
			prefix = 'G';
		}
        else if (total >= 1024 * 1024)
        {
			downloadedF = (float)downloaded / (1024 * 1024);
			totalF = (float)total / (1024 * 1024);
			prefix = 'M';
		}
        else if (total >= 1024)
        {
			downloadedF = (float)downloaded / 1024;
			totalF = (float)total / 1024;
			prefix = 'k';
		}
        else
        {
			downloadedF = (float)downloaded;
			totalF = (float)total;
			prefix = '\0';
		}
        
		//float speedNorm = downloadedF / dt;
		NSString *subtitle = [[NSString alloc] initWithFormat:@"%.2f / %.2f %cB",downloadedF, totalF, prefix];
        NSString *progressText=NSLocalizedString(@"Download:", nil);
        if(progress.received==progress.totalSize)
        {
            progressText=[progressText stringByAppendingFormat:@" %@",NSLocalizedString(@"Done", nil)];
            progressText=[progressText stringByAppendingFormat:@" %.2f %cB",totalF,prefix];
        }
        else
        {
            progressText=[progressText stringByAppendingFormat:@" %@",subtitle];
            
        }
        
        cell.videoStatusLabel.text=progressText;
        
    }
}

-(void)updateProgressDataFromDB{
    videosFromDB=[RemoteData loadDownloadingVideoListForFeaturedLecture:self.lecture];
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
    NSString *subTitleText=@"";
    
    cell.videoNameLabel.text=titleText;
    if(videosFromDB.count!=0)
    {
        for(DownloadLecture *lectureVideo in videosFromDB)
        {
            if(lectureVideo.video_id==video.video_id)
            {
                float downloadedF, totalF;
                char prefix;
                float total=(float)lectureVideo.file_size;
                float downloaded=(float)lectureVideo.downloaded_size;
                if (total >= 1024 * 1024 * 1024)
                {
                    downloadedF = (float)downloaded / (1024 * 1024 * 1024);
                    totalF = (float)total / (1024 * 1024 * 1024);
                    prefix = 'G';
                }
                else if (total >= 1024 * 1024)
                {
                    downloadedF = (float)downloaded / (1024 * 1024);
                    totalF = (float)total / (1024 * 1024);
                    prefix = 'M';
                }
                else if (total >= 1024)
                {
                    downloadedF = (float)downloaded / 1024;
                    totalF = (float)total / 1024;
                    prefix = 'k';
                }
                else
                {
                    downloadedF = (float)downloaded;
                    totalF = (float)total;
                    prefix = '\0';
                }
                NSString *progress=NSLocalizedString(@"Download:", nil);
                NSString *progressDetail = [[NSString alloc] initWithFormat:@"%.2f / %.2f %cB",downloadedF, totalF, prefix];
                if(lectureVideo.status==kDownloadFinishedStatus)
                {
                    progress=[progress stringByAppendingFormat:@" %@",NSLocalizedString(@"Done", nil)];
                    progress=[progress stringByAppendingFormat:@" %.2f %cB",totalF,prefix];
                }
                else
                {
                    progress=[progress stringByAppendingFormat:@" %@",progressDetail];
                }
                subTitleText=progress;
                break;
            }
        }
    }
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
