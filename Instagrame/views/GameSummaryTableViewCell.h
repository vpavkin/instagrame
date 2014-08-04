//
//  GameSummaryTableViewCell.h
//  Instagrame
//
//  Created by vpavkin on 23.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GameSummaryTableViewCellState) {
    GameSummaryTableViewCellStateNotStarted,
    GameSummaryTableViewCellStateInPlay,
    GameSummaryTableViewCellStateVoting,
    GameSummaryTableViewCellStateFinished
};

@interface GameSummaryTableViewCell : UITableViewCell

@property (strong,nonatomic) NSString* name;
@property (nonatomic) GameSummaryTableViewCellState state;
@property (nonatomic) NSTimeInterval countdown;
@property (nonatomic) NSUInteger numberOfPlayers;

- (void) addPhoto: (UIImage *)photo;

@end
