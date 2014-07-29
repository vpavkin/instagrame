//
//  InstagrameContext.m
//  Instagrame
//
//  Created by vpavkin on 23.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "InstagrameContext.h"
#import "Authorizer.h"
#import "Requester.h"

@implementation InstagrameContext

static InstagrameContext *_instance = nil;

+ (instancetype) instance
{
    static InstagrameContext *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void) setDocument:(UIManagedDocument *)document{
    _document = document;
    [[NSNotificationCenter defaultCenter] postNotificationName:DOCUMENT_IS_READY_NOTIFICATION object:self userInfo:@{DOCUMENT_KEY:_document}];
}

- (Authorizer*) authorizer{
    if (!_authorizer) {
        _authorizer = [[Authorizer alloc] init];
    }
    return _authorizer;
}

- (Requester*) requester{
    if (!_requester) {
        _requester = [[Requester alloc] init];
    }
    return _requester;
}

@end
