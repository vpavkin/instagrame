//
//  Room.h
//  Instagrame
//
//  Created by vpavkin on 24.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Room : NSObject

@property (strong,nonatomic) NSString *uid;
@property (strong,nonatomic) NSString *task;
@property (strong,nonatomic) User *owner;
@property (strong,nonatomic) NSDate *startDate;
@property (strong,nonatomic) NSDate *voteStartDate;
@property (strong,nonatomic) NSDate *finishDate;
@property (strong,nonatomic) NSArray *players; //of User
@property (strong,nonatomic) NSArray *pictures; //of Picture
@property (nonatomic)        NSInteger *playersLimit;

@end
