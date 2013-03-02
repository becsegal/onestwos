//
//  FLCheckinViewController.m
//  OnesieTwosie
//
//  Created by Becky Carella on 2/23/13.
//  Copyright (c) 2013 Frida Lovelace. All rights reserved.
//

#import "FLCheckinViewController.h"
#import "FLEditViewController.h"

@interface FLCheckinViewController ()
@property (nonatomic, strong) PFObject *latestCheckin;
@end

@implementation FLCheckinViewController

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
    [self ensureLogin];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"checkin view did appear");
    if (self.latestCheckin == NULL) {
        self.editButton.enabled = NO;
        NSLog(@"getting latest checkin");
        PFQuery *query = [PFQuery queryWithClassName:@"Checkin"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query orderByDescending:@"createdAt"];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!object) {
                NSLog(@"The getFirstObject request failed. %@", error);
            } else {
                // The find succeeded.
                NSLog(@"latest checkin is %@", object);
                [self updateLatestCheckin:object];
                self.editButton.enabled = YES;
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateLatestCheckin:(PFObject *)checkin {
    self.latestCheckin = checkin;
    NSString *latestAction = nil;
    if ([@"onesie" isEqualToString:self.latestCheckin[@"type"]]) {
        latestAction = @"onesied";
    } else if ([@"twosie" isEqualToString:self.latestCheckin[@"type"]]) {
        latestAction = @"twosied";
    } else if ([@"play" isEqualToString:self.latestCheckin[@"type"]]) {
        latestAction = @"played";
    } else if ([@"nap" isEqualToString:self.latestCheckin[@"type"]]) {
        latestAction = @"napped";
    } else if ([@"eat" isEqualToString:self.latestCheckin[@"type"]]) {
        latestAction = @"ate";
    }
    self.latestTypeLabel.text = [NSString stringWithFormat:@"%@ last %@", [PFUser currentUser].username, latestAction];
    PFQuery *query = [PFQuery queryWithClassName:@"Tips"];
    if (self.latestCheckin[@"type"] == @"onesie" || self.latestCheckin[@"type"] == @"twosie") {
        [query whereKey:@"TYPE" equalTo:@"BATHROOM"];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSUInteger randomIndex = arc4random() % objects.count;
            self.tipText.text = ((PFObject *)[objects objectAtIndex:randomIndex])[@"TIP"];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"preparing for segue %@", segue.identifier);
    if ([segue.identifier isEqualToString:@"EditCheckin"]) {
        [((FLEditViewController *)segue.destinationViewController) setCheckin:self.latestCheckin];
    }
}

- (IBAction)addOnesie:(id)sender {
    [self addCheckin:@"onesie"];
}

- (IBAction)addTwosie:(id)sender {
    [self addCheckin:@"twosie"];
}

- (IBAction)addEat:(id)sender {
    [self addCheckin:@"eat"];
}

- (IBAction)addSleep:(id)sender {
    [self addCheckin:@"nap"];
}

- (IBAction)addPlay:(id)sender {
    [self addCheckin:@"play"];
}

- (void)addCheckin:(NSString *)type {
    PFObject *checkin = [PFObject objectWithClassName:@"Checkin"];
    [checkin setObject:type forKey:@"type"];
    [checkin setObject:[NSDate date] forKey:@"startedAt"];
    [checkin setObject:[NSNumber numberWithBool:NO] forKey:@"accident"];
    [checkin setValue:[PFUser currentUser] forKey:@"user"];
    [checkin saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self updateLatestCheckin:checkin];
        } else {
            NSLog(@"error %@", error);
        }
    }];
}

@end
