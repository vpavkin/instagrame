//
//  LocalDataSource.m
//  Instagrame
//
//  Created by vpavkin on 25.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "LocalDataSource.h"
#import "VkontakteSDK.h"
#import "InstagrameContext.h"
//when implementing sources for other services, use separate class for each service, and gather them in the dataSource

@interface LocalDataSource () <VKRequestDelegate,VKConnectorDelegate>

@property (weak,nonatomic) id<AuthorizationRequestDelegate> authDelegate;
@property (strong,nonatomic,readonly) VKRequestManager* requestsMananger;
@property (strong,nonatomic) NSDictionary* mockMe;
@end

@implementation LocalDataSource

#pragma mark mock data

- (NSDictionary*) mockMe{
    return @{@"uid": @"1342", @"karma": @14, @"coins": @5};
}

#pragma mark private

- (VKRequestManager*) requestsMananger{
    if (!_requestsMananger) {
        _requestsMananger = [[VKRequestManager alloc] initWithDelegate:self
                                                                  user:[VKUser currentUser]];
    }
    return _requestsMananger;
}

- (void) loadUserData {
    [self.requestsMananger info];
}

- (void) createUser: (NSString*) name img:(NSData*) img {
    User* u = [[User alloc] initWithName:name
                                  avatar:[UIImage imageWithData:img]];
    u.uid = self.mockMe[@"uid"];
    u.karma = [self.mockMe[@"karma"] intValue];
    u.coins = [self.mockMe[@"coins"] intValue];
    [InstagrameContext instance].me = u;
}
@synthesize requestsMananger = _requestsMananger;

#pragma mark InstagrameDataSource

- (BOOL) isAuthorizedWithService: (AuthorizationServiceType)service{
    return [VKUser currentUser] != nil;
}

- (void) authorizeWithService:(AuthorizationServiceType)service delegate:(id<AuthorizationRequestDelegate>)delegate{
    
    self.authDelegate = delegate;
    
    VKUser * user = [VKUser currentUser];
    if (user) {
        [self loadUserData];
        return;
    }
    
    self.authDelegate.webView.hidden = NO;
    [[VKConnector sharedInstance] startWithAppID: @"4473650"
                                      permissons: @[@"wall", @"friends"]
                                         webView: self.authDelegate.webView
                                        delegate: self];
}

#pragma mark - VKConnectorDelegate

- (void) VKConnector:(VKConnector *)connector
accessTokenRenewalSucceeded:(VKAccessToken *)accessToken
{
    NSLog(@"OK: %@", accessToken);
    self.authDelegate.webView.hidden = YES;
    [self loadUserData];
}

- (void) VKConnector:(VKConnector *)connector
accessTokenRenewalFailed:(VKAccessToken *)accessToken
{
    NSLog(@"User denied to authorize app.");
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
            [self createUser:name img:imgTmpData];
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               [self.authDelegate authorizationSuccess:[InstagrameContext instance].me];
                           });
        });
    } else {

        [self createUser:name img:imgData];
        [self.authDelegate authorizationSuccess:[InstagrameContext instance].me];
    }

}

- (void)VKRequest:(VKRequest *)request captchaSid:(NSString *)captchaSid captchaImage:(NSURL *)captchaImage{
    NSLog(@"captcha");
}

- (void)VKRequest:(VKRequest *)request responseError:(NSError *)error{
    NSLog(@"error");
}


@end
