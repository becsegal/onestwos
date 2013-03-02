//
//  PFUser+Data.m
//  GiftList
//
//  Created by Becky Carella on 1/26/13.
//  Copyright (c) 2013 Super + Fun. All rights reserved.
//

#import "PFUser+Data.h"

NSString * const SPFObjectCreatedNotification = @"SPFObjectCreated";
NSString * const SPFObjectUpdatedNotification = @"SPFObjectUpdated";
NSString * const SPFObjectUpdateFailedNotification = @"SPFObjectUpdateFailed";
NSString * const SPFObjectsLoadedNotification = @"SPFObjectLoaded";

@implementation PFUser (Data)

- (PFObject *) createContactWithData:(NSMutableDictionary *)data {
    PFObject *contact = [PFObject objectWithClassName:@"Contact"];
    if (data[@"image"]) {
        PFFile * imageFile = [PFFile fileWithName:@"profile.jpg" data:UIImageJPEGRepresentation(data[@"image"], 0.5f)];
        [contact setValue:imageFile forKey:@"image"];
        [data removeObjectForKey:@"image"];
    }
    [self updateObject:contact withData:data];
    [self notify:SPFObjectCreatedNotification object:contact info:nil];
    return contact;
}

- (PFObject *) createGiftWithData:(NSMutableDictionary *)data {
    PFObject *gift = [PFObject objectWithClassName:@"Gift"];
    [self updateGift:gift withData:data];
    [self notify:SPFObjectCreatedNotification object:gift info:nil];
    return gift;
}

- (PFObject *) updateGift:(PFObject *)gift withData:(NSMutableDictionary *)data {
    if (data[@"image"]) {
        PFFile * imageFile = [PFFile fileWithName:@"image.jpg" data:UIImageJPEGRepresentation(data[@"image"], 0.5f)];
        [imageFile saveInBackground];
        [gift setValue:imageFile forKey:@"image"];
        [data removeObjectForKey:@"image"];
    }
    [self updateObject:gift withData:data];
    return gift;    
}

- (void) contacts:(Boolean)useCache {
    if (![PFUser currentUser]) return;
    PFQuery *query = [PFQuery queryWithClassName:@"Contact"];
    if (useCache) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    } else {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self notify:SPFObjectsLoadedNotification
                  object:objects
                    info:[NSDictionary dictionaryWithObjectsAndKeys:@"Contact", @"className", nil]];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


- (void) giftsForContact:(PFObject *)contact useCache:(Boolean)useCache {
    if (![PFUser currentUser]) return;
    PFQuery *query = [PFQuery queryWithClassName:@"Gift"];
    if (useCache) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    } else {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKey:@"contact" equalTo:contact];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self notify:SPFObjectsLoadedNotification
                  object:objects
                    info:[NSDictionary dictionaryWithObjectsAndKeys:@"Gift", @"className", nil]];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


- (PFObject *)updateObject:(PFObject *)object withData:(NSMutableDictionary *)data {
    for (NSString *key in [data allKeys]) {
        [object setValue:data[key] forKey:key];
    }
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error ) {
            [self notify:SPFObjectUpdatedNotification object:object info:nil];
        } else {
            [self notify:SPFObjectUpdateFailedNotification object:object info:nil];
        }
    }];
    return object;
}

- (void)notify:(NSString *)notificationName object:(id)object info:(NSDictionary *)info {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                        object:object
                                                      userInfo:info];
}

@end
