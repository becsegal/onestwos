//
//  PFUser+Data.h
//  GiftList
//
//  Created by Becky Carella on 1/26/13.
//  Copyright (c) 2013 Super + Fun. All rights reserved.
//

#import <Parse/Parse.h>

extern NSString * const SPFObjectCreatedNotification;
extern NSString * const SPFObjectUpdatedNotification;
extern NSString * const SPFObjectUpdateFailedNotification;
extern NSString * const SPFObjectsLoadedNotification;


@interface PFUser (Data)
- (PFObject *) createContactWithData:(NSMutableDictionary *)data;
- (PFObject *) createGiftWithData:(NSMutableDictionary *)data;
- (PFObject *) updateGift:(PFObject *)gift withData:(NSMutableDictionary *)data;

- (void) contacts:(Boolean)useCache;
- (void) giftsForContact:(PFObject *)contact useCache:(Boolean)useCache;
@end
