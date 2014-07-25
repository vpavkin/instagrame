//
//  InstagrameContext.h
//  Instagrame
//
//  Created by vpavkin on 23.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstagrameDataSource.h"
#import "User.h"

@interface InstagrameContext : NSObject

@property (strong, nonatomic) User* me;
@property (strong, nonatomic) id <InstagrameDataSource> data;
+ (instancetype) instance;

@end
