//
//  User+Addon.m
//  Instagrame
//
//  Created by vpavkin on 30.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "User.h"
#import "User+Addon.h"
#import "InstagrameContext.h"

@implementation User (Addon)

-(NSAttributedString*) nameWithKarma{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc]initWithString:self.name
                                                                              attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [result appendAttributedString: [[NSAttributedString alloc] initWithString:@" ("
                                                                    attributes:@{NSForegroundColorAttributeName:self.karmaColor}]];
    [result appendAttributedString:self.karmaString];
    [result appendAttributedString: [[NSAttributedString alloc] initWithString:@")"
                                                                    attributes:@{NSForegroundColorAttributeName:self.karmaColor}]];
    return result;
}



-(NSAttributedString*) karmaString{
    return [[NSAttributedString alloc]initWithString:
            self.karma.intValue > 0 ? [NSString stringWithFormat:@"+%@", self.karma] : self.karma.description
                                          attributes:@{NSForegroundColorAttributeName:self.karmaColor}];
}

-(UIColor*) karmaColor{
    int v =self.karma.intValue;
    if ( v < -100) {
        return [UIColor colorWithRed:0.502 green:0.000 blue:0.000 alpha:1.000];
    }else if(self.karma.intValue < -50){
        return [UIColor colorWithRed:0.939 green:0.131 blue:0.150 alpha:1.000];
    }else if(self.karma.intValue < 0){
        return [UIColor colorWithRed:1.000 green:0.400 blue:0.400 alpha:1.000];
    }else if(self.karma.intValue == 0){
        return [UIColor whiteColor];
    }else if(self.karma.intValue < 50){
        return [UIColor colorWithRed:0.441 green:0.837 blue:0.427 alpha:1.000];
    }else if(self.karma.intValue < 100){
        return [UIColor colorWithRed:0.175 green:0.694 blue:0.175 alpha:1.000];
    }
    return [UIColor colorWithRed:0.119 green:0.536 blue:0.144 alpha:1.000];
    
}

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

+ (NSArray*) convertParseUsers:(NSArray*) users{
    NSMutableArray* result = [NSMutableArray array];
    for (NSDictionary* user in users) {
        [result addObject:[User convertFromParseUser:user]];
    }
    return result;
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
        if (![key isEqualToString:@"password"] && ![key isEqualToString:@"__type"] && ![key isEqualToString:@"className"]) {
            [self setValue:user[key] forKey:key];
            
        }
    }
    return self;
}

@end
