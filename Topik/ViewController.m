//
//  ViewController.m
//  Topik
//
//  Created by Lee Haining on 13-11-23.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "ViewController.h"
#import "ASIHTTPRequest.h"
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
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Default-568.png"]];
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
#pragma mark- Button Action
-(IBAction)loadData:(id)sender{
    [self loadDataFromServer];
}
#pragma mark- Download Data

- (void)loadDataFromServer{
    [self.indicator startAnimating];
    
    //to show:
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //NSURL *url = [NSURL URLWithString:@"http://allseeing-i.com"];
    NSURL *url = [NSURL URLWithString:@"http://topikexam.duapp.com"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    NSLog(@"Start Downloading fro %@...",[url absoluteString]);
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSLog(@"Data:%@",responseString);
    [self.indicator stopAnimating];
    //to hide networkActivityIndicator:
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //[self performSegueWithIdentifier:@"showApp" sender:self];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Error:%@",error);
    [self.indicator stopAnimating];
    //to hide networkActivityIndicator:
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
@end
