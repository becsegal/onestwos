//
//  FLLoginViewController.h
//  OnesieTwosie
//
//  Created by Becky Carella on 2/23/13.
//  Copyright (c) 2013 Frida Lovelace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol FLLoginDelegate
- (void)loginViewController:(UIViewController *)loginController didLogInUser:(PFUser *)user;
- (void)signUpFromLoginViewController:(UIViewController *)loginController;
@end


@interface FLLoginViewController : UIViewController
@property (strong, nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)login:(id)sender;
- (IBAction)signUp:(id)sender;

@end
