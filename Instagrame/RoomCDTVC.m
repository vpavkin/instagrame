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

@interface RoomCDTVC ()

@end

@implementation RoomCDTVC

-(void) viewWillAppear:(BOOL)animated{
    [self navigationController].navigationBar.backItem.hidesBackButton = NO;
}

- (void) setRoom:(Room *)room{
    _room = room;
    [self update];
}

-(void) update{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Picture"];
    request.predicate = [NSPredicate predicateWithFormat:@"room = %@", _room];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"submitDate"
                                                              ascending:NO]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:instagrameContext.document.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

#pragma mark UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"PictureCell";
    
    PictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (!cell) {
        cell = [[PictureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Picture *pic = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.picture = pic;
    
    return cell;
}

@end
