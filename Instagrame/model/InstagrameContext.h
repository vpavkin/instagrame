//
//  InstagrameContext.h
//  Instagrame
//
//  Created by vpavkin on 23.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagrameContext : NSObject

@property (strong, nonatomic) NSString* userName;
@property (strong, nonatomic) UIImage* userAvatar;

+ (instancetype) instance;

@end
