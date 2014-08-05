//
//  Picture+Addon.m
//  Instagrame
//
//  Created by vpavkin on 24.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "Picture.h"
#import "Picture+Addon.h"
#import "User+Addon.h"
#import "Room+Addon.h"
#import "InstagrameContext.h"

@implementation Picture (Addon)

- (BOOL) isVisited{
    return [self.visitors containsObject:instagrameContext.me];
}

- (BOOL) isSubscribed{
    return [self.subscribers containsObject:instagrameContext.me];
}

- (BOOL) isVoted{
    return [self.voters containsObject:instagrameContext.me];
}

+ (NSDictionary*) convertFromParsePicture:(NSDictionary*) parsePicture{
    NSMutableDictionary* picture = [parsePicture mutableCopy];
    
    NSDateFormatter* dateF = [[NSDateFormatter alloc] init];
    [dateF setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateF setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    NSDate* date = [dateF dateFromString:picture[UPDATED_AT]];
    [picture setObject:date forKey:UPDATED_AT];
    
    date = [dateF dateFromString:picture[CREATED_AT]];
    [picture setObject:date forKey:CREATED_AT];
    
    date = [dateF dateFromString:picture[@"submitDate"][@"iso"]];
    [picture setObject:date forKey:@"submitDate"];
    
    [picture removeObjectForKey:@"voters"];
    [picture removeObjectForKey:@"subscribers"];
    [picture removeObjectForKey:@"visitors"];
    picture[@"author"] = [User convertFromParseUser:picture[@"author"]];
    picture[@"room"] = [Room convertFromParseRoom:picture[@"room"]];
    
    NSLog(@"converted picture:\n %@", picture);
    
    return picture;
}
+ (NSArray*) convertParsePictures:(NSArray*) pictures{
    NSMutableArray* result = [NSMutableArray array];
    for (NSDictionary* picture in pictures) {
        [result addObject:[Picture convertFromParsePicture:picture]];
    }
    return result;
}
- (Picture*) updateWithActualData:(NSDictionary*) picture{
    for (NSString *key in picture) {
        if (![key isEqualToString:@"voters"]
            && ![key isEqualToString:@"subscribers"]
            && ![key isEqualToString:@"visitors"]
            && ![key isEqualToString:@"author"]
            && ![key isEqualToString:@"room"]
            && ![key isEqualToString:@"__type"]
            && ![key isEqualToString:@"className"]) {
            [self setValue:picture[key] forKey:key];
        }
    }
    return self;
    
}

@end
