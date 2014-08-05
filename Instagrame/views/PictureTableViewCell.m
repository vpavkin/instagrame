//
//  PictureTableViewCell.m
//  Instagrame
//
//  Created by vpavkin on 05.08.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "PictureTableViewCell.h"
#import "Picture.h"

@implementation PictureTableViewCell

-(void) setPicture:(Picture *)picture{
    _picture = picture;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        UIImage* imgd = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_picture.photoURL]]];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            UIImageView* imgview =[[UIImageView alloc] initWithFrame:self.bounds];
            imgview.image = imgd;
            self.backgroundView = imgview;
            
        });
    });
    
}

@end
