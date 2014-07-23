//
//  GameSummaryTableViewCell.h
//  Instagrame
//
//  Created by vpavkin on 23.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameSummaryTableViewCell : UITableViewCell

@property (strong,nonatomic) NSString* name;
@property (nonatomic) NSUInteger state;
@property (nonatomic) NSTimeInterval countdown;
@property (nonatomic) NSUInteger numberOfPlayers;

- (void) addPhoto: (UIImage *)photo;

@end
