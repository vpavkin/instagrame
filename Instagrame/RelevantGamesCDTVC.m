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
#import "GameSummaryTableViewCell.h"

@interface RelevantGamesCDTVC ()

@end

@implementation RelevantGamesCDTVC

- (void) viewDidLoad{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Room"];
    request.predicate = [NSPredicate predicateWithFormat:@"owner=%@",instagrameContext.me];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"startDate"
                                                              ascending:NO]];
    
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:instagrameContext.document.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

#pragma mark UITableView

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"GameSummaryCell";
    
    GameSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (!cell) {
        cell = [[GameSummaryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSArray *colors = @[ Rgb2UIColor(255,59,48),
                         Rgb2UIColor(76,217,100),
                         Rgb2UIColor(52,170,220)];
    NSArray *names = @[@"Сфоткай Черновa \nс ложкой во\nрту", @"Сфоткай кота в мешке", @"Сфоткай фотоаппарат"];
    cell.name = names[indexPath.row];
    cell.backgroundColor = colors[indexPath.row % colors.count];
    
    return cell;
}
@end
