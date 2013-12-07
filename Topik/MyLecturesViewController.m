//
//  MyLecturesViewController.m
//  Topik
//
//  Created by Lee Haining on 13-12-1.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "MyLecturesViewController.h"
#import "AppConfig.h"
#import "RemoteData.h"
#import "DownloadListData.h"
#import "DownloadLecture.h"
#import "DownloadVideoDetailViewController.h"
#import "Downloader.h"
#import "FeaturedPlaylistCell.h"
#import "DownloadProgress.h"
@interface MyLecturesViewController ()
{
    NSInteger _currentSegSeletedIndex;
    DownloadListData* downloadData;
    DownloadLecture* selectedVideo;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)segementedValueChanged:(id)sender;

@end

@implementation MyLecturesViewController

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
    _currentSegSeletedIndex=0;
    [self.segmentedControl setTitle:NSLocalizedString(@"Download", nil) forSegmentAtIndex:0];
    [self.segmentedControl setTitle:NSLocalizedString(@"Bookmark", nil) forSegmentAtIndex:1];
    UIColor* tabBarTintColor=[AppConfig getTabBarTintColor];
    self.navigationController.navigationBar.tintColor = tabBarTintColor;
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    tabBarTintColor, NSForegroundColorAttributeName,nil];
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    self.navigationItem.title=NSLocalizedString(@"My Lectures", nil);
    
    self.tableview.dataSource=self;
    self.tableview.delegate=self;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [RemoteData updateDownloadProgressFromDisk];
    [self updateDownloadData];
    [self.tableview reloadData];
    //register DownloadProgressNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setProgress:) name:kDownloadProgressNotification object:nil];
    CGRect tableFrame=self.tableview.frame;
    if(isiPhone5)
    {
        //self.tableview.frame=CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
        tableFrame=CGRectMake(tableFrame.origin.x, tableFrame.origin.y, tableFrame.size.width, 411);
    }
    else
    {
        tableFrame=CGRectMake(tableFrame.origin.x, tableFrame.origin.y, tableFrame.size.width, 323);
    }
    self.tableview.frame=tableFrame;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //unregister DownloadProgressNotification
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segementedValueChanged:(id)sender {
    if(self.segmentedControl.selectedSegmentIndex==0)
    {
        NSLog(@"Download-Control selected");
        
    }
    else if(self.segmentedControl.selectedSegmentIndex==1)
    {
        NSLog(@"Bookmark-Control selected");
        NSLog(@"tableview height:%f",self.tableview.frame.size.height);
    }
    _currentSegSeletedIndex=self.segmentedControl.selectedSegmentIndex;
}
#pragma mark-TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionsCount=0;
    if(_currentSegSeletedIndex==0)
    {
        sectionsCount=downloadData.lectureArray.count;
    }
    else if(_currentSegSeletedIndex==1)
    {
        sectionsCount=1;
    }
    return sectionsCount;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowsCount=0;
    if(_currentSegSeletedIndex==0)
    {
        NSNumber *lecture_id_number=(NSNumber *)downloadData.lectureArray[section];
        NSInteger lecture_id=[lecture_id_number intValue];
        NSString *lecture_id_str=[NSString stringWithFormat:@"%ld",(long)lecture_id];
        NSMutableArray *videoArray=[downloadData.videoLectureDictionary objectForKey:lecture_id_str];
        rowsCount=videoArray.count;
    }
    else if(_currentSegSeletedIndex==1)
    {
        
    }
    return rowsCount;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *headerTitle=@"";
    if(_currentSegSeletedIndex==0)
    {
        NSNumber *lecture_id_number=(NSNumber *)downloadData.lectureArray[section];
        NSInteger lecture_id=[lecture_id_number intValue];
        NSString *lecture_id_str=[NSString stringWithFormat:@"%ld",(long)lecture_id];
        NSString *lecture_title=[downloadData.lectureDictionary valueForKey:lecture_id_str];
        headerTitle=lecture_title;
        
    }
    return headerTitle;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *BookmarkCellIdentifier = @"BookmarkCell";
    static NSString *DownloadCellIdentifier = @"DownloadCell";
    if(_currentSegSeletedIndex==0)//Download Table
    {
        FeaturedPlaylistCell *cell=nil;
        cell = [tableView dequeueReusableCellWithIdentifier:DownloadCellIdentifier];
        // Configure the cell...
        if(!cell)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FeaturedPlaylistCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
        }
        
        NSNumber *lecture_id_number=(NSNumber *)downloadData.lectureArray[indexPath.section];
        NSInteger lecture_id=[lecture_id_number intValue];
        NSString *lecture_id_str=[NSString stringWithFormat:@"%ld",(long)lecture_id];
        NSMutableArray *videoArray=[downloadData.videoLectureDictionary objectForKey:lecture_id_str];
        DownloadLecture *video=(DownloadLecture*)videoArray[indexPath.row];
        NSString *titleText=video.video_name;
        float downloadedF, totalF;
		char prefix;
        float total=(float)video.file_size;
        float downloaded=(float)video.downloaded_size;
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
        NSString *progress=NSLocalizedString(@"Download:", nil);
        if(video.status==kDownloadFinishedStatus)
        {
            progress=[progress stringByAppendingFormat:@" %@",NSLocalizedString(@"Done", nil)];
            progress=[progress stringByAppendingFormat:@" %.2f %cB",totalF,prefix];
        }
        else
        {
            progress=[progress stringByAppendingFormat:@" %@",subtitle];
            
        }
        cell.videoNameLabel.text=titleText;
        cell.videoStatusLabel.text=progress;
        return cell;
    }
    else
    {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:BookmarkCellIdentifier];
        if(!cell)
        {
            
        }
        return cell;
    }
    return nil;
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
-(void)setProgress:(NSNotification *) notification
{
    //NSLog(@"Progress Updated:%f",progress.progressInFloat);
    if(_currentSegSeletedIndex==0)
    {
        DownloadProgress *progress=(DownloadProgress*)[notification.userInfo objectForKey:@"progress"];
        //NSLog(@"Progress Updated:%f",progress.progressInFloat);
        NSInteger lecture_id=progress.lecture_id;
        NSInteger video_id=progress.video_id;
        //NSLog(@"Lecture id:%d Video id:%d %.2f%%",lecture_id,video_id,progress.progressInFloat*100);
        //get Section and Row for IndexPath
        NSInteger section_index=[downloadData.lectureArray indexOfObject:[NSNumber numberWithInteger:lecture_id]];
        //NSLog(@"section_index=%d",section_index);
        NSString *lecture_id_str=[NSString stringWithFormat:@"%ld",(long)lecture_id];
        NSMutableArray *videoArray=[downloadData.videoLectureDictionary objectForKey:lecture_id_str];
        NSInteger row_index=0;
        for(DownloadLecture* lecture in videoArray)
        {
            
            if(lecture.video_id==video_id)
            {
                [lecture updateTotalSize:(NSInteger)progress.totalSize DownloadedSize:(NSInteger)progress.received];
                break;
            }
            row_index++;
        }
        //NSLog(@"section_index=%d row_index=%d Lecture id:%d Video id:%d %.2f%%",section_index,row_index,lecture_id,video_id,progress.progressInFloat*100);
        FeaturedPlaylistCell *cell = (FeaturedPlaylistCell *)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row_index inSection:section_index]];
        [self updateCellProgress:cell withProgress:progress];
    }
}
#pragma mark-TableViewDelegate
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_currentSegSeletedIndex==0)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            NSNumber *lecture_id_number=(NSNumber *)downloadData.lectureArray[indexPath.section];
            NSInteger lecture_id=[lecture_id_number intValue];
            NSString *lecture_id_str=[NSString stringWithFormat:@"%ld",(long)lecture_id];
            NSMutableArray *videoArray=[downloadData.videoLectureDictionary objectForKey:lecture_id_str];
            DownloadLecture *video=(DownloadLecture*)videoArray[indexPath.row];
            [RemoteData RemoveVideoFromDownloadByVideoId:video.video_id];
            [self updateDownloadData];
            [tableView reloadData];
            //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
            
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_currentSegSeletedIndex==0)
    {
        
        NSNumber *lecture_id_number=(NSNumber *)downloadData.lectureArray[indexPath.section];
        NSInteger lecture_id=[lecture_id_number intValue];
        NSString *lecture_id_str=[NSString stringWithFormat:@"%ld",(long)lecture_id];
        NSMutableArray *videoArray=[downloadData.videoLectureDictionary objectForKey:lecture_id_str];
        selectedVideo=videoArray[indexPath.row];
        //DownloadLecture *selected
        [self performSegueWithIdentifier:@"DownloadVideoDetailSegue" sender:self];
       // NSLog(@"section:%d row:%ld Selected.",indexPath.section,indexPath.row);
    }
    else if(_currentSegSeletedIndex==1)
    {
        
    }

}

-(void)updateDownloadData{
    downloadData=[RemoteData loadDownloadListData];
}
#pragma mark-Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"Prepare for %@",segue.identifier);
    if ([[segue identifier] isEqualToString:@"DownloadVideoDetailSegue"])
    {
        DownloadVideoDetailViewController *videoController=[segue destinationViewController];
        videoController.selectedVideo=selectedVideo;
    }
}



@end
