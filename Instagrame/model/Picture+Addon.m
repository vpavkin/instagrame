//
//  Picture.m
//  Instagrame
//
//  Created by vpavkin on 24.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "Picture.h"

@implementation Picture (Addon)

+ (instancetype) picture:(NSString*) uid
                  author:(User*) author
                    room:(Room*) room
                   image:(NSString*) image
                  voters:(NSArray*) voters
             subscribers:(NSArray*) subscribers
                visitors:(NSArray*) visitors
              submitDate:(NSDate*) submitDate{
    Picture * p = [[Picture alloc]init];
    p.author = author;
    p.room = room;
    p.image = image;
    p.voters = [NSSet setWithArray:voters];
    p.subscribers = [NSSet setWithArray:voters];
    p.visitors = [NSSet setWithArray:voters];
    p.submitDate = submitDate;
    return  p;
}

@end
