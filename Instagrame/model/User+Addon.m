//
//  User+Addon.m
//  Instagrame
//
//  Created by vpavkin on 30.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "User+Addon.h"
#import "InstagrameContext.h"

@implementation User (Addon)

+ (NSDictionary*) convertFromParseUser:(NSDictionary*) parseUser{
    NSMutableDictionary* user = [parseUser mutableCopy];
    
    NSDateFormatter* dateF = [[NSDateFormatter alloc] init];
    [dateF setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateF setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    NSDate* date = [dateF dateFromString:user[UPDATED_AT]];
    if (!date) {
        NSLog(@"Error parsing %@", UPDATED_AT);
    }
    [user setObject:date forKey:UPDATED_AT];
    
    date = [dateF dateFromString:user[CREATED_AT]];
    if (!date) {
        NSLog(@"Error parsing %@", CREATED_AT);
    }
    [user setObject:date forKey:CREATED_AT];
    
    return user;
}

+ (NSDictionary*) convertFromVkUser:(NSDictionary*) vkUser{
    return @{
             @"name":[@[vkUser[@"first_name"],vkUser[@"last_name"]] componentsJoinedByString:@" "],
             @"avatarURL":vkUser[@"photo_100"],
             @"vkId":vkUser[@"uid"],
             @"karma":@0,
             @"coins":@5
             };
}

- (User*) updateWithActualData:(NSDictionary*) user{
    for (NSString *key in user) {
        if (![key isEqualToString:@"password"]) {
            [self setValue:user[key] forKey:key];
            
        }
    }
    return self;
}

@end
