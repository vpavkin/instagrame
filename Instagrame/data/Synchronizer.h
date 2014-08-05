//
//  Synchronizer.h
//  Instagrame
//
//  Created by vpavkin on 30.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User, Room;

@interface Synchronizer : NSObject

- (User*) syncUser:(NSDictionary*) user;
- (NSArray*) syncPlayers:(NSArray*) users forRoom:(Room*) room;

- (Room*) syncRoom:(NSDictionary*) room;
- (NSArray*) syncRooms:(NSArray*) rooms;

@end
