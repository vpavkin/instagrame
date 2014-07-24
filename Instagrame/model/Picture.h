//
//  Picture.h
//  Instagrame
//
//  Created by vpavkin on 24.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@class Room;

@interface Picture : NSObject

@property (strong,nonatomic) User *author;
@property (strong,nonatomic) Room *room;
@property (strong,nonatomic) UIImage *image;
@property (strong,nonatomic) NSArray *voters; //of User
@property (strong,nonatomic) NSArray *subscribers; //of User
@property (strong,nonatomic) NSArray *visitors; //of User
@property (strong,nonatomic) NSDate *submitDate;

@end
