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

@end


@implementation AuthorizeViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[InstagrameContext instance].data isAuthorizedWithService:AuthorizationServiceVK]) {
        [self touchVkButton];
    }
}

- (IBAction)touchVkButton {
    [[InstagrameContext instance].data authorizeWithService:AuthorizationServiceVK delegate:self];
}

- (void) authorizationSuccess:(User *)me{
    [self performSegueWithIdentifier:@"authorize" sender:self];
}

- (void) authorizationError:(id)error{
    //todo: add handler
}

@end
