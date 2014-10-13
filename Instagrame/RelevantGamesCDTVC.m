//
//  RelevantGamesCDTVC.m
//  Instagrame
//
//  Created by vpavkin on 31.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "RelevantGamesCDTVC.h"
#import "ColorMacro.h"
#import "InstagrameContext.h"
#import "Requester.h"
#import "Synchronizer.h"
#import "GameSummaryTableViewCell.h"
#import "Room.h"
#import "User.h"
#import "Picture.h"
#import "User+Addon.h"
#import "Picture+Addon.h"
#import "Room+Addon.h"
#import "RoomCDTVC.h"

@interface RelevantGamesCDTVC ()

@property (strong, nonatomic) NSArray* rooms;
@property (strong, nonatomic, readonly) UIView *bgView;
@property (strong, nonatomic, readonly) UILabel *noGamesLabel;
@end

@implementation RelevantGamesCDTVC

#pragma mark setup
- (void) viewDidLoad{
    [self setupNavBar];
    [self setupTableView];
    [self loadRelevantRooms];
    [self.searchDisplayController.searchResultsTableView registerClass:[GameSummaryTableViewCell class] forCellReuseIdentifier:@"GameSummaryCell"];
    self.searchDisplayController.searchResultsTableView.backgroundView = nil;
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor clearColor];
    [self hideSearchBar];
}

- (void) viewWillAppear:(BOOL)animated{
}

- (void) setupNavBar{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    UIBarButtonItem *browseItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                target:self
                                                                                action:@selector(touchBrowseBarButton:)];
    
    UIBarButtonItem *userProfileItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"user"]
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(touchUserProfileBarButton:)];
    
    NSArray *actionButtonItems = @[browseItem, userProfileItem];
    self.navigationItem.leftBarButtonItems = actionButtonItems;
}

- (void) setupTableView{
    self.tableView.backgroundView = self.bgView;
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithRed:0.000 green:0.251 blue:0.502 alpha:0.5];
    self.refreshControl.tintColor = [UIColor whiteColor];
    self.refreshControl.opaque = NO;
    
    NSString *title = @"Loading relevant rooms...";
    NSDictionary *attrsDictionary = @{
                                      NSForegroundColorAttributeName:[UIColor whiteColor],
                                      NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:16]};
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl.layer.zPosition = self.tableView.backgroundView.layer.zPosition + 1;
    
    [self.refreshControl setNeedsLayout];
}

#pragma manage UI
- (void) hideSearchBar{
    self.searchDisplayController.searchBar.frame = CGRectMake(0,0,0,0);
    [self.searchDisplayController.searchBar setNeedsLayout];
}

- (void) showSearchBar{
    self.searchDisplayController.searchBar.frame = CGRectMake(0,0,320,44.0);
    [self.searchDisplayController.searchBar setNeedsLayout];
}

- (IBAction)touchBrowseBarButton:(id)sender {
    [self showSearchBar];
}

#pragma mark data
- (void) refresh{
    [self loadRelevantRooms];
}


-(void) loadRelevantRooms{
    [instagrameContext.requester loadRelevantRoomsForUser: instagrameContext.me completion:^(BOOL success, NSArray *rooms) {
#pragma warning move syncronizing out of view controller (maybe a dataRetriever class?)
        NSLog(@"rooms:\n%@", rooms);
        NSArray* coreRooms = [instagrameContext.synchronizer syncRooms:[Room convertParseRooms:rooms]];
        
        [self chainedInfoForRoom:coreRooms
                           index:0
                      completion:^(BOOL success) {
                          [self update];
                      }];
    }];
    
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


- (void) update{
    [self.refreshControl endRefreshing];
    [self fetchData];
    [self updateTableAppearance];
    [self.tableView reloadData];
}

- (void) fetchData{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Room"];
    //AND finishDate > %@
    request.predicate = [NSPredicate predicateWithFormat:@"((owner = %@) OR (ANY players = %@))",
                         instagrameContext.me,instagrameContext.me, [NSDate date]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"startDate"
                                                              ascending:NO]];
    
    NSError *error = nil;
    self.rooms = [instagrameContext.document.managedObjectContext executeFetchRequest:request error:&error];
}

#pragma mark UITableView

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rooms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"GameSummaryCell";
    GameSummaryTableViewCell *cell;
    
    //    GameSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    //
    //    if (!cell) {
    //        cell = [[GameSummaryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    //    }
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        //cell fields customization
        cell.backgroundColor = [UIColor clearColor];
        cell.opaque = NO;
    }
    else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
        //cell fields customization
        cell.backgroundColor = [UIColor clearColor];
        cell.opaque = NO;
    }
    if (!cell) {
        cell = [[GameSummaryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Room *room = self.rooms[indexPath.row];
    cell.room = room;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 96;
}

-(void) updateTableAppearance{
    if (!self.rooms.count){
        self.noGamesLabel.text = @"No current games you take part in.";
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else{
        self.noGamesLabel.text = @"";
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}


#pragma mark navigation

- (IBAction)touchNewGameBarButton:(id)sender {
    [self performSegueWithIdentifier:@"createGame" sender:self];
}
- (IBAction)touchUserProfileBarButton:(id)sender {
    [self performSegueWithIdentifier:@"userProfile" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"selectRoom"]) {
        RoomCDTVC *vc = (RoomCDTVC*)segue.destinationViewController;
        GameSummaryTableViewCell* cell = sender;
        if (self.searchDisplayController.active) {
            vc.room = self.rooms[[self.searchDisplayController.searchResultsTableView indexPathForCell:cell].row];
        } else {
            vc.room = self.rooms[[self.tableView indexPathForCell:cell].row];
        }
        
        NSLog(@"%@", vc.room);
    }
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
