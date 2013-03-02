//
//  FLSignUpViewController.h
//  OnesieTwosie
//
//  Created by Becky Carella on 2/23/13.
//  Copyright (c) 2013 Frida Lovelace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol FLSignUpDelegate
- (void)signUpViewController:(UIViewController *)signUpController didSignUpUser:(PFUser *)user;
- (void)loginFromSignUpViewController:(UIViewController *)signUpController;

@end


@interface FLSignUpViewController : UIViewController
@property (strong, nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;

@property (weak, nonatomic) IBOutlet UITextField *dogName;
- (IBAction)signUp:(id)sender;

- (IBAction)login:(id)sender;
@end
