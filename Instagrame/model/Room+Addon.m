//
//  Room.m
//  Instagrame
//
//  Created by vpavkin on 24.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "Room.h"

@implementation Room (Addon)

+ (instancetype) room:(NSString*) uid
                 task:(NSString*) task
                owner:(User*) owner
            startDate:(NSDate*) startDate
        voteStartDate:(NSDate*) voteStartDate
           finishDate:(NSDate*) finishDate
              players:(NSArray*) players
             pictures:(NSArray*) pictures
         playersLimit:(NSNumber*) playersLimit{
    Room* r = [[Room alloc]init];
    r.task = task;
    r.owner = owner;
    r.startDate = startDate;
    r.voteDate = voteStartDate;
    r.finishDate = finishDate;
    r.players = [NSSet setWithArray:players];
    r.pictures = [NSSet setWithArray:pictures];
    r.limit = playersLimit;
    return r;
}

@end
