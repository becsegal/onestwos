//
//  UIViewController+Authenticated.h
//  GiftList
//
//  Created by Becky Carella on 1/2/13.
//  Copyright (c) 2013 Super + Fun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "FLLoginViewController.h"
#import "FLSignUpViewController.h"

@interface UIViewController (Authenticated) <FLLoginDelegate, FLSignUpDelegate>
- (void)addObservers;
- (void)ensureLogin ;
@end
