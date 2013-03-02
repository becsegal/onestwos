//
//  FLLoginViewController.m
//  OnesieTwosie
//
//  Created by Becky Carella on 2/23/13.
//  Copyright (c) 2013 Frida Lovelace. All rights reserved.
//

#import "FLLoginViewController.h"

@interface FLLoginViewController ()

@end

@implementation FLLoginViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUp:(id)sender {
    [self.delegate signUpFromLoginViewController:self];
}

- (IBAction)login:(id)sender {
    [PFUser logInWithUsernameInBackground:self.username.text password:self.password.text
        block:^(PFUser *user, NSError *error) {
            if (user) {
                [self.delegate loginViewController:self didLogInUser:user];
            } else {
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                NSLog(@"sign up failed %@", errorString);
            }
        }];
}
@end
