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

+ (instancetype) picture:(NSString*) uid
                  author:(User*) author
                    room:(Room*) room
                   image:(UIImage*) image
                  voters:(NSArray*) voters
            isSubscribed:(BOOL) isSubscribed
               isVisited:(BOOL) isVisited
              submitDate:(NSDate*) submitDate;

@property (strong,nonatomic) NSString *uid;
@property (strong,nonatomic) User *author;
@property (strong,nonatomic) Room *room;
@property (strong,nonatomic) UIImage *image;
@property (strong,nonatomic) NSArray *voters; //of User
@property (nonatomic, getter = isSubscribed) BOOL subscribed;
@property (nonatomic, getter = isVisited) BOOL visited;
@property (strong,nonatomic) NSDate *submitDate;

@end
