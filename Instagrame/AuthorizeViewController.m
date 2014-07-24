//
//  AuthorizeViewController.m
//  Instagrame
//
//  Created by vpavkin on 23.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "AuthorizeViewController.h"
#import "InstagrameContext.h"

@interface AuthorizeViewController ()
@property (strong,nonatomic,readonly) UIWebView *webView;
@property (strong,nonatomic,readonly) VKRequestManager* requestsMananger;
@end


@implementation AuthorizeViewController

@synthesize webView = _webView;
@synthesize requestsMananger = _requestsMananger;

- (UIWebView*)webView{
    if (!_webView) {
        CGRect frame = [[UIScreen mainScreen] bounds];
        _webView = [[UIWebView alloc] initWithFrame:frame];
    }
    return _webView;
}

- (VKRequestManager*) requestsMananger{
    if (!_requestsMananger) {
        _requestsMananger = [[VKRequestManager alloc] initWithDelegate:self
                                                                  user:[VKUser currentUser]];
    }
    return _requestsMananger;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    VKUser * user = [VKUser currentUser];
    if (user) {
        [self loadUserData];
    }
}

- (void) loadUserData{
    [self.requestsMananger info];
}

- (IBAction)touchVkButton {
   
    [self.view addSubview:self.webView];
    self.webView.hidden = NO;
    [[VKConnector sharedInstance] startWithAppID:@"4473650"
                                      permissons:@[@"wall", @"friends"]
                                         webView:self.webView
                                        delegate:self];
}

#pragma mark - VKConnectorDelegate

- (void) VKConnector:(VKConnector *)connector
accessTokenRenewalSucceeded:(VKAccessToken *)accessToken
{
    NSLog(@"OK: %@", accessToken);
    self.webView.hidden = YES;
    [self loadUserData];
}

- (void) VKConnector:(VKConnector *)connector
accessTokenRenewalFailed:(VKAccessToken *)accessToken
{
    NSLog(@"User denied to authorize app.");
}

#pragma mark - VKRequestDelegate

- (void)VKRequest:(VKRequest *)request response:(id)response{
        NSLog(@"Request %@ is ok:\n %@", request.signature, response);
    if ([request.signature isEqualToString:@"info:"]) {
        NSDictionary *info = response[@"response"][0];
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
               
               dispatch_async(dispatch_get_main_queue(), ^
                              {
                                  [InstagrameContext instance].me = [[User alloc] initWithName:name
                                                                                        avatar:[UIImage imageWithData:imgTmpData]];
                                  [self performSegueWithIdentifier:@"authorize" sender:self];
                              });
            });
        } else {
            [InstagrameContext instance].me = [[User alloc] initWithName:name
                                                                  avatar:[UIImage imageWithData:imgData]];
            [self performSegueWithIdentifier:@"authorize" sender:self];
        }
       
    }
}

- (void)VKRequest:(VKRequest *)request captchaSid:(NSString *)captchaSid captchaImage:(NSURL *)captchaImage{
    NSLog(@"captcha");
}

- (void)VKRequest:(VKRequest *)request responseError:(NSError *)error{
    NSLog(@"error");
}

@end
