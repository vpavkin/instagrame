//
//  AuthorizeViewController.m
//  Instagrame
//
//  Created by vpavkin on 23.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "AuthorizeViewController.h"
#import "InstagrameContext.h"
#import "Authorizer.h"

@implementation AuthorizeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (instagrameContext.document) {
        [self authorize];
    }else{
        [[NSNotificationCenter defaultCenter] addObserverForName:DOCUMENT_IS_READY_NOTIFICATION
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification *note) {
                                                          [self authorize];
                                                      }];
    }
}

- (void) authorize{
    if ([instagrameContext.authorizer isAuthorizedWithService:AuthorizationServiceInstagrame]) {
        [instagrameContext.authorizer authorizeWithService:AuthorizationServiceInstagrame delegate:self];
    }else if ([instagrameContext.authorizer isAuthorizedWithService:AuthorizationServiceVK]){
        [instagrameContext.authorizer authorizeWithService:AuthorizationServiceVK delegate:self];
    }
}

- (IBAction)touchVkButton {
    [[InstagrameContext instance].authorizer authorizeWithService:AuthorizationServiceVK delegate:self];
}

- (void) authorizationSuccess:(User *)me{
    [self performSegueWithIdentifier:@"authorize" sender:self];
}

- (void) authorizationError:(id)error{
    //todo: add handler
}

#pragma mark properties

@synthesize webView = _webView;

- (UIWebView*)webView{
    if (!_webView) {
        CGRect frame = [[UIScreen mainScreen] bounds];
        _webView = [[UIWebView alloc] initWithFrame:frame];
        [self.view addSubview:_webView];
        _webView.hidden = YES;
    }
    return _webView;
}

@end
