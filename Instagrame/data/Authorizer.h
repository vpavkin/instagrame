//
//  Authorizer.h
//  Instagrame
//
//  Created by vpavkin on 29.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;

#define EMAIL_KEY @"email"
#define PASSWORD_KEY @"password"

typedef enum AuthorizationServiceType : NSInteger AuthorizationServiceType;
enum AuthorizationServiceType : NSInteger {
    AuthorizationServiceInstagrame, //more to come
    AuthorizationServiceVK
};

@protocol AuthorizationRequestDelegate <NSObject>

@property (strong,nonatomic,readonly) UIWebView *webView;
- (void) authorizationSuccess: (User*)me;
- (void) authorizationError: (id) error;
@end

@interface Authorizer : NSObject

- (BOOL) isAuthorizedWithService: (AuthorizationServiceType)service;
- (void) authorizeWithService:(AuthorizationServiceType)service
                     delegate:(id<AuthorizationRequestDelegate>) delegate
                         data:(NSDictionary*) data;

@property (strong, nonatomic, readonly) NSString* myEmail;
@property (strong, nonatomic, readonly) NSString* myPassword;

@end
