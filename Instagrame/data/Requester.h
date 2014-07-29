//
//  Requester.h
//  Instagrame
//
//  Created by vpavkin on 29.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Requester : NSObject

- (void) userForEmail:(NSString*) email
          andPassword: (NSString*) password
           completion: (void(^)(BOOL success, NSDictionary *data))completion;

@end