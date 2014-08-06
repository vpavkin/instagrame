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
#import "User+Addon.h"
#import "RoomCDTVC.h"

@interface RelevantGamesCDTVC ()

@property (strong,nonatomic) NSArray* rooms;

@end

@implementation RelevantGamesCDTVC

- (void) viewDidLoad{
    [self update];
}

- (void) update{
    [self fetchData];
    [self.tableView reloadData];
}

- (void) viewDidLayoutSubviews{
    UITableView *tv = (UITableView*)self.tableView;
    CGRect frame = tv.frame;
    frame.size.height = tv.contentSize.height;
    tv.frame = CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,frame.size.width);
}

- (void) fetchData{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Room"];
    request.predicate = [NSPredicate predicateWithFormat:@"((owner = %@) OR (ANY players = %@)) AND finishDate > %@",instagrameContext.me,instagrameContext.me, [NSDate date]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"startDate"
                                                              ascending:NO]];
    request.fetchLimit = 3;
    
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
    
    GameSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (!cell) {
        cell = [[GameSummaryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Room *room = self.rooms[indexPath.row];
    cell.room = room;
    
    return cell;
}



#pragma mark navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"selectRoom"]) {
        RoomCDTVC *vc = (RoomCDTVC*)segue.destinationViewController;
        GameSummaryTableViewCell* cell = sender;
        vc.room = self.rooms[[self.tableView indexPathForCell:cell].row];
        NSLog(@"%@", vc.room);
    }
}
@end
