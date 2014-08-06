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
#import "User+Addon.h"
#import "Room.h"
#import "Room+Addon.h"
#import "Picture.h"
#import "Picture+Addon.h"
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
    
    self.userNameLabel.attributedText = instagrameContext.me.nameWithKarma;
    self.carmaLabel.text = @"";
    self.avatar.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:instagrameContext.me.avatarURL]]];
    self.avatar.layer.cornerRadius = self.avatar.frame.size.width / 2;
    self.avatar.layer.borderWidth = 3.0f;
    self.avatar.layer.borderColor = [[UIColor whiteColor] CGColor];
    
}

- (void) viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.opaque = NO;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"RelevantGamesES"]) {
        self.relevantGamesController = (RelevantGamesCDTVC *) [segue destinationViewController];
        [instagrameContext.requester loadRelevantRoomsForUser: instagrameContext.me completion:^(BOOL success, NSArray *rooms) {
#pragma warning move syncronizing out of view controller (maybe a dataRetriever class?)
            NSLog(@"rooms:\n%@", rooms);
            NSArray* coreRooms = [instagrameContext.synchronizer syncRooms:[Room convertParseRooms:rooms]];
            self.noGamesPlaceholder.hidden = coreRooms.count;
            if (!coreRooms.count) {
                return;
            }
            
            [self chainedInfoForRoom:coreRooms
                               index:0
                          completion:^(BOOL success) {
                              [self.relevantGamesController update];
                              
                          }];
        }];
    }
}

- (void) chainedInfoForRoom:(NSArray*) rooms index: (int) index completion:(void(^)(BOOL))completion{
    if (index < rooms.count) {
        [instagrameContext.requester playersForRoom:rooms[index] completion:^(BOOL success, NSArray *players) {
            if(success){
                [instagrameContext.synchronizer syncPlayers:[User convertParseUsers:players] forRoom:rooms[index]];
            }
            [instagrameContext.requester picturesForRoom:rooms[index] completion:^(BOOL success, NSArray *pictures) {
                if(success){
                    [instagrameContext.synchronizer syncPictures:[Picture convertParsePictures:pictures] forRoom:rooms[index]];
                }
                [self chainedInfoForRoom:rooms index:index+1 completion:completion];
            }];
        }];
    }else{
        if (completion) {
            completion(YES);
        }
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
