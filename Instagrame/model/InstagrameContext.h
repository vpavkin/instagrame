//
//  InstagrameContext.h
//  Instagrame
//
//  Created by vpavkin on 23.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Authorizer, Requester, Synchronizer;

#define instagrameContext [InstagrameContext instance]

#pragma mark Notifications
#define DOCUMENT_IS_READY_NOTIFICATION @"document_is_ready"

#define DOCUMENT_KEY @"document"

#pragma mark Model Keys
#define USER_CLASS @"User"
#define ROOM_CLASS @"Room"
#define PICTURE_CLASS @"Picture"

#define UPDATED_AT @"updatedAt"
#define CREATED_AT @"createdAt"
#define AVATAR @"createdAt"

@interface InstagrameContext : NSObject

+ (instancetype) instance;

@property (strong, nonatomic) UIManagedDocument* document;
@property (strong, nonatomic) Authorizer* authorizer;
@property (strong, nonatomic) Requester* requester;
@property (strong, nonatomic) Synchronizer* synchronizer;

@end
