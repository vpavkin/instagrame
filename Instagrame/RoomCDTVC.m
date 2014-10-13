//
//  RoomCDTVC.m
//  Instagrame
//
//  Created by vpavkin on 05.08.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "RoomCDTVC.h"
#import "InstagrameContext.h"
#import "PictureTableViewCell.h"
#import "Picture.h"
#import "Room.h"
#import "GameChatViewController.h"
#import "GameSummaryTableViewCell.h"

@interface RoomCDTVC ()

@property (strong, nonatomic, readonly) UIView *bgView;
@property (strong, nonatomic, readonly) UILabel *noGamesLabel;
@property (strong, nonatomic) NSArray *pictures; //of Picture

@end

@implementation RoomCDTVC

#pragma warning think of footer cell background (maybe nav bar should not be transparent either?)
#pragma refresh control must disappear
#pragma async avatars

#pragma mark setup

-(void) viewDidLoad{
    [self setupNavBar];
    [self setupTableView];
}

- (void) viewWillAppear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:NO];
}

- (void) setupNavBar{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    UIBarButtonItem *submitPhotoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"photo"]
                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:nil];
    
    UIBarButtonItem *chatItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"chat"]
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(openChat)];
    
    NSArray *actionButtonItems = @[submitPhotoItem, chatItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
}

- (void) setupTableView{
    self.tableView.backgroundView = self.bgView;
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithRed:0.000 green:0.251 blue:0.502 alpha:0.5];
    self.refreshControl.tintColor = [UIColor whiteColor];
    self.refreshControl.opaque = NO;
    self.refreshControl.layer.zPosition = self.tableView.backgroundView.layer.zPosition + 1;
}

#pragma mark navigation
- (void) openChat{
    [self performSegueWithIdentifier:@"gameChat" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"gameChat"]) {
        if ([segue.destinationViewController isKindOfClass:[GameChatViewController class]]) {
            GameChatViewController* dest = (GameChatViewController*) segue.destinationViewController;
            dest.room = self.room;
        }
    }
}

#pragma mark data

- (void) setRoom:(Room *)room{
    _room = room;
    [self update];
}

- (void) refresh{
#pragma warning implement
}

-(void) update{
    self.pictures = [[self.room.pictures allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"submitDate"
                                                                                                                ascending:NO]]];
    [self.tableView reloadData];
}

#pragma mark UITableView

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pictures.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"PictureCell";
    
    PictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (!cell) {
        cell = [[PictureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Picture *pic = self.pictures[indexPath.row];
    cell.picture = pic;
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 96.0;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    // 1. Dequeue the custom header cell
    GameSummaryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GameSummaryCellForRoom"];
    
    if (!cell) {
        cell = [[GameSummaryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GameSummaryCellForRoom"];
    }
    
    // 2. Set the various properties
    cell.room = self.room;
    cell.backgroundColor = [UIColor blackColor];
    
    // 3. And return
    return cell;
}

#pragma mark properties

@synthesize bgView = _bgView;
@synthesize noGamesLabel = _noGamesLabel;

- (UIView*) bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pile-of-photographs"]];
        [tempImageView setFrame:self.tableView.frame];
        tempImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_bgView addSubview:tempImageView];
        [_bgView addSubview:self.noGamesLabel];
    }
    return _bgView;
}

- (UIView*) noGamesLabel{
    if (!_noGamesLabel) {
        _noGamesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.tableView.bounds.size.width-20, self.tableView.bounds.size.height-20)];
        _noGamesLabel.textColor = [UIColor whiteColor];
        _noGamesLabel.numberOfLines = 0;
        _noGamesLabel.textAlignment = NSTextAlignmentCenter;
        _noGamesLabel.font = [UIFont fontWithName:@"AvenirNext-UltraLight" size:32];
        _noGamesLabel.text = @"";
    }
    return _noGamesLabel;
}


@end
