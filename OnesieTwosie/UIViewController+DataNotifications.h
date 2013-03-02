//
//  UIViewController+DataNotifications.h
//  GiftList
//
//  Created by Becky Carella on 1/27/13.
//  Copyright (c) 2013 Super + Fun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFUser+Data.h"

@protocol PFDataNotificationDelegate
// the class name of PFObjects the view is interested in. e.g. @"User"
- (NSString *) pfObjectClassName;
@optional
- (void) objectsLoaded:(NSArray *)objects;
- (void) objectCreated:(PFObject *)object;
- (void) objectUpdated:(PFObject *)object;
@end

@interface UIViewController (DataNotifications) <PFDataNotificationDelegate>
- (void) registerForPFNotifications;
- (void) notificationOfObjectsLoaded:(NSNotification *)notification;
- (void) notificationOfObjectCreated:(NSNotification *)notification;
- (void) notificationOfObjectUpdated:(NSNotification *)notification;
@end
