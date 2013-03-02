//
//  FLChartViewController.m
//  OnesieTwosie
//
//  Created by Becky Carella on 2/23/13.
//  Copyright (c) 2013 Frida Lovelace. All rights reserved.
//

#import "FLChartViewController.h"
#import <Parse/Parse.h>

@interface FLChartViewController ()

@end

@implementation FLChartViewController

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
}

- (void)viewDidAppear:(BOOL)animated {
    NSString *urlString =[NSString stringWithFormat:@"http://onesietwosie.herokuapp.com/profile_mobile/%@", [PFUser currentUser].objectId];
    NSLog(@"loading url %@", urlString);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
