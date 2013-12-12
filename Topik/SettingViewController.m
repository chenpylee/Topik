//
//  SettingViewController.m
//  Topik
//
//  Created by Lee Haining on 13-12-11.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "SettingViewController.h"
#import "AppConfig.h"
#import "AppDelegate.h"
#import "TopikIAPHelper.h"

@interface SettingViewController ()
{
    BOOL isPurchased;
}
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
        isPurchased=false;
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productInforUpdated:) name:KStoreProductInforNotificationIdentifier object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completeTransaction:) name:kStoreProductCompleteTransactionNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreTransaction:) name:kStoreProductRestoreTransactionNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failTransaction:) name:kStoreProductFailTransactionNotification object:nil];
    [self updateProductInfor];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Setting"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

-(void)completeTransaction:(NSNotification*)notification{
    [self updateProductInfor];
    UIAlertView* restoreOkAlert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unlock Featured Lectures:", nil) message:NSLocalizedString(@"Purchase Restored", nil) delegate:nil cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil, nil];
    [restoreOkAlert show];
}
-(void)restoreTransaction:(NSNotification*)notification{
    [self updateProductInfor];
    if([[NSUserDefaults standardUserDefaults] boolForKey:kStoreProductIdentifier])
    {
        UIAlertView* restoreOkAlert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unlock Featured Lectures:", nil) message:NSLocalizedString(@"Purchase Restored", nil) delegate:nil cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil, nil];
        [restoreOkAlert show];
    }
    else
    {
        UIAlertView* restoreFailAlert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unlock Featured Lectures:", nil) message:NSLocalizedString(@"Purchase Restored But", nil) delegate:nil cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil, nil];
        [restoreFailAlert show];
    }
}
-(void)failTransaction:(NSNotification*)notification{
    [self updateProductInfor];
    NSDictionary *userInfo=notification.userInfo;
    if([userInfo objectForKey:kStoreProductFailErrorKey])
    {
        UIAlertView* failAlert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unlock Featured Lectures:", nil) message:[userInfo objectForKey:kStoreProductFailErrorKey] delegate:nil cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil, nil];
        [failAlert show];
    }
    else
    {
        UIAlertView* failAlert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unlock Featured Lectures:", nil) message:NSLocalizedString(@"Can not connect to the App Store", nil) delegate:nil cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil, nil];
        [failAlert show];
    }
}

-(void)productInforUpdated:(NSNotification*)notification{
    [self updateProductInfor];
}
-(void)updateProductInfor{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *upgradeString=NSLocalizedString(@"Upgrade To View All Featured Lectures", nil);
    if([defaults objectForKey:kStoreProductTitle])
    {
        NSString *productTitle=[defaults objectForKey:kStoreProductTitle];
        NSString *productPriceString=[defaults objectForKey:kStoreProductPrice];
        upgradeString=[NSString stringWithFormat:@"%@ %@",upgradeString,productPriceString];
    }
    isPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:kStoreProductIdentifier];
    
    if(isPurchased)
    {
        NSString *rawString=[NSString stringWithFormat:@"%@ (%@)",upgradeString,NSLocalizedString(@"unlocked", nil)];
        NSMutableAttributedString *attString =
        [[NSMutableAttributedString alloc]
         initWithString: rawString];
        
        [attString addAttribute: NSForegroundColorAttributeName
                          value: [UIColor grayColor]
                          range: NSMakeRange(0,rawString.length)];
        
        
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont fontWithName:@"Helvetica" size:15]
                          range: NSMakeRange(0,rawString.length)];
        self.upgrade1Label.attributedText=attString;
        
        
        NSString *rawString1=[NSString stringWithFormat:@"%@",NSLocalizedString(@"Restore In-App Purchase", nil)];
        NSMutableAttributedString *attString1 =
        [[NSMutableAttributedString alloc]
         initWithString: rawString1];
        
        [attString1 addAttribute: NSForegroundColorAttributeName
                          value: [UIColor grayColor]
                          range: NSMakeRange(0,rawString1.length)];
        
        
        [attString1 addAttribute: NSFontAttributeName
                          value:  [UIFont fontWithName:@"Helvetica" size:15]
                          range: NSMakeRange(0,rawString1.length)];
        self.upgrade2Label.attributedText=attString1;
    }
    else
    {
        self.upgrade1Label.text=upgradeString;
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    //self.upgrade1Label.text=NSLocalizedString(@"Upgrade To View All Featured Lectures", nil);
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
        if(!isPurchased)
        {
            [self upgrade];
        }
        else
        {
            [self showAlreadyUnlockedMsg];

        }
        
    }
    if(indexPath.section==1&&indexPath.row==1)
    {
        //click to review
        if(!isPurchased)
        {
            [self restore];
        }
        else
        {
            [self showAlreadyUnlockedMsg];
        }
        
    }
    
}
-(void)showAlreadyUnlockedMsg{
    UIAlertView* addAlert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unlock Featured Lectures:", nil) message:NSLocalizedString(@"Already Unlocked", nil) delegate:nil cancelButtonTitle:@"OK"
        otherButtonTitles:nil, nil];
    [addAlert show];
}
-(void)upgrade{
    NSLog(@"Upgrade");
    AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    SKProduct *product =appDelegate.product;
    if(product)
    {
        NSLog(@"Buying %@...", product.productIdentifier);
        [[TopikIAPHelper sharedInstance] buyProduct:product];
    }
    else
    {
        [self showFailMsg];
    }

}
-(void) showFailMsg{
    /**
    [[TopikIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            for(SKProduct *product in products)
            {
                NSLog(@"product:%@",product.localizedDescription);
                if([product.productIdentifier isEqualToString:kStoreProductIdentifier])
                {
                    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
                    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
                    [numberFormatter setLocale:product.priceLocale];
                    //NSString *symbol = [product.priceLocale objectForKey:NSLocaleCurrencySymbol];
                    NSString *currencyString = [NSString stringWithFormat:@"%@",[numberFormatter stringFromNumber:product.price]];
                    [defaults setValue:product.localizedTitle forKey:kStoreProductTitle];
                    [defaults setValue:product.localizedDescription forKey:kStoreProductDescription];
                    [defaults setValue:currencyString forKey:kStoreProductPrice];
                    //[defaults setValue:product forKey:kStoreProductObject];
                }
            }
            [defaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:KStoreProductInforNotificationIdentifier object:self];
        }
    }];
     **/
    UIAlertView* addAlert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unlock Featured Lectures:", nil) message:NSLocalizedString(@"Can not connect to the App Store", nil) delegate:nil cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil, nil];
    [addAlert show];
    
}

-(void)restore{
    NSLog(@"restore");
    [[TopikIAPHelper sharedInstance] restoreCompletedTransactions];
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
