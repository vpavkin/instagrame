//
//  Room+Addon.h
//  Instagrame
//
//  Created by vpavkin on 31.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "Room.h"

typedef NS_ENUM(NSInteger, RoomState) {
    RoomStateNotStarted,
    RoomStateInPlay,
    RoomStateVoting,
    RoomStateFinished
};

@interface Room (Addon)

@property(nonatomic, readonly, getter = isFinished) BOOL finished;
@property(nonatomic, readonly) RoomState state;

+ (NSDictionary*) convertFromParseRoom:(NSDictionary*) room;
- (Room*) updateWithActualData:(NSDictionary*) room;

@end
