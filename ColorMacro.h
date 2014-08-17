//
//  ColorMarco.h
//  Instagrame
//
//  Created by vpavkin on 23.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

