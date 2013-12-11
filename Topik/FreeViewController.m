//
//  FreeViewController.m
//  Topik
//
//  Created by Lee Haining on 13-12-8.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "FreeViewController.h"
#import "RemoteData.h"
#import "UIImageView+WebCache.h"
#import "FreeCellView.h"
#import "FreeLectureDetailViewController.h"
@interface FreeViewController ()
@property(nonatomic,strong)UIImage* placeHolderVG;
@property(nonatomic,strong)UIImage* placeHolderW;
@property(nonatomic,strong)UIImage* placeHolderL;
@property(nonatomic,strong)UIImage* placeHolderR;
@property(nonatomic,strong)UIImage* placeHolderO;
@property(nonatomic,strong)UIView* selectedBackgroundView;
@property(nonatomic,strong)FreeLecture* selectedLecture;
@end

@implementation FreeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIColor* tabBarTintColor=[AppConfig getTabBarTintColor];
    self.navigationController.navigationBar.tintColor = tabBarTintColor;//works for both title and button on navigationbar
    //[[UINavigationBar appearance] setTintColor:tabBarTintColor];//only work for title
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    tabBarTintColor, NSForegroundColorAttributeName,nil];
    
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    //self.navigationController.title=@"nav title";
    self.navigationItem.title=NSLocalizedString(@"Free Lectures", nil);
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //Load lectures
    [self.tableView setRowHeight:70];
    self.lectures=[RemoteData loadFreeLecturesToArrayByLang:self.lang_id];
    self.selectedBackgroundView=[[UIView alloc] init];
    [self.selectedBackgroundView setBackgroundColor:[AppConfig getTabBarTintColor]];
    
    
    self.placeHolderVG=[UIImage imageNamed:@"placeholder_6.png"];
    self.placeHolderW=[UIImage imageNamed:@"placeholder_8.png"];
    self.placeHolderL=[UIImage imageNamed:@"placeholder_9.png"];
    self.placeHolderR=[UIImage imageNamed:@"placeholder_10.png"];
    self.placeHolderO=[UIImage imageNamed:@"placeholder_11.png"];
    self.tableView.delegate=self;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
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
    static NSString *CellIdentifier = @"freeCell";
    FreeCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if(!cell)
    {
        cell=[[FreeCellView alloc]
              initWithStyle:UITableViewCellStyleDefault
              reuseIdentifier:CellIdentifier];
    }
    FreeLecture *lecture=self.lectures[indexPath.row];
    //cell.thumbImageview.image=[UIImage imageNamed:@"sample_thumbnail.png"];
    cell.titleLabel.text=lecture.free_title;
    cell.countLabel.text=@"1";
    //cell.selectedBackgroundView=self.selectedBackgroundView;
    UIImage *placeholder=nil;
    switch (lecture.lecture_type) {
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
    if(![lecture.free_img isEqualToString:@""])
    {
        [cell.thumbImageview setImageWithURL:[NSURL URLWithString:lecture.free_img]
                            placeholderImage:placeholder];
    }
    else
    {
        cell.thumbImageview.image=placeholder;
    }
     cell.selectedBackgroundView=self.selectedBackgroundView;
    cell.accessoryType=UITableViewCellSelectionStyleNone;
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    self.selectedLecture=self.lectures[indexPath.row];
    [self performSegueWithIdentifier:@"FreeLectureDetailSegue" sender:self];
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
    if ([[segue identifier] isEqualToString:@"FreeLectureDetailSegue"])
    {
        // Get reference to the destination view controller
        
        FreeLectureDetailViewController *detailController = [segue destinationViewController];
        detailController.lecture=self.selectedLecture;
    }
}



@end
