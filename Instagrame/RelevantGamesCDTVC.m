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

@interface RelevantGamesCDTVC ()

@end

@implementation RelevantGamesCDTVC

- (void) viewDidLoad{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Room"];
    request.predicate = [NSPredicate predicateWithFormat:@"(owner = %@) OR (ANY players = %@)",instagrameContext.me,instagrameContext.me];
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
    
    
    NSArray *colors = @[ Rgb2UIColor(255,59,48),
                         Rgb2UIColor(76,217,100),
                         Rgb2UIColor(52,170,220)];
    cell.backgroundColor = colors[indexPath.row % colors.count];
    cell.room = room;
    
    return cell;
}
@end
