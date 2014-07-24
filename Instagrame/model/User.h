//
//  User.h
//  Instagrame
//
//  Created by vpavkin on 23.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

- (instancetype) initWithName:(NSString*) name avatar:(UIImage*) avatar;

@property (strong,nonatomic) NSString *uid;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) UIImage *avatar;
@property (nonatomic) NSInteger karma;
@property (nonatomic) NSInteger coins;

@end
