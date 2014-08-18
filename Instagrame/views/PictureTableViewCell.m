//
//  PictureTableViewCell.m
//  Instagrame
//
//  Created by vpavkin on 05.08.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "PictureTableViewCell.h"
#import "Picture.h"
#import "Picture+Addon.h"
#import "User.h"
#import "User+Addon.h"
#import "Room.h"
#import "Room+Addon.h"
#import "InstagrameContext.h"

@interface PictureTableViewCell ()


@property (strong, nonatomic) IBOutlet UIImageView *userAvatar;
@property (strong, nonatomic) IBOutlet UILabel *userLabel;
@property (strong, nonatomic) IBOutlet UILabel *karmaLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *preloader;
@property (strong, nonatomic) IBOutlet UIButton *karmaUpButton;
@property (strong, nonatomic) IBOutlet UIButton *karmaDownButton;

@end

@implementation PictureTableViewCell

-(void) setPicture:(Picture *)picture{
    if(_picture == picture)
        return;
    _picture = picture;
    self.backgroundColor = [UIColor clearColor];
    UIImageView* imgview =[[UIImageView alloc] initWithFrame:self.bounds];
    imgview.image = [UIImage imageNamed:@"picture_placeholder"];
    self.backgroundView = imgview;
    
    [self updateLabels];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        UIImage* imgd = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_picture.photoURL]]];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (imgd) {
                UIImageView* imgview =[[UIImageView alloc] initWithFrame:self.bounds];
                imgview.image = imgd;
                self.backgroundView = imgview;
            }
            self.preloader.hidden = YES;
            [self.preloader stopAnimating];
        });
    });
}

- (void) updateLabels{
    self.userAvatar.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: _picture.author.avatarURL]]];
    self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.width / 2;
    self.userAvatar.layer.borderWidth = 2.0f;
    self.userAvatar.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userAvatar.clipsToBounds = YES;
    
    self.descriptionLabel.text = _picture.comment;
    self.userLabel.text = _picture.author.name;
    self.karmaLabel.attributedText = _picture.author.karmaString;
}

- (IBAction)touchKarmaUpButton {
    _picture.author.karma = [NSNumber numberWithInt:[_picture.author.karma intValue] + 1];
}

- (IBAction)touchKarmaDownButton:(id)sender {
    _picture.author.karma = [NSNumber numberWithInt:[_picture.author.karma intValue] - 1];
}

@end
