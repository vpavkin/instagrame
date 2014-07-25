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
#import "User.h"
#import "Room.h"
#import "Picture.h"

//when implementing sources for other services, use separate class for each service, and gather them in the dataSource

@interface LocalDataSource () <VKRequestDelegate,VKConnectorDelegate>

@property (weak,nonatomic) id<AuthorizationRequestDelegate> authDelegate;
@property (strong,nonatomic,readonly) VKRequestManager* requestsMananger;
@property (strong,nonatomic) NSDictionary* mockMe;
@property (strong,nonatomic) NSArray* mockUsers;
@property (strong,nonatomic) NSArray* mockRooms;
@property (strong,nonatomic) NSArray* mockPictures;
@end

@implementation LocalDataSource

#pragma mark mock data

- (NSDictionary*) mockMe{
    if (!_mockMe) {
        _mockMe = @{@"uid": @"1111", @"karma": @14, @"coins": @5};
    }
    return _mockMe;
}

- (NSArray*) mockUsers{
    if (!_mockUsers) {
        _mockUsers = @[
                      [User user:@"Anthony"         avatar:[UIImage imageNamed:@"mockUser0"] uid:@"1" karma: -12 coins:3],
                      [User user:@"George Michal"   avatar:[UIImage imageNamed:@"mockUser1"] uid:@"2" karma: -100 coins:0],
                      [User user:@"sergiusrus"      avatar:[UIImage imageNamed:@"mockUser2"] uid:@"3" karma: 0 coins:12],
                      [User user:@"rul.err"         avatar:[UIImage imageNamed:@"mockUser3"] uid:@"4" karma: 13 coins:15],
                      [User user:@"ann.tkacheva"    avatar:[UIImage imageNamed:@"mockUser4"] uid:@"5" karma: 24 coins:17],
                      [User user:@"mrmoneymustache" avatar:[UIImage imageNamed:@"mockUser5"] uid:@"6" karma: 150 coins:67],
                      [User user:@"Crazy Guy With A Super Long Name"
                                                    avatar:[UIImage imageNamed:@"mockUser6"] uid:@"7" karma: -2042 coins:1234],
                      [User user:@"Mr. X"           avatar:[UIImage imageNamed:@"mockUser7"] uid:@"8" karma: 4520 coins:2]
        ];
    }
    return _mockUsers;

}

- (NSArray*) mockUsers{
    if (!_mockUsers) {
        _mockUsers = @[
                       [User user:@"Anthony"         avatar:[UIImage imageNamed:@"mockUser0"] uid:@"1" karma: -12 coins:3],
                       [User user:@"George Michal"   avatar:[UIImage imageNamed:@"mockUser1"] uid:@"2" karma: -100 coins:0],
                       [User user:@"sergiusrus"      avatar:[UIImage imageNamed:@"mockUser2"] uid:@"3" karma: 0 coins:12],
                       [User user:@"rul.err"         avatar:[UIImage imageNamed:@"mockUser3"] uid:@"4" karma: 13 coins:15],
                       [User user:@"ann.tkacheva"    avatar:[UIImage imageNamed:@"mockUser4"] uid:@"5" karma: 24 coins:17],
                       [User user:@"mrmoneymustache" avatar:[UIImage imageNamed:@"mockUser5"] uid:@"6" karma: 150 coins:67],
                       [User user:@"Crazy Guy With A Super Long Name"
                           avatar:[UIImage imageNamed:@"mockUser6"] uid:@"7" karma: -2042 coins:1234],
                       [User user:@"Mr. X"           avatar:[UIImage imageNamed:@"mockUser7"] uid:@"8" karma: 4520 coins:2]
                       ];
    }
    return _mockUsers;
    
}

- (NSArray*) mockPictures{
    if (!_mockPictures) {
        _mockPictures = @[
                          [Picture picture:@"1" author:self.mockUsers[0] room:nil image:[UIImage imageNamed:@"mockPic1"]
                                    voters:[self.mockUsers subarrayWithRange:NSMakeRange(1, 2)] isSubscribed:YES isVisited:YES
                                submitDate:[[NSDate date] dateByAddingTimeInterval:-40]],
                          
                          [Picture picture:@"2" author:[InstagrameContext instance].me room:nil image:[UIImage imageNamed:@"mockPic2"]
                                    voters: self.mockUsers isSubscribed:NO isVisited:NO
                                submitDate:[[NSDate date] dateByAddingTimeInterval:-430]],
                          
                          [Picture picture:@"3" author:self.mockUsers[4] room:nil image:[UIImage imageNamed:@"mockPic3"]
                                    voters:[self.mockUsers subarrayWithRange:NSMakeRange(3, 5)] isSubscribed:NO isVisited:YES
                                submitDate:[[NSDate date] dateByAddingTimeInterval:-60]],
                          
                          [Picture picture:@"4" author:self.mockUsers[0] room:nil image:[UIImage imageNamed:@"mockPic4"]
                                    voters:[self.mockUsers subarrayWithRange:NSMakeRange(1, 2)] isSubscribed:NO isVisited:NO
                                submitDate:[[NSDate date] dateByAddingTimeInterval:-40]],
                          
                          [Picture picture:@"5" author:self.mockUsers[0] room:nil image:[UIImage imageNamed:@"mockPic5"]
                                    voters:[self.mockUsers subarrayWithRange:NSMakeRange(1, 2)] isSubscribed:NO isVisited:NO
                                submitDate:[[NSDate date] dateByAddingTimeInterval:-40]],
                          
                          [Picture picture:@"6" author:self.mockUsers[0] room:nil image:[UIImage imageNamed:@"mockPic6"]
                                    voters:[self.mockUsers subarrayWithRange:NSMakeRange(1, 2)] isSubscribed:NO isVisited:NO
                                submitDate:[[NSDate date] dateByAddingTimeInterval:-40]],
                          
                          [Picture picture:@"7" author:self.mockUsers[0] room:nil image:[UIImage imageNamed:@"mockPic7"]
                                    voters:[self.mockUsers subarrayWithRange:NSMakeRange(1, 2)] isSubscribed:NO isVisited:NO
                                submitDate:[[NSDate date] dateByAddingTimeInterval:-40]],
                          
                          [Picture picture:@"8" author:self.mockUsers[0] room:nil image:[UIImage imageNamed:@"mockPic8"]
                                    voters:[self.mockUsers subarrayWithRange:NSMakeRange(1, 2)] isSubscribed:NO isVisited:NO
                                submitDate:[[NSDate date] dateByAddingTimeInterval:-40]],

                       ];
    }
    return _mockPictures;
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
    User* u = [User user:name avatar:[UIImage imageWithData:img] uid:self.mockMe[@"uid"] karma:[self.mockMe[@"karma"] intValue] coins:[self.mockMe[@"coins"] intValue]];
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
