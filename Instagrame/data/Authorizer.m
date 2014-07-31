//
//  Authorizer.m
//  Instagrame
//
//  Created by vpavkin on 29.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "Authorizer.h"
#import "FDKeychain.h"
#import "VkontakteSDK.h"
#import "InstagrameContext.h"
#import "User.h"
#import "User+Addon.h"
#import "Requester.h"
#import "Synchronizer.h"

@interface Authorizer () <VKRequestDelegate,VKConnectorDelegate>

@property (strong, nonatomic, readwrite) NSString* myEmail;
@property (strong, nonatomic, readwrite) NSString* myPassword;

@property (weak,nonatomic) id<AuthorizationRequestDelegate> authDelegate;
@property (strong,nonatomic,readonly) VKRequestManager* requestsMananger;

@end

@implementation Authorizer

#pragma mark private

- (VKRequestManager*) requestsMananger{
    if (!_requestsMananger) {
        _requestsMananger = [[VKRequestManager alloc] initWithDelegate:self
                                                                  user:[VKUser currentUser]];
    }
    return _requestsMananger;
}

- (void) loadUserData {
    NSLog(@"Authorizing with VK, userId=%d...", [VKUser currentUser].accessToken.userID);
    [self.requestsMananger info];
}

@synthesize requestsMananger = _requestsMananger;

- (instancetype) init{
    self = [super init];
    if (self) {

    }
    return self;
}

- (NSString*) myEmail{
    return [FDKeychain itemForKey: EMAIL_KEY
                       forService: @"Instagrame"
                            error:NULL];
}

- (NSString*) myPassword{
    return  [FDKeychain itemForKey: EMAIL_KEY
                        forService: @"Instagrame"
                             error:NULL];
}

- (void) setMyEmail:(NSString*) email{
    [FDKeychain saveItem: email
                  forKey: EMAIL_KEY
              forService: @"Instagrame"
                   error:NULL];
}

- (void) setMyPassword: (NSString*) password{
    [FDKeychain saveItem: password
                  forKey: PASSWORD_KEY
              forService: @"Instagrame"
                   error:NULL];
}

- (BOOL) isAuthorizedWithService: (AuthorizationServiceType)service{
    switch (service) {
        case AuthorizationServiceVK:{
            VKUser *user = [VKUser currentUser];
            return user && user.accessToken.isValid;
        }
        case AuthorizationServiceInstagrame:
            return self.myEmail.length && self.myPassword.length;
    }
    return NO;
}

- (void) authorizeWithService:(AuthorizationServiceType)service
                     delegate:(id<AuthorizationRequestDelegate>)delegate
                         data:(NSDictionary*) data {
    
    self.authDelegate = delegate;
    
    switch (service) {
        case AuthorizationServiceVK:{
            
            VKUser* user = [VKUser currentUser];
            if (user && user.accessToken.isValid) {
                [self loadUserData];
                return;
            }
            
            [[VKConnector sharedInstance] startWithAppID: @"4473650"
                                              permissons: @[@"wall", @"friends", @"offline", @"email"]
                                                 webView: self.authDelegate.webView
                                                delegate: self];
            break;
        }
        case AuthorizationServiceInstagrame:{
            NSLog(@"Authorizing '%@' with password '%@'", data[EMAIL_KEY], data[PASSWORD_KEY]);
            [instagrameContext.requester userForEmail:data[EMAIL_KEY]
                                          andPassword:data[PASSWORD_KEY]
                                           completion:^(BOOL ok, NSDictionary* result){
#warning add error forwarding
                                               if (ok && result) {
                                                   self.myEmail = data[EMAIL_KEY];
                                                   self.myPassword = data[PASSWORD_KEY];
                                                   [self.authDelegate authorizationSuccess:[instagrameContext.synchronizer syncUser:[User convertFromParseUser:result]]];
                                               }else{
                                                   [self.authDelegate authorizationError:[NSError errorWithDomain:@"authorize" code:0 userInfo:@{NSLocalizedDescriptionKey:@"Wrong email or password"}]];
                                               }
                                               
                                           }];
            break;
        }
    }
}

- (void) createUserForVkInfo: (NSDictionary*) info{
    NSDictionary* preparedInfo = [User convertFromVkUser:info];
    [instagrameContext.requester addUserFromVk:preparedInfo
                                    completion:^(BOOL ok, NSDictionary* result){
                                        if (ok && result) {
                                            [self.authDelegate authorizationSuccess:[instagrameContext.synchronizer syncUser:[User convertFromParseUser:result]]];
                                        }else{
                                            [self.authDelegate authorizationError:@"Couldn't create User form VK info"];
                                        }
                                    }];
}
#pragma mark - VKConnectorDelegate

- (void) VKConnector:(VKConnector *)connector
accessTokenRenewalSucceeded:(VKAccessToken *)accessToken {
    NSLog(@"VK token renewed: %@", accessToken);
    [self loadUserData];
}

- (void) VKConnector:(VKConnector *)connector
accessTokenRenewalFailed:(VKAccessToken *)accessToken {
    NSLog(@"User denied to authorize app.");
}

- (void)VKConnector:(VKConnector *)connector willShowWebView:(UIWebView *)webView{
    self.authDelegate.webView.hidden = NO;
}

- (void)VKConnector:(VKConnector *)connector willHideWebView:(UIWebView *)webView{
    self.authDelegate.webView.hidden = YES;
}

#pragma mark - VKRequestDelegate

- (void)VKRequest:(VKRequest *)request response:(id)response{
    NSLog(@"Request '%@' is ok", request.signature);
    
    if ([request.signature isEqualToString:@"info:"]) {
        NSDictionary *info = response[@"response"][0];
        NSLog(@"User info:\n%@", info);
        [instagrameContext.requester userForVKId:info[@"uid"]
                                       completion:^(BOOL ok, NSDictionary* result){
                                           if (ok && result) {
                                               [self.authDelegate authorizationSuccess:[instagrameContext.synchronizer syncUser:[User convertFromParseUser:result]]];
                                           }else if(ok) {
                                               [self createUserForVkInfo:info];
                                           }else{
                                               [self.authDelegate authorizationError:@"Unknown Error"];
                                           }
                                       }];

    }
}

- (void)VKRequest:(VKRequest *)request captchaSid:(NSString *)captchaSid captchaImage:(NSURL *)captchaImage{
    NSLog(@"captcha");
}

- (void)VKRequest:(VKRequest *)request responseError:(NSError *)error{
    NSLog(@"error: %@", error);
}


@end
