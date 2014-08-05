//
//  Picture+Addon.h
//  Instagrame
//
//  Created by vpavkin on 24.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@class Room;

@interface Picture (Addon)

@property (nonatomic, readonly) BOOL isSubscribed;
@property (nonatomic, readonly) BOOL isVisited;

+ (NSDictionary*) convertFromParsePicture:(NSDictionary*) room;
+ (NSArray*) convertParsePictures:(NSArray*) pictures;
- (Picture*) updateWithActualData:(NSDictionary*) picture;

@end
