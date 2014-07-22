//
//  InstagrameViewController.m
//  Instagrame
//
//  Created by vpavkin on 22.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "InstagrameViewController.h"
#import "GameSummaryTableViewCell.h"

@interface InstagrameViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@end

@implementation InstagrameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.avatar.layer.cornerRadius = self.avatar.frame.size.width / 2;
    self.avatar.layer.borderWidth = 3.0f;
    self.avatar.layer.borderColor = [[UIColor whiteColor] CGColor];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"GameSummaryCell";
    
    GameSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (!cell) {
        cell = [[GameSummaryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.name = [NSString stringWithFormat:@"Game descriiiiption %d", indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


@end
