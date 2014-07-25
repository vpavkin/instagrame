//
//  InstagrameContext.m
//  Instagrame
//
//  Created by vpavkin on 23.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "InstagrameContext.h"
#import "LocalDataSource.h"

@implementation InstagrameContext

- (id <InstagrameDataSource>) data{
    if (!_data) {
        _data = [[LocalDataSource alloc] init];
    }
    return _data;
}

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

@end
