//
//  FLEditViewController.m
//  OnesieTwosie
//
//  Created by Becky Carella on 2/23/13.
//  Copyright (c) 2013 Frida Lovelace. All rights reserved.
//

#import "FLEditViewController.h"

@interface FLEditViewController ()
@property (nonatomic, strong) UIImageView *checkinImage;
@property (strong, nonatomic)  UITextView *note;

@end

@implementation FLEditViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated    
{
    NSLog(@"edit view did appear");
    [super viewDidAppear:animated];
    self.typeCell.textLabel.text = self.checkin[@"type"];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd HH:mm"];
    
    if ([@"onesie" isEqualToString:self.checkin[@"type"]] || [@"twosie" isEqualToString:self.checkin[@"type"]]) {
        self.dateCell.textLabel.text = [format stringFromDate:self.checkin[@"startedAt"]];
        if ((NSNumber *)self.checkin[@"accident"] == [NSNumber numberWithBool:NO]) {
            self.accidentCell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            self.accidentCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else {
        self.dateCell.textLabel.text = [NSString stringWithFormat:@"Start: %@", [format stringFromDate:self.checkin[@"startedAt"]]];
        if (self.checkin[@"endedAt"]) {
            self.accidentCell.textLabel.text = [NSString stringWithFormat:@"End: %@", [format stringFromDate:self.checkin[@"endedAt"]]];
        } else {
            self.accidentCell.textLabel.text = [NSString stringWithFormat:@"End: %@", [format stringFromDate:self.checkin[@"startedAt"]]];
            self.accidentCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        }
    }
        

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)chooseImage {
    NSLog(@"chooseImage");
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:NULL];
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected index path %d, %d", indexPath.section, indexPath.row);
    if (indexPath.section == 2) {
        if ((NSNumber *)self.checkin[@"accident"] == [NSNumber numberWithBool:YES]) {
            [self.checkin setObject:[NSNumber numberWithBool:NO] forKey:@"accident"];
            self.accidentCell.accessoryType = UITableViewCellAccessoryNone;
            NSLog(@"was an accident: %@", (NSNumber *)self.checkin[@"accident"]);
        } else {
            [self.checkin setObject:[NSNumber numberWithBool:YES] forKey:@"accident"];
            self.accidentCell.accessoryType = UITableViewCellAccessoryCheckmark;
            NSLog(@"was an accident: %@", (NSNumber *)self.checkin[@"accident"]);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 115.f;
    } else {
        return 0.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        UIView *sectionFooter = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 200.f)];
        self.checkinImage = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 20.f, 300.f, 115.f)];
        self.checkinImage.userInteractionEnabled = YES;
        self.checkinImage.contentMode = UIViewContentModeScaleAspectFill;
        self.checkinImage.clipsToBounds = YES;
        
        UIGestureRecognizer *imageTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImage)];
        [self.checkinImage addGestureRecognizer:imageTapRecognizer];
        
        if (self.checkin[@"image"]) {
            self.checkinImage.image = [UIImage imageWithData:[self.checkin[@"image"] getData]];
        } else {
            self.checkinImage.image = [UIImage imageNamed:@"imagePlaceholder.png"];
        }
        
        [sectionFooter addSubview:self.checkinImage];
        return sectionFooter;
    }
    return nil;
}





# pragma mark - Image Picker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	self.checkinImage.image = info[@"UIImagePickerControllerOriginalImage"];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)save:(id)sender {
    NSData *imageData = UIImagePNGRepresentation(self.checkinImage.image);
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    [imageFile save];
    
    [self.checkin setObject:imageFile             forKey:@"image"];
    
    NSLog(@"saving checkin: %@", (NSNumber *)self.checkin[@"accident"]);
    [self.checkin saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"error: %@", error);
        }
    }];
}
@end
