//
//  Requester.h
//  Instagrame
//
//  Created by vpavkin on 29.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User, Room;

@interface Requester : NSObject

- (void) userForEmail:(NSString*) email
          andPassword: (NSString*) password
           completion: (void(^)(BOOL success, NSDictionary *data))completion;

- (void) userForVKId:(NSString*) vkId
           completion: (void(^)(BOOL success, NSDictionary *data))completion;

- (void) addUserFromVk:(NSDictionary*) preparedInfo
            completion:(void(^)(BOOL success, NSDictionary *data))completion;

- (void) loadRelevantRoomsForUser: (User*) user
                       completion:(void(^)(BOOL success, NSArray *data))completion;
- (void) playersForRoom: (Room*) room
                     completion:(void(^)(BOOL success, NSArray *players))completion;
@end
