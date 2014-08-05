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

@end

@implementation RelevantGamesCDTVC

- (void) viewDidLoad{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Room"];
    request.predicate = [NSPredicate predicateWithFormat:@"((owner = %@) OR (ANY players = %@)) AND finishDate > %@",instagrameContext.me,instagrameContext.me, [NSDate date]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"startDate"
                                                              ascending:NO]];
    request.fetchLimit = 3;
    
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:instagrameContext.document.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

#pragma mark UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"GameSummaryCell";
    
    GameSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (!cell) {
        cell = [[GameSummaryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Room *room = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.room = room;
    
    return cell;
}


#pragma mark navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"selectRoom"]) {
        RoomCDTVC *vc = (RoomCDTVC*)segue.destinationViewController;
        GameSummaryTableViewCell* cell = sender;
        vc.room = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:cell]];
        NSLog(@"%@", vc.room);
    }
}
@end
