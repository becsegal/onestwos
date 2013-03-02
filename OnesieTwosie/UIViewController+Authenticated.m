//
//  UIViewController+Authenticated.m
//  GiftList
//
//  Created by Becky Carella on 1/2/13.
//  Copyright (c) 2013 Super + Fun. All rights reserved.
//

#import "UIViewController+Authenticated.h"
#import "FLAppDelegate.h"
#import "FLLoginViewController.h"
#import "FLSignUpViewController.h"


@implementation UIViewController (Authenticated) 

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecameActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

- (void)appBecameActive {
    [self ensureLogin];
}

- (void)ensureLogin {
    if (![PFUser currentUser]) {
        [self showLogin];
    } else {
        NSLog(@"user is already logged in! %@", [PFUser currentUser]);
    }
}

- (void)showLogin {
    NSLog(@"showLogin");
    
    FLLoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginController"];
    loginViewController.delegate = self;
    [self presentModalViewController:loginViewController animated:NO];
}

- (void)showSignUp {
    NSLog(@"showSignUp");
    FLSignUpViewController *signUpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpController"];
    signUpViewController.delegate = self;
    [self presentModalViewController:signUpViewController animated:NO];
}

#pragma mark FLLoginViewControllerDelegate

- (void)loginViewController:(FLLoginViewController *)loginController didLogInUser:(PFUser *)user {
    NSLog(@"user logged in! %@", [PFUser currentUser]);
    [loginController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)signUpFromLoginViewController:(UIViewController *)loginController {
    NSLog(@"sign up instead");
    [loginController dismissViewControllerAnimated:NO completion:^{
        [self showSignUp];
    }];
}


#pragma mark FLSignUpViewControllerDelegate

- (void)signUpViewController:(FLSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    NSLog(@"user signed up! %@", [PFUser currentUser]);
    [signUpController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)loginFromSignUpViewController:(UIViewController *)signUpController {
    NSLog(@"login instead");
    [signUpController dismissViewControllerAnimated:NO completion:^{
        [self showLogin];
    }];
}

@end
