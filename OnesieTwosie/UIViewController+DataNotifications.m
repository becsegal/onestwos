//
//  UIViewController+DataNotifications.m
//  GiftList
//
//  Created by Becky Carella on 1/27/13.
//  Copyright (c) 2013 Super + Fun. All rights reserved.
//

#import "UIViewController+DataNotifications.h"

@implementation UIViewController (DataNotifications)

- (NSString *)pfObjectClassName {
    return nil;
}

- (void) registerForPFNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationOfObjectsLoaded:) name:SPFObjectsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationOfObjectCreated:) name:SPFObjectCreatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationOfObjectUpdated:) name:SPFObjectUpdatedNotification object:nil];
}

- (void) notificationOfObjectsLoaded:(NSNotification *)notification {
    if ([self pfObjectClassName] == nil) { return; }
    NSDictionary *info = notification.userInfo;
    NSString *className = info[@"className"];
    if (className && [className isEqualToString:[self pfObjectClassName]]) {
        if ([self respondsToSelector:@selector(objectsLoaded:)]) {
            [self objectsLoaded:notification.object];
        }
    }
}

- (void) notificationOfObjectCreated:(NSNotification *)notification {
    if ([self pfObjectClassName] == nil) { return; }
    if (![notification.object isKindOfClass:[PFObject class]]) { return; }
    PFObject *obj = notification.object;
    if (obj && [[obj className] isEqualToString:[self pfObjectClassName]]) {
        if ([self respondsToSelector:@selector(objectCreated:)]) {
            [self objectCreated:notification.object];
        }
    }    
}

- (void) notificationOfObjectUpdated:(NSNotification *)notification {
    if ([self pfObjectClassName] == nil) { return; }
    if (![notification.object isKindOfClass:[PFObject class]]) { return; }
    PFObject *obj = notification.object;
    if (obj && [[obj className] isEqualToString:[self pfObjectClassName]]) {
        if ([self respondsToSelector:@selector(objectUpdated:)]) {
            [self objectUpdated:notification.object];
        }
    }
}




@end
