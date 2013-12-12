//
//  SettingViewController.m
//  Topik
//
//  Created by Lee Haining on 13-12-11.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "SettingViewController.h"
#import "AppConfig.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *network1Label;
@property (weak, nonatomic) IBOutlet UILabel *network2Label;
@property (weak, nonatomic) IBOutlet UISwitch *network1Switch;
@property (weak, nonatomic) IBOutlet UISwitch *network2Switch;//background downloading
- (IBAction)network1ValueChanged:(id)sender;
- (IBAction)network2ValueChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *upgrade1Label;
@property (weak, nonatomic) IBOutlet UILabel *upgrade2Label;
@property (weak, nonatomic) IBOutlet UILabel *feedback1Label;
@property(nonatomic,strong)UIView* selectedBackgroundView;

@end

@implementation SettingViewController

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
    /**
     UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTable)];
     self.navigationItem.rightBarButtonItem = refreshButton;
     **/
    self.navigationItem.title=NSLocalizedString(@"Setting", nil);
    self.selectedBackgroundView=[[UIView alloc] init];
    [self.selectedBackgroundView setBackgroundColor:[AppConfig getTabBarTintColor]];
    [self loadSettingStrings];
    [self loadSavedSettings];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) loadSavedSettings{
    BOOL isBackgroundOn=false;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:kBackgroundDownloadSetting])
    {
        isBackgroundOn=[defaults boolForKey:kBackgroundDownloadSetting];
    }
    [self.network2Switch setOn:isBackgroundOn];
}
-(void)loadSettingStrings{
    self.network1Label.text=NSLocalizedString(@"4G/3G/2G Data Network", nil);
    self.network2Label.text=NSLocalizedString(@"Background Downloading", nil);
    self.upgrade1Label.text=NSLocalizedString(@"Upgrade To View All Featured Lectures", nil);
    self.upgrade2Label.text=NSLocalizedString(@"Restore In-App Purchase", nil);
    self.feedback1Label.text=NSLocalizedString(@"Rate Us on App Store", nil);
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows=1;
    if(section==0)
    {
        rows=1;
    }
    else if(section==1)
    {
        rows=2;
    }
    else if(section==2)
    {
        rows=1;
    }
    return rows;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header=@"";
    switch (section) {
        case 0:
            header=NSLocalizedString(@"Network", nil);
            break;
        case 1:
            header=NSLocalizedString(@"Upgrade", nil);
            break;
        case 2:
            header=NSLocalizedString(@"Feedback", nil);
            break;
        default:
            break;
    }
    if(section==0)//network
    {
        header=NSLocalizedString(@"Network", nil);
    }
    return header;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==2&&indexPath.row==0)
    {
        //click to review
        [self goToAppStore];
        
    }
    if(indexPath.section==1&&indexPath.row==0)
    {
        //click to review
        [self upgrade];
        
    }
    if(indexPath.section==1&&indexPath.row==1)
    {
        //click to review
        [self restore];
        
    }
    
}
-(void)upgrade{
    NSLog(@"Upgrade");
}
-(void)restore{
    NSLog(@"restore");
}
-(void)goToAppStore{
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.com/apps/com.TopikKorea.Topik"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/topik-korea/id515235186?mt=8&uo=4"]];
    NSLog(@"goToAppStore");

}
/**
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
 **/

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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (IBAction)network1ValueChanged:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   [defaults setBool:self.network1Switch.on forKey:kCellularNetwork];
    [defaults synchronize];
}

- (IBAction)network2ValueChanged:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.network2Switch.on forKey:kBackgroundDownloadSetting];
    [defaults synchronize];
}
@end
