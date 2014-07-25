//
//  Room.m
//  Instagrame
//
//  Created by vpavkin on 24.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "Room.h"

@implementation Room

+ (instancetype) room:(NSString*) uid
                 task:(NSString*) task
                owner:(User*) owner
            startDate:(NSDate*) startDate
        voteStartDate:(NSDate*) voteStartDate
           finishDate:(NSDate*) finishDate
              players:(NSArray*) players
             pictures:(NSArray*) pictures
         playersLimit:(NSInteger*) playersLimit{
    Room* r = [[Room alloc]init];
    r.uid = uid;
    r.task = task;
    r.owner = owner;
    r.startDate = startDate;
    r.voteStartDate = voteStartDate;
    r.finishDate = finishDate;
    r.players = players;
    r.pictures = pictures;
    r.playersLimit = playersLimit;
    return r;
}

@end
