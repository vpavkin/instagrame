//
//  Room.h
//  Instagrame
//
//  Created by vpavkin on 24.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Room (Addon)

+ (instancetype) room:(NSString*) uid
                 task:(NSString*) task
                owner:(User*) owner
            startDate:(NSDate*) startDate
        voteStartDate:(NSDate*) voteStartDate
           finishDate:(NSDate*) finishDate
              players:(NSArray*) players
             pictures:(NSArray*) pictures
         playersLimit:(NSInteger*) playersLimit;

@end
