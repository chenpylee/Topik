//
//  AllLecturesViewController.m
//  Topik
//
//  Created by Lee Haining on 13-12-11.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "AllLecturesViewController.h"
#import "AppConfig.h"
#import "RemoteData.h"
#import "LectureLanguage.h"
#import "FeatureTableViewController.h"
#import "FreeViewController.h"
@interface AllLecturesViewController ()
{
    NSMutableArray *languages;
    NSInteger selected_lang_id;
}
@property(nonatomic,strong)UIView* selectedBackgroundView;
@end

@implementation AllLecturesViewController

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

    UIColor* tabBarTintColor=[AppConfig getTabBarTintColor];
    self.navigationController.navigationBar.tintColor = tabBarTintColor;//works for both title and button on navigationbar
    //[[UINavigationBar appearance] setTintColor:tabBarTintColor];//only work for title
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    tabBarTintColor, NSForegroundColorAttributeName,nil];
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    self.navigationItem.title=NSLocalizedString(@"All Lectures", nil);
    self.selectedBackgroundView=[[UIView alloc] init];
    [self.selectedBackgroundView setBackgroundColor:[AppConfig getTabBarTintColor]];
    languages=[RemoteData loadLanguagesToArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return languages.count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *headerTitle=@"";
    if(section==0)
    {
        headerTitle=NSLocalizedString(@"Featured Lectures", nil);
    }
    else
    {
        headerTitle=NSLocalizedString(@"Free Lectures", nil);
    }
    return headerTitle;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LanguageCell";
    LectureLanguage *lang=languages[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.section==0)
    {
        NSString *rawString=[NSString stringWithFormat:@"%@ ( %ld )",lang.lang_name,(long)lang.featuredCount];
        NSString *featuredCountString=[NSString stringWithFormat:@"%ld",(long)lang.featuredCount];
        NSMutableAttributedString *attString =
        [[NSMutableAttributedString alloc]
         initWithString: rawString];
        
        [attString addAttribute: NSForegroundColorAttributeName
                          value: [UIColor grayColor]
                          range: NSMakeRange(lang.lang_name.length+1,featuredCountString.length+4)];
        
        
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont fontWithName:@"Helvetica" size:15]
                          range: NSMakeRange(lang.lang_name.length+1,featuredCountString.length+4)];
        cell.textLabel.attributedText=attString;
    }
    else
    {
        NSString *rawString=[NSString stringWithFormat:@"%@ ( %ld )",lang.lang_name,(long)lang.freeCount];
        NSString *freeCountString=[NSString stringWithFormat:@"%ld",(long)lang.freeCount];
        NSMutableAttributedString *attString =
        [[NSMutableAttributedString alloc]
         initWithString: rawString];
        
        [attString addAttribute: NSForegroundColorAttributeName
                          value: [UIColor grayColor]
                          range: NSMakeRange(lang.lang_name.length+1,freeCountString.length+4)];
        
        
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont fontWithName:@"Helvetica" size:15]
                          range: NSMakeRange(lang.lang_name.length+1,freeCountString.length+4)];
        cell.textLabel.attributedText=attString;
    }
    cell.selectedBackgroundView=self.selectedBackgroundView;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LectureLanguage *lang=languages[indexPath.row];
    selected_lang_id=lang.lang_id;
    if(indexPath.section==0)
    {
        
        [self performSegueWithIdentifier:@"LanguageFeaturedSegue" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"LanguageFreeSegue" sender:self];
    }
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
    if([segue.identifier isEqualToString:@"LanguageFeaturedSegue"])
    {
        FeatureTableViewController *viewController=[segue destinationViewController];
        viewController.lang_id=selected_lang_id;
    }
    else if([segue.identifier isEqualToString:@"LanguageFreeSegue"])//LanguageFreeSegue
    {
        FreeViewController *viewController=[segue destinationViewController];
        viewController.lang_id=selected_lang_id;
    }
}


@end
