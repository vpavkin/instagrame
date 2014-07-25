//
//  Picture.m
//  Instagrame
//
//  Created by vpavkin on 24.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "Picture.h"

@implementation Picture

+ (instancetype) picture:(NSString*) uid
                  author:(User*) author
                    room:(Room*) room
                   image:(UIImage*) image
                  voters:(NSArray*) voters
            isSubscribed:(BOOL) isSubscribed
               isVisited:(BOOL) isVisited
              submitDate:(NSDate*) submitDate{
    Picture * p = [[Picture alloc]init];
    p.uid = uid;
    p.author = author;
    p.room = room;
    p.image = image;
    p.voters = voters;
    p.subscribed = isSubscribed;
    p.visited = isVisited;
    p.submitDate = submitDate;
    
    return  p;
}

@end
