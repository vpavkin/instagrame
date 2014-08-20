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

@interface AuthorizeViewController ()

@property (weak, nonatomic) UITextField *activeText;
@property (nonatomic) CGSize keyboardSize;

@property (weak, nonatomic) IBOutlet UIView *preloader;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@end

@implementation AuthorizeViewController

- (IBAction)touchLoginButton:(UIButton *)sender {
    if ([self validate]) {
        [self authorizeInstagrame];
    }
}

- (IBAction)textDidBeginEditing:(UITextField *)sender {
    self.activeText = sender;
    self.activeText.layer.borderColor = [[UIColor clearColor] CGColor];
    
    NSInteger delta = (self.view.frame.size.height - self.keyboardSize.height) - (self.activeText.frame.origin.y + self.activeText.frame.size.height + 10);
    [self scrollKeyboardWithDelta:delta];
    
}
- (IBAction)textDidEndEditing:(UITextField *)sender {
    self.activeText = nil;
}

- (IBAction)textDidEndOnExit:(UITextField *)sender {
    [sender resignFirstResponder];
    if (sender == self.emailText) {
        [self.passwordText becomeFirstResponder];
    }else if (sender == self.passwordText && [self validate]) {
        [self authorizeInstagrame];
    }
}

- (BOOL) validateField:(UITextField*) textField{
    if (!textField.text.length) {
        textField.layer.cornerRadius = 8.0f;
        textField.layer.masksToBounds = YES;
        textField.layer.borderColor = [[UIColor redColor] CGColor];
        textField.layer.borderWidth = 1.0f;
        return NO;
    }
    return YES;
}

- (BOOL) validate{
    return [self validateField:self.emailText] && [self validateField:self.passwordText];
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification*)aNotification{
    NSDictionary* info = [aNotification userInfo];
    self.keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
}

- (void)keyboardWillHide:(NSNotification*)aNotification{
    [self scrollKeyboardWithDelta:0];
}

- (void) scrollKeyboardWithDelta:(NSInteger) delta{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect rect = self.view.frame;
    if (delta < 0) {
        rect.origin.y += delta;
        rect.size.height += -delta;
    }
    else{
        rect.size.height += rect.origin.y;
        rect.origin.y = 0;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
    
}

- (void) setupKeyboardScroller{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void) removeKeyboardScroller{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification object:nil];
}

- (void) viewWillAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self setupKeyboardScroller];
}

- (void) viewWillDisappear:(BOOL)animated{
    [self removeKeyboardScroller];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    if (instagrameContext.document) {
        [self preAuthorize];
    }else{
        [[NSNotificationCenter defaultCenter] addObserverForName:DOCUMENT_IS_READY_NOTIFICATION
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification *note) {
                                                          [self preAuthorize];
                                                      }];
    }
}

- (void) preAuthorize{
    if ([instagrameContext.authorizer isAuthorizedWithService:AuthorizationServiceInstagrame]) {
        NSLog(@"Already authiorized with Email and Password");
        [instagrameContext.authorizer authorizeWithService:AuthorizationServiceInstagrame
                                                  delegate:self
                                                      data:@{PASSWORD_KEY: instagrameContext.authorizer.myPassword, EMAIL_KEY: instagrameContext.authorizer.myEmail}];
    }else if ([instagrameContext.authorizer isAuthorizedWithService:AuthorizationServiceVK]){
        NSLog(@"Already authiorized with VK");
        [instagrameContext.authorizer authorizeWithService:AuthorizationServiceVK delegate:self data:nil];
    }else{
        [self hidePreloader];
    }
}

- (void) authorizeInstagrame{
    [self showPreloader];
    [instagrameContext.authorizer authorizeWithService:AuthorizationServiceInstagrame
                                              delegate:self
                                                  data:@{EMAIL_KEY:self.emailText.text, PASSWORD_KEY: self.passwordText.text}];
}

- (IBAction)touchVkButton {
    [[InstagrameContext instance].authorizer authorizeWithService:AuthorizationServiceVK delegate:self data:nil];
}

- (void) authorizationSuccess:(User *)me {
    [self hidePreloader];
    instagrameContext.me = me;
    [self performSegueWithIdentifier:@"authorize" sender:self];
}

- (void) authorizationError:(id)error{
    [self hidePreloader];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Wrong credentials"
                          message:@"Unknown email or password."
                          delegate:self
                          cancelButtonTitle: @"OK"
                          otherButtonTitles: nil];
    [alert show];
}

- (void) hidePreloader{
    [UIView transitionWithView:self.preloader
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    
    self.preloader.hidden = YES;
}

- (void) showPreloader{
    [UIView transitionWithView:self.preloader
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    
    self.preloader.hidden = NO;
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
