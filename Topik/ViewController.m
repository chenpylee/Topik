//
//  ViewController.m
//  Topik
//
//  Created by Lee Haining on 13-11-23.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "ViewController.h"
#import "ASIHTTPRequest.h"
#import "AppConfig.h"
#import "RemoteData.h"


@interface ViewController ()
@property IBOutlet UIActivityIndicatorView* indicator;
-(IBAction) loadData:(id)sender;
@end

@implementation ViewController
#pragma mark- Lifecircle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //[self.indicator startAnimating];
    if(isiPhone5)
    {
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Default-568h.png"]];
        self.view.backgroundColor = background;
    }
    else
    {
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Default.png"]];
        self.view.backgroundColor = background;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Loading Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadDataFromServer];
}
#pragma mark- Button Action
-(IBAction)loadData:(id)sender{
    [self loadDataFromServer];
}
#pragma mark- Download Data

- (void)loadDataFromServer{
    [self.indicator startAnimating];
    
    NSString *urlString=[AppConfig getFullDataUrl];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    NSLog(@"--------------------------------------------------");
    NSLog(@"Start Downloading from %@...",[url absoluteString]);
    
    /**
    //to show:
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //NSURL *url = [NSURL URLWithString:@"http://allseeing-i.com"];
    NSURL *url = [NSURL URLWithString:@"http://topikexam.duapp.com"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    NSLog(@"Start Downloading fro %@...",[url absoluteString]);
     **/
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    //NSString *responseString = [request responseString];
    NSData *responseData=[request responseData];
    [self parseData:responseData];
    
    [self.indicator stopAnimating];
    //to hide networkActivityIndicator:
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //[self performSegueWithIdentifier:@"showApp" sender:self];
    [self loadMainApp];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Error:%@",error);
    [self.indicator stopAnimating];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Check Network", nil)
                                                      message:NSLocalizedString(@"No Connection", nil)
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    message.tag=10;
    [message show];
    
}

-(void)loadMainApp{
    [self performSegueWithIdentifier:@"showApp" sender:self];
}
#pragma mark- parse Json data
- (void)parseData:(NSData *)responseData {
    [RemoteData processTotalJsonData:responseData];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==10)
    {
        [self loadMainApp];
        return;
    }
}
@end
