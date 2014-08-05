//
//  PictureTableViewCell.h
//  Instagrame
//
//  Created by vpavkin on 05.08.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Picture;

@interface PictureTableViewCell : UITableViewCell

@property (strong,nonatomic) Picture* picture;

@end
