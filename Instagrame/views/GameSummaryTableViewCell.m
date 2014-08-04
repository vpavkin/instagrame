//
//  GameSummaryTableViewCell.m
//  Instagrame
//
//  Created by vpavkin on 23.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import "GameSummaryTableViewCell.h"
#import "Room.h"
#import "Room+Addon.h"

@interface GameSummaryTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *imagesContainer;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UILabel *playersCountLabel;

@property (nonatomic, readonly) NSTimeInterval countdown;
@property (nonatomic, readonly) BOOL isTimeRunningUp;
@property (strong, nonatomic) NSTimer* timer;
@end

@implementation GameSummaryTableViewCell

- (void) setRoom:(Room *)room{
    _room = room;
    self.nameLabel.text = _room.task;
    self.playersCountLabel.text = [NSString stringWithFormat:@"%lu", _room.players.count];
    [self updateState];
    [self updateCountdown];
}


- (void) updateCountdown{
    NSTimeInterval countdown = self.countdown;
    if ((countdown / (60*60*24)) >= 1) {
        self.countdownLabel.text = [NSString stringWithFormat:@"%d d.", (int)(countdown / (60*60*24))];
    }else if((countdown / (60*60)) >= 1){
        self.countdownLabel.text = [NSString stringWithFormat:@"%d h.", (int)(countdown / (60*60))];
    }else{
        self.countdownLabel.text = [NSString stringWithFormat:@"%02d:%d", (int)(countdown / 60) % 60, (int)countdown % 60];
    }
    
    [self.timer invalidate];
    if (self.isTimeRunningUp) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(updateCountdown:)
                                       userInfo:nil
                                        repeats:YES];
    }
}

- (void) updateCountdown:sender{
    [self updateCountdown];
}

- (BOOL) isTimeRunningUp{
    return _room.state != RoomStateFinished;
}

- (NSTimeInterval) countdown{
    switch (_room.state) {
        case RoomStateNotStarted:
            return fabs([_room.startDate timeIntervalSinceNow]);
        case RoomStateInPlay:
            return fabs([_room.voteStartDate timeIntervalSinceNow]);
        case RoomStateVoting:
            return fabs([_room.finishDate timeIntervalSinceNow]);
        case RoomStateFinished:
            return fabs([_room.startDate timeIntervalSinceNow]);
    }
}

- (void) updateState{
    switch (_room.state) {
        case RoomStateNotStarted:
            self.stateImageView.image = [UIImage imageNamed:@"not_started"];
            break;
        case RoomStateInPlay:
            self.stateImageView.image = [UIImage imageNamed:@"play"];
            break;
        case RoomStateVoting:
            self.stateImageView.image = [UIImage imageNamed:@"voting"];
            break;
        case RoomStateFinished:
            self.stateImageView.image = [UIImage imageNamed:@"finished"];
            break;
    }
}

- (void) addPhoto:(UIImage *)photo{
    [self.imagesContainer addSubview:[[UIImageView alloc] initWithImage:photo ]];
}

@end
