//
//  Authorizer.m
//  Instagrame
//
//  Created by vpavkin on 29.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "Authorizer.h"
#import "KeychainItemWrapper.h"
#import "VkontakteSDK.h"
#import "InstagrameContext.h"
#import "Requester.h"

@interface Authorizer () <VKRequestDelegate,VKConnectorDelegate>

@property (weak,nonatomic) id<AuthorizationRequestDelegate> authDelegate;
@property (strong,nonatomic,readonly) VKRequestManager* requestsMananger;

@property (nonatomic, strong) KeychainItemWrapper *passwordItem;
@property (nonatomic, strong) KeychainItemWrapper *emailItem;

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
        [self loadKeychainData];
    }
    return self;
}

- (void) loadKeychainData{
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:PASSWORD_KEY accessGroup:@"YOUR_APP_ID_HERE.com.instagrame"];
	self.passwordItem = wrapper;
    
	wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:EMAIL_KEY accessGroup:@"YOUR_APP_ID_HERE.com.instagrame"];
    self.emailItem = wrapper;
}

- (NSString*) myEmail{
    return  [self.emailItem objectForKey:EMAIL_KEY];
}

- (NSString*) myPassword{
    return  [self.passwordItem objectForKey:PASSWORD_KEY];
}

#pragma mark InstagrameDataSource

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
                                              permissons: @[@"wall", @"friends", @"offline"]
                                                 webView: self.authDelegate.webView
                                                delegate: self];
            break;
        }
        case AuthorizationServiceInstagrame:{
            NSLog(@"Authorizing '%@' with password '%@'", data[EMAIL_KEY], data[PASSWORD_KEY]);
            [instagrameContext.requester userForEmail:data[EMAIL_KEY]
                                          andPassword:data[PASSWORD_KEY]
                                           completion:^(BOOL ok, NSDictionary* result){
                                               NSLog(@"%@", result);
                                           }];
            break;
        }
    }
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
        [self loadedMyInfo:info];
    }
}

- (void)loadedMyInfo:(NSDictionary*)info{
    
    NSString* name = info[@"first_name"];
    NSString *imgPath = info[@"photo_100"];
    
    VKStorageItem *item = [[VKStorage sharedStorage]
                           storageItemForUserID:[VKUser currentUser].accessToken.userID];
    
    NSData *imgData = [item.cache cacheForURL:[NSURL URLWithString:imgPath]];
    
    if (nil == imgData) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imgTmpData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgPath]];
            
            //  добавляем изображение в кэш и устанавливаем время жизни кэша равным одному дню
            [item.cache addCache:imgTmpData
                          forURL:[NSURL URLWithString:imgPath]
                        liveTime:VKCacheLiveTimeOneMonth];
//            [self createUser:name img:imgTmpData];
//            dispatch_async(dispatch_get_main_queue(), ^
//                           {
//                               [self.authDelegate authorizationSuccess:[InstagrameContext instance].me];
//                           });
        });
    } else {
        
//        [self createUser:name img:imgData];
//        [self.authDelegate authorizationSuccess:[InstagrameContext instance].me];
    }
    
}

- (void)VKRequest:(VKRequest *)request captchaSid:(NSString *)captchaSid captchaImage:(NSURL *)captchaImage{
    NSLog(@"captcha");
}

- (void)VKRequest:(VKRequest *)request responseError:(NSError *)error{
    NSLog(@"error: %@", error);
}


@end
