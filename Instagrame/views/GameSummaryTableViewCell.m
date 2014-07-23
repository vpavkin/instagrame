//
//  GameSummaryTableViewCell.m
//  Instagrame
//
//  Created by vpavkin on 23.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "GameSummaryTableViewCell.h"

@interface GameSummaryTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *imagesContainer;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UILabel *playersCountLabel;

@end

@implementation GameSummaryTableViewCell

- (void) setName:(NSString *)name{
    _name = name;
    self.nameLabel.text = name;
}

- (void) setState:(NSUInteger)state{
    
}

- (void) addPhoto:(UIImage *)photo{
    [self.imagesContainer addSubview:[[UIImageView alloc] initWithImage:photo ]];
}

@end
