//
//  InstagrameContext.h
//  Instagrame
//
//  Created by vpavkin on 23.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Authorizer, Requester;

#define instagrameContext [InstagrameContext instance]

#define DOCUMENT_IS_READY_NOTIFICATION @"document_is_ready"

#define DOCUMENT_KEY @"document"

@interface InstagrameContext : NSObject

+ (instancetype) instance;

@property (strong, nonatomic) UIManagedDocument* document;
@property (strong, nonatomic) Authorizer* authorizer;
@property (strong, nonatomic) Requester* requester;




@end
