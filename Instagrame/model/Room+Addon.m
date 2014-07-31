//
//  Room+Addon.m
//  Instagrame
//
//  Created by vpavkin on 31.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "Room+Addon.h"
#import "Room.h"

@implementation Room (Addon)

-(BOOL) isFinished{
    return [self.finishDate compare:[NSDate date]] == NSOrderedAscending;
}

@end
