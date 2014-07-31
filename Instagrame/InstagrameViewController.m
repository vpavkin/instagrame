//
//  InstagrameViewController.m
//  Instagrame
//
//  Created by vpavkin on 22.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "InstagrameViewController.h"
#import "GameSummaryTableViewCell.h"
#import "InstagrameContext.h"
#import "ColorMacro.h"
#import "User.h"

@interface InstagrameViewController ()
@property (weak, nonatomic) IBOutlet UIButton *createGameButton;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UITableView *currentGamesTable;
@property (weak, nonatomic) IBOutlet UILabel *noGamesPlaceholder;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *carmaLabel;

@end

@implementation InstagrameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userNameLabel.text = instagrameContext.me.name;
    self.carmaLabel.text = [NSString stringWithFormat: @"%@", instagrameContext.me.karma];
    self.avatar.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:instagrameContext.me.avatarURL]]];
    self.avatar.layer.cornerRadius = self.avatar.frame.size.width / 2;
    self.avatar.layer.borderWidth = 3.0f;
    self.avatar.layer.borderColor = [[UIColor whiteColor] CGColor];
}

- (void) viewDidLayoutSubviews{
    CGRect frame = self.currentGamesTable.frame;
    frame.size.height = self.currentGamesTable.contentSize.height;
    self.currentGamesTable.frame = CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,frame.size.width);
    
    self.noGamesPlaceholder.hidden = [self.currentGamesTable visibleCells].count;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
