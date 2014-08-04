//
//  Room+Addon.m
//  Instagrame
//
//  Created by vpavkin on 31.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "Room+Addon.h"
#import "Room.h"
#import "InstagrameContext.h"
#import "Synchronizer.h"
#import "User+Addon.h"

@implementation Room (Addon)

-(BOOL) isFinished{
    return [self.finishDate compare:[NSDate date]] == NSOrderedAscending;
}

-(RoomState) state{
    if ([self.startDate compare:[NSDate date]] == NSOrderedDescending) {
        return RoomStateNotStarted;
    }else if([self.voteStartDate compare:[NSDate date]] == NSOrderedDescending){
        return RoomStateInPlay;
    }else if([self.finishDate compare:[NSDate date]] == NSOrderedDescending){
        return RoomStateVoting;
    }else {
        return RoomStateFinished;
    }
}

+ (NSDictionary*) convertFromParseRoom:(NSDictionary*) parseRoom{
    NSMutableDictionary* room = [parseRoom mutableCopy];
    
    NSDateFormatter* dateF = [[NSDateFormatter alloc] init];
    [dateF setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateF setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    NSDate* date = [dateF dateFromString:room[UPDATED_AT]];
    [room setObject:date forKey:UPDATED_AT];
    
    date = [dateF dateFromString:room[CREATED_AT]];
    [room setObject:date forKey:CREATED_AT];
    
    date = [dateF dateFromString:room[@"startDate"][@"iso"]];
    [room setObject:date forKey:@"startDate"];
    
    date = [dateF dateFromString:room[@"finishDate"][@"iso"]];
    [room setObject:date forKey:@"finishDate"];
    
    date = [dateF dateFromString:room[@"voteStartDate"][@"iso"]];
    [room setObject:date forKey:@"voteStartDate"];
    
    [room removeObjectForKey:@"players"];
    room[@"owner"] = [User convertFromParseUser:room[@"owner"]];
    
    NSLog(@"converted room:\n %@",room);
    
    return room;

}

- (Room*) updateWithActualData:(NSDictionary*) room{
    for (NSString *key in room) {
        if (![key isEqualToString:@"players"] && ![key isEqualToString:@"owner"] && ![key isEqualToString:@"__type"] && ![key isEqualToString:@"className"]) {
            [self setValue:room[key] forKey:key];
        }
    }
    return self;
}

@end
