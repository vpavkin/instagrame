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

@interface Picture (Addon)

+ (instancetype) picture:(NSString*) uid
                  author:(User*) author
                    room:(Room*) room
                   image:(NSString*) image
                  voters:(NSArray*) voters
             subscribers:(NSArray*) subscribers
                visitors:(NSArray*) visitors
              submitDate:(NSDate*) submitDate;

@property (nonatomic, getter = isSubscribed) BOOL subscribed;
@property (nonatomic, getter = isVisited) BOOL visited;

@end
