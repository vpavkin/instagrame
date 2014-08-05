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


@property (strong, nonatomic) IBOutlet UIButton *userButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *preloader;
@property (strong, nonatomic) IBOutlet UIButton *karmaUpButton;
@property (strong, nonatomic) IBOutlet UIButton *karmaDownButton;
@property (strong, nonatomic) IBOutlet UIButton *subscribeButton;
@property (strong, nonatomic) IBOutlet UIButton *voteButton;

@end

@implementation PictureTableViewCell

-(void) setPicture:(Picture *)picture{
    if(_picture == picture)
        return;
    _picture = picture;
    self.descriptionLabel.text = _picture.comment;
    [self updateVoteButton];
    [self updateSubscribeButton];
    [self updateUserButton];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        UIImage* imgd = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_picture.photoURL]]];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            UIImageView* imgview =[[UIImageView alloc] initWithFrame:self.bounds];
            imgview.image = imgd;
            self.backgroundView = imgview;
            self.preloader.hidden = YES;
            [self.preloader stopAnimating];
        });
    });
}

- (void) updateVoteButton{
    self.voteButton.imageView.image = [UIImage imageNamed: (_picture.isVoted ? @"thumb_voted" : @"thumb_normal")];
    self.voteButton.alpha = (_picture.isVoted ? 1 : 0.5);
}

- (void) updateSubscribeButton{
    self.subscribeButton.imageView.image = [UIImage imageNamed: (_picture.isSubscribed ? @"star_subscribed" : @"star_normal")];
    self.voteButton.alpha = (_picture.isVoted ? 1 : 0.5);
}

- (void) updateUserButton{
    [self.userButton setAttributedTitle:_picture.author.nameWithKarma
                               forState:UIControlStateNormal];
}

- (IBAction)touchVoteButton:(UIButton *)sender {
    if (!_picture.isVoted && !_picture.room.isVoted) {
        [_picture addVotersObject:instagrameContext.me];
        [self updateVoteButton];
    }else if (_picture.isVoted){
        [_picture removeVotersObject:instagrameContext.me];
        [self updateVoteButton];
    }
}

- (IBAction)touchSubscribeButton {
    if (!_picture.isSubscribed){
        [_picture addSubscribersObject:instagrameContext.me];
    }else{
        [_picture removeSubscribersObject:instagrameContext.me];
    }
    [self updateSubscribeButton];
}

- (IBAction)touchKarmaUpButton {
    _picture.author.karma = [NSNumber numberWithInt:[_picture.author.karma intValue] + 1];
    [self updateUserButton];
}

- (IBAction)touchKarmaDownButton:(id)sender {
    _picture.author.karma = [NSNumber numberWithInt:[_picture.author.karma intValue] - 1];
    [self updateUserButton];
}

@end
