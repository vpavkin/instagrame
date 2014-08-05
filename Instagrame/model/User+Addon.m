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
    [result appendAttributedString: [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" (%@)",self.karmaString]
                                                                  attributes:@{NSForegroundColorAttributeName:self.karmaColor}]];
    return result;
}

-(NSString*) karmaString{
    if (self.karma.intValue > 0) {
        return [NSString stringWithFormat:@"+%@", self.karma];
    }
    return self.karma.description;
}

-(UIColor*) karmaColor{
    UIColor* baseColor;
    if (self.karma.intValue < 0) {
        baseColor = [UIColor redColor];
    }else if(self.karma.intValue > 0){
        baseColor = Rgb2UIColor(0x4c, 0xd9, 0x64);
    }else
        return [UIColor whiteColor];
    
    return [User changeBrightness:baseColor amount: (fabs(100-self.karma.intValue)/100.0)];
}

+ (UIColor*)changeBrightness:(UIColor*)color amount:(CGFloat)amount{
    
    CGFloat hue, saturation, brightness, alpha;
    if ([color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]) {
        brightness += (amount-1.0);
        brightness = MAX(MIN(brightness, 1.0), 0.0);
        return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
    }
    
    CGFloat white;
    if ([color getWhite:&white alpha:&alpha]) {
        white += (amount-1.0);
        white = MAX(MIN(white, 1.0), 0.0);
        return [UIColor colorWithWhite:white alpha:alpha];
    }
    
    return nil;
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
