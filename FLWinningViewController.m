//
//  FLWinningViewController.m
//  OnesieTwosie
//
//  Created by Becky Carella on 2/23/13.
//  Copyright (c) 2013 Frida Lovelace. All rights reserved.
//

#import "FLWinningViewController.h"
#import <Parse/Parse.h>

@interface FLWinningViewController ()

@end

@implementation FLWinningViewController

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

- (void)viewDidAppear:(BOOL)animated  
{
    [super viewDidAppear:animated];
    NSDate *weekAgo = [NSDate dateWithTimeInterval:-604800 sinceDate:[NSDate date]];
    PFQuery *query = [PFQuery queryWithClassName:@"Checkin"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKey:@"startedAt" greaterThan:weekAgo];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            int onesieCount = 0;
            int twosieCount = 0;
            int accidentCount = 0;
            int playTime = 0;
            NSDate *lastAccidentDate = nil;
            for (PFObject *obj in objects) {
                NSLog(@"checkin: %@", obj);
                if ([@"onesie" isEqualToString:obj[@"type"]]) {
                    onesieCount += 1;
                }
                if ([@"twosie" isEqualToString:obj[@"type"]]) {
                    twosieCount += 1;
                }
                if ([@"play" isEqualToString:obj[@"type"]]) {
                    // TODO: add play time
                }
                if ((NSNumber *)obj[@"accident"] == [NSNumber numberWithBool:YES]) {
                    lastAccidentDate = obj[@"startedAt"];
                }
            }
            NSString *output = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@",
                                [NSString stringWithFormat:@"%.2f onesies per day", onesieCount/7.f],
                                [NSString stringWithFormat:@"%.2f twosies per day", twosieCount/7.f],
                                [NSString stringWithFormat:@"%.0f hours since last accident", [[NSDate date] timeIntervalSinceDate:lastAccidentDate]/60.f],
                                @"15 hours played this week"];
            self.summary.text = output;
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
