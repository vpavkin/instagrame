//
//  User.m
//  Instagrame
//
//  Created by vpavkin on 23.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "User.h"

@implementation User (Addon)

+ (instancetype) user:(NSString*) name avatar:(UIImage*) avatar uid:(NSString*)uid karma:(NSInteger)karma coins:(NSInteger) coins{
    User *user = [[User alloc]init];
    user.name = name;
//    user.avatar = avatar;
//    user.uid = uid;
//    user.karma = karma;
//    user.coins = coins;
    return user;
}

@end
