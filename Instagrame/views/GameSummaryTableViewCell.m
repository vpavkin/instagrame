//
//  GameSummaryTableViewCell.m
//  Instagrame
//
//  Created by vpavkin on 23.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "GameSummaryTableViewCell.h"

@interface GameSummaryTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation GameSummaryTableViewCell

- (void) setName:(NSString *)name{
    _name = name;
    self.nameLabel.text = name;
}

@end
