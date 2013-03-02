//
//  FLCheckinViewController.h
//  OnesieTwosie
//
//  Created by Becky Carella on 2/23/13.
//  Copyright (c) 2013 Frida Lovelace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Authenticated.h"
#import <Parse/Parse.h>

@interface FLCheckinViewController : UIViewController
- (IBAction)logout:(id)sender;
- (IBAction)addOnesie:(id)sender;
- (IBAction)addTwosie:(id)sender;

- (IBAction)addEat:(id)sender;
- (IBAction)addSleep:(id)sender;
- (IBAction)addPlay:(id)sender;
- (IBAction)editLatestCheckin:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UITextView *tipText;

@property (weak, nonatomic) IBOutlet UILabel *latestTypeLabel;
@end
