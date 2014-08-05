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

@property(nonatomic, readonly) BOOL isFinished;
@property(nonatomic, readonly) RoomState state;
@property(nonatomic, readonly) BOOL isVoted;

+ (NSDictionary*) convertFromParseRoom:(NSDictionary*) room;
+ (NSArray*) convertParseRooms:(NSArray*) rooms;
- (Room*) updateWithActualData:(NSDictionary*) room;

@end
