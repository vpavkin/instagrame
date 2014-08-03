//
//  InstagrameViewController.m
//  Instagrame
//
//  Created by vpavkin on 22.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "InstagrameViewController.h"
#import "RelevantGamesCDTVC.h"
#import "GameSummaryTableViewCell.h"
#import "InstagrameContext.h"
#import "ColorMacro.h"
#import "User.h"
#import "Room+Addon.h"
#import "Requester.h"
#import "Synchronizer.h"

@interface InstagrameViewController ()
@property (weak, nonatomic) IBOutlet UIButton *createGameButton;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *noGamesPlaceholder;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *carmaLabel;

@property (weak, nonatomic) RelevantGamesCDTVC *relevantGamesController;
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
    UITableView *tv = (UITableView*)self.relevantGamesController.view;
    CGRect frame = tv.frame;
    frame.size.height = tv.contentSize.height;
    tv.frame = CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,frame.size.width);
    
    self.noGamesPlaceholder.hidden = [tv visibleCells].count;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"RelevantGamesES"]) {
        self.relevantGamesController = (RelevantGamesCDTVC *) [segue destinationViewController];
        [instagrameContext.requester loadRelevantRoomsForUser: instagrameContext.me completion:^(BOOL success, NSArray *rooms) {
#pragma warning move syncronizing out of view controller (maybe a dataRetriever class?)
            NSLog(@"rooms:\n%@", rooms);
            for (NSDictionary* room in rooms) {
                [instagrameContext.synchronizer syncRoom:[Room convertFromParseRoom:room]];
            }
            UITableView *tv = (UITableView*) self.relevantGamesController.view;
            [tv reloadData];
        }];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
