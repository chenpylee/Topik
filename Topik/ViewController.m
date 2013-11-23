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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //[self.indicator startAnimating];
}
- (void)loadDataFromServer{
    [self.indicator startAnimating];
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
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Error:%@",error);
    [self.indicator stopAnimating];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)loadData:(id)sender{
    [self loadDataFromServer];
}
@end
