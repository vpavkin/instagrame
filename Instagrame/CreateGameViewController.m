//
//  CreateGameViewController.m
//  Instagrame
//
//  Created by vpavkin on 20.08.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "CreateGameViewController.h"

@interface CreateGameViewController ()

@property (nonatomic,strong, readonly) NSArray* gameTypes; //of NSString*
@property (weak, nonatomic) IBOutlet UILabel *gameTypeLabel;
@property (weak, nonatomic) IBOutlet UITextView *tastTextView;
@property (weak, nonatomic) IBOutlet UITextField *playersLimitTextField;
@property (weak, nonatomic) IBOutlet UIStepper *playersLimitStepper;

@property (nonatomic) CGSize keyboardSize;

@end

@implementation CreateGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavBar];
    [self.tastTextView sizeToFit]; //added
    [self.tastTextView layoutIfNeeded]; //added
    
}

- (void) setupNavBar{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
}

- (IBAction)touchDoneButton:(id)sender {
    if ([self validate]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL) validate{
#pragma warning implement validation
    return YES;
}
- (IBAction)playersLimitStepperValueChanged:(UIStepper *)sender{
    self.playersLimitTextField.text = [NSString stringWithFormat:@"%d", (int)sender.value];
}

- (IBAction)playersLimitValueChanged:(UITextField *)sender {
    int val = [sender.text intValue];
    if (val > 100) {
        sender.text = @"100";
    }
    self.playersLimitStepper.value = [sender.text floatValue];
}
- (IBAction)playersLimitEditingEnd:(UITextField *)sender {
    int val = [sender.text intValue];
    if( val < 2){
        sender.text = @"2";
        self.playersLimitStepper.value = [sender.text floatValue];
    }
}

- (IBAction)playersLimitTextFieldDidEndOnExit:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (IBAction)tap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)textDidBeginEditing:(UITextField *)sender {
    NSInteger delta = (self.view.frame.size.height - self.keyboardSize.height) - (sender.frame.origin.y + sender.frame.size.height);
    [self scrollKeyboardWithDelta:delta];
}

- (void)keyboardWillShow:(NSNotification*)aNotification{
    NSDictionary* info = [aNotification userInfo];
    self.keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if (self.playersLimitTextField.isFirstResponder) {
        [self textDidBeginEditing:self.playersLimitTextField];
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


#pragma mark TextView Delegate

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    else if(textView.text.length + text.length - range.length > 80)
        return NO;
    else
        return YES;
}

#pragma mark PickerView DataSource
@synthesize gameTypes = _gameTypes;

- (NSArray*) gameTypes{
    if (!_gameTypes) {
        _gameTypes = @[@"Short",@"Regular",@"Long",@"Marathon"];
    }
    return _gameTypes;
}

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    return self.gameTypes.count;
}

- (UILabel *)pickerView:(UIPickerView *)pickerView
             viewForRow:(NSInteger)row
            forComponent:(NSInteger)component
             reusingView:(UIView *)view    {
   
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        tView.font = [UIFont fontWithName:@"AvenirNextCyr-Light" size:24];
        tView.textAlignment = NSTextAlignmentCenter;
        tView.textColor = [UIColor whiteColor];
    }
    tView.text = self.gameTypes[row];
    return tView;
}

#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component{
    switch (row) {
        case 0:
            self.gameTypeLabel.text = @"Playing: 30m\nVoting: 30m";
            break;
        case 1:
            self.gameTypeLabel.text = @"Playing: 1h\nVoting: 1h";
            break;
        case 2:
            self.gameTypeLabel.text = @"Playing: 3h\nVoting: 3h";
            break;
        case 3:
            self.gameTypeLabel.text = @"Playing: 1d\nVoting: 1d";
            break;
    }
}

@end
