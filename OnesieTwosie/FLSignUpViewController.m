//
//  FLSignUpViewController.m
//  OnesieTwosie
//
//  Created by Becky Carella on 2/23/13.
//  Copyright (c) 2013 Frida Lovelace. All rights reserved.
//

#import "FLSignUpViewController.h"

@implementation FLSignUpViewController

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
    PFUser *user = [PFUser user];
    user.username = self.username.text;
    user.password = self.password.text;
    user.email = self.email.text;
    
    // other fields can be set just like with PFObject
    //[user setObject:self.dogName forKey:@"dogName"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self.delegate signUpViewController:self didSignUpUser:user];
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"sign up failed %@", errorString);
        }
    }];
}

- (IBAction)login:(id)sender {
    [self.delegate loginFromSignUpViewController:self];
}
@end
