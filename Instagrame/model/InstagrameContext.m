//
//  InstagrameContext.m
//  Instagrame
//
//  Created by vpavkin on 23.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "InstagrameContext.h"

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

@end
