//
//  InstagrameDataSource.h
//  Instagrame
//
//  Created by vpavkin on 25.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

typedef enum AuthorizationServiceType : NSInteger AuthorizationServiceType;
enum AuthorizationServiceType : NSInteger {
    AuthorizationServiceVK //more to come
};

@protocol AuthorizationRequestDelegate <NSObject>

@property (strong,nonatomic,readonly) UIWebView *webView;
- (void) authorizationSuccess: (User*)me;
- (void) authorizationError: (id) error;

@end

@protocol InstagrameDataSource <NSObject>

- (BOOL) isAuthorizedWithService: (AuthorizationServiceType)service;
- (void) authorizeWithService:(AuthorizationServiceType)service delegate:(id<AuthorizationRequestDelegate>) delegate;

@end
