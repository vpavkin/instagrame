//
//  GameChatViewController.m
//  Instagrame
//
//  Created by vpavkin on 23.08.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "GameChatViewController.h"
#import "Room.h"

@interface GameChatViewController ()


@property (strong, nonatomic) IBOutlet UITextField *messageTextField;

@property (nonatomic) CGSize keyboardSize;
@end

#pragma warning make recent messages always at the bottom.
#pragma warning appropriately move text when keyboard is shown

@implementation GameChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavBar];
}

- (void) setupNavBar{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
}

- (IBAction)sendButtonTouch:(UIButton *)sender {
}

- (IBAction)tap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)textFieldDidEndOnExit:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (IBAction)textDidBeginEditing:(UITextField *)sender {
    NSInteger delta = (self.view.frame.size.height - self.keyboardSize.height) - (sender.frame.origin.y + sender.frame.size.height);
    [self scrollKeyboardWithDelta:delta];
}

- (void)keyboardWillShow:(NSNotification*)aNotification{
    NSDictionary* info = [aNotification userInfo];
    self.keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if (self.messageTextField.isFirstResponder) {
        [self textDidBeginEditing:self.messageTextField];
    }
}

- (void)keyboardWillHide:(NSNotification*)aNotification{
    self.keyboardSize = CGSizeMake(0, 0);
    [self scrollKeyboardWithDelta:0];
}

- (void) scrollKeyboardWithDelta:(NSInteger) delta{
    NSLog(@"delta = %d",delta);
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
    [self setupKeyboardScroller];
}

- (void) viewWillDisappear:(BOOL)animated{
    [self removeKeyboardScroller];
}

@end
