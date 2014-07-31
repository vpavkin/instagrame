//
//  Room+Addon.h
//  Instagrame
//
//  Created by vpavkin on 31.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "Room.h"

@interface Room (Addon)

@property(nonatomic, readonly, getter = isFinished) BOOL finished;

@end
