//
//  User+Addon.h
//  Instagrame
//
//  Created by vpavkin on 30.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "User.h"

@interface User (Addon)

@property (nonatomic,readonly) NSAttributedString* nameWithKarma;
@property (nonatomic,readonly) NSAttributedString* karmaString;
@property (nonatomic,readonly) UIColor* karmaColor;

+ (NSDictionary*) convertFromParseUser:(NSDictionary*) parseUser;
+ (NSArray*) convertParseUsers:(NSArray*) users;
+ (NSDictionary*) convertFromVkUser:(NSDictionary*) vkUser;
- (User*) updateWithActualData:(NSDictionary*) user;

@end
