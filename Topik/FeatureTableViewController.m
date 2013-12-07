//
//  FeatureTableViewController.m
//  Topik
//
//  Created by Lee Haining on 13-11-23.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "FeatureTableViewController.h"
#import "AppConfig.h"
#import "ASIHTTPRequest.h"
#import "RemoteData.h"
#import "FeaturedCellView.h"
#import "FeaturedDetailViewController.h"
#import "UIImageView+WebCache.h"
@interface FeatureTableViewController ()
@property(nonatomic,strong)UIView* selectedBackgroundView;
@property(nonatomic,strong)UIView* selectedBackgroundViewLv1;
@property(nonatomic,strong)UIView* selectedBackgroundViewLv2;
@property(nonatomic,strong)UIView* selectedBackgroundViewLv3;
@property(nonatomic,strong)UIView* selectedBackgroundViewLv4;
@property(nonatomic,strong)UIImage* placeHolderLv1;
@property(nonatomic,strong)UIImage* placeHolderLv2;
@property(nonatomic,strong)UIImage* placeHolderLv3;
@property(nonatomic,strong)UIImage* placeHolderLv4;
@property(nonatomic,strong)FeaturedLecture* selectedLecture;
@end

@implementation FeatureTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        NSLog(@"load featured lectures data");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    UIColor* tabBarTintColor=[AppConfig getTabBarTintColor];
    self.navigationController.navigationBar.tintColor = tabBarTintColor;//works for both title and button on navigationbar
    //[[UINavigationBar appearance] setTintColor:tabBarTintColor];//only work for title
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    tabBarTintColor, NSForegroundColorAttributeName,nil];

    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    //self.navigationController.title=@"nav title";
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTable)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    self.navigationItem.title=NSLocalizedString(@"Featured Lectures", nil);
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //Load lectures
    [self.tableView setRowHeight:70];
    self.lectures=[RemoteData loadFeaturedLecturesToArray];
    self.selectedBackgroundView=[[UIView alloc] init];
    [self.selectedBackgroundView setBackgroundColor:[AppConfig getTabBarTintColor]];
    
    self.selectedBackgroundViewLv1=[[UIView alloc] init];
    [self.selectedBackgroundViewLv1 setBackgroundColor:[AppConfig getLevelColor1]];
    self.selectedBackgroundViewLv2=[[UIView alloc] init];
    [self.selectedBackgroundViewLv2 setBackgroundColor:[AppConfig getLevelColor2]];
    self.selectedBackgroundViewLv3=[[UIView alloc] init];
    [self.selectedBackgroundViewLv3 setBackgroundColor:[AppConfig getLevelColor3]];
    self.selectedBackgroundViewLv4=[[UIView alloc] init];
    [self.selectedBackgroundViewLv4 setBackgroundColor:[AppConfig getLevelColor4]];
    

    self.placeHolderLv1=[UIImage imageNamed:@"topik_placeholder_1.png"];
    self.placeHolderLv2=[UIImage imageNamed:@"topik_placeholder_2.png"];
    self.placeHolderLv3=[UIImage imageNamed:@"topik_placeholder_3.png"];
    self.placeHolderLv4=[UIImage imageNamed:@"topik_placeholder_4.png"];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    //self.selectedBackgroundView.layer.cornerRadius = 5;

    
}
-(void)refreshTable{
    if(self.lectures.count>0)
    {
    NSIndexPath *topPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:topPath
                     atScrollPosition:UITableViewScrollPositionTop
                             animated:YES];
    }
    NSLog(@"refreshing featured lectures...");
    [self loadDataFromServer];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.lectures.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"featuredCell";
    FeaturedCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if(!cell)
    {
        cell=[[FeaturedCellView alloc]
              initWithStyle:UITableViewCellStyleDefault
              reuseIdentifier:CellIdentifier];
    }
    FeaturedLecture *lecture=self.lectures[indexPath.row];
    //cell.thumbImageview.image=[UIImage imageNamed:@"sample_thumbnail.png"];
    cell.titleLabel.text=lecture.lecture_title;
    cell.countLabel.text=[NSString stringWithFormat:@"%ld",(long)lecture.lecture_count];
    //cell.selectedBackgroundView=self.selectedBackgroundView;
    UIImage *placeholder=nil;
    switch (lecture.level_id) {
        case 1:
            cell.selectedBackgroundView=self.selectedBackgroundViewLv1;
            placeholder=self.placeHolderLv1;
            break;
        case 2:
            cell.selectedBackgroundView=self.selectedBackgroundViewLv2;
            placeholder=self.placeHolderLv2;
            break;
        case 3:
            cell.selectedBackgroundView=self.selectedBackgroundViewLv3;
            placeholder=self.placeHolderLv3;
            break;
        case 4:
            cell.selectedBackgroundView=self.selectedBackgroundViewLv4;
            placeholder=self.placeHolderLv4;
            break;
        default:
            cell.selectedBackgroundView=self.selectedBackgroundView;
            placeholder=self.placeHolderLv4;
            break;
    }
    if(![lecture.lecture_img_url isEqualToString:@""])
    {
        [cell.thumbImageview setImageWithURL:[NSURL URLWithString:lecture.lecture_img_url]
                       placeholderImage:placeholder];
    }
    else
    {
        cell.thumbImageview.image=placeholder;
    }
    cell.accessoryType=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedLecture=self.lectures[indexPath.row];
    [self performSegueWithIdentifier:@"FeaturedDetailSegue" sender:self];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"Prepare for %@",segue.identifier);
    if ([[segue identifier] isEqualToString:@"FeaturedDetailSegue"])
    {
        // Get reference to the destination view controller
        FeaturedDetailViewController *detailController = [segue destinationViewController];
        detailController.lecture=self.selectedLecture;
        NSLog(@"Prepare for %@",self.selectedLecture.sample.sv_vid);
    }
}

#pragma mark- Download Data

- (void)loadDataFromServer{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *urlString=[AppConfig getFullDataUrl];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    NSLog(@"--------------------------------------------------");
    NSLog(@"Start Downloading from %@...",[url absoluteString]);

}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    //NSString *responseString = [request responseString];
    NSData *responseData=[request responseData];
    [self parseData:responseData];
    self.lectures=[RemoteData loadFeaturedLecturesToArray];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.tableView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Error:%@",error);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //to hide networkActivityIndicator:
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
#pragma mark- parse Json data
- (void)parseData:(NSData *)responseData {
    [RemoteData processTotalJsonData:responseData];
}

@end
