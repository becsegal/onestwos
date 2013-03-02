//
//  FLEditViewController.h
//  OnesieTwosie
//
//  Created by Becky Carella on 2/23/13.
//  Copyright (c) 2013 Frida Lovelace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FLEditViewController : UITableViewController <UIImagePickerControllerDelegate>
@property (strong, nonatomic) PFObject *checkin;
@property (weak, nonatomic) IBOutlet UITableViewCell *typeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *accidentCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *dateCell;
- (IBAction)save:(id)sender;
@end
