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
    [self updateDownloadData];
    [self.tableview reloadData];
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
        NSString *lecture_id_str=[NSString stringWithFormat:@"%d",lecture_id];
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
        NSString *lecture_id_str=[NSString stringWithFormat:@"%d",lecture_id];
        NSString *lecture_title=[downloadData.lectureDictionary valueForKey:lecture_id_str];
        headerTitle=lecture_title;
        
    }
    return headerTitle;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=nil;
    static NSString *BookmarkCellIdentifier = @"BookmarkCell";
    static NSString *DownloadCellIdentifier = @"DownloadCell";
    if(_currentSegSeletedIndex==0)//Download Table
    {
        cell=[tableView dequeueReusableCellWithIdentifier:DownloadCellIdentifier];
        NSNumber *lecture_id_number=(NSNumber *)downloadData.lectureArray[indexPath.section];
        NSInteger lecture_id=[lecture_id_number intValue];
        NSString *lecture_id_str=[NSString stringWithFormat:@"%d",lecture_id];
        NSMutableArray *videoArray=[downloadData.videoLectureDictionary objectForKey:lecture_id_str];
        DownloadLecture *video=(DownloadLecture*)videoArray[indexPath.row];
        
        if(!cell)
        {
            
            //NSMutableArray *videoArray=[downloadData.videoLectureDictionary ];
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DownloadCellIdentifier];
        }
        cell.textLabel.text=video.video_name;
    }
    else
    {
        cell=[tableView dequeueReusableCellWithIdentifier:BookmarkCellIdentifier];
        if(!cell)
        {
            
        }
    }
    return cell;
}
#pragma mark-TableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_currentSegSeletedIndex==0)
    {
        
        NSNumber *lecture_id_number=(NSNumber *)downloadData.lectureArray[indexPath.section];
        NSInteger lecture_id=[lecture_id_number intValue];
        NSString *lecture_id_str=[NSString stringWithFormat:@"%d",lecture_id];
        NSMutableArray *videoArray=[downloadData.videoLectureDictionary objectForKey:lecture_id_str];
        selectedVideo=videoArray[indexPath.row];
        //DownloadLecture *selected
        [self performSegueWithIdentifier:@"DownloadVideoDetailSegue" sender:self];
        NSLog(@"section:%d row:%d Selected.",indexPath.section,indexPath.row);
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
