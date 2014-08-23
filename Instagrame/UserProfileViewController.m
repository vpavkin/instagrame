//
//  UserProfileViewController.m
//  Instagrame
//
//  Created by vpavkin on 19.08.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "UserProfileViewController.h"
#import "InstagrameContext.h"
#import "User.h"
#import "User+Addon.h"

@interface UserProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *statsTextView;
@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;

@end

@implementation UserProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavBar];
    [self setupAvatar];
    [self setupUserInfo];
}

- (void) setupNavBar{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
}

- (void) setupAvatar{
    self.avatar.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: instagrameContext.me.avatarURL]]];
    self.avatar.layer.cornerRadius = self.avatar.frame.size.width / 2;
    self.avatar.layer.borderWidth = 3.0f;
    self.avatar.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.avatar.clipsToBounds = YES;
}

- (void) setupUserInfo{
    self.nameLabel.text = instagrameContext.me.name;
    self.statsTextView.font = [UIFont fontWithName:@"AvenirNextCyr-Light" size:14];
    self.ratingLabel.attributedText = instagrameContext.me.karmaString;
}

@end
