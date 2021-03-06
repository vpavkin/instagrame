//
//  User.h
//  Instagrame
//
//  Created by vpavkin on 31.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Picture, Room;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * avatarURL;
@property (nonatomic, retain) NSNumber * coins;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * karma;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * vkId;
@property (nonatomic, retain) NSSet *picturesMade;
@property (nonatomic, retain) NSSet *picturesSubscribed;
@property (nonatomic, retain) NSSet *picturesVisited;
@property (nonatomic, retain) NSSet *picturesVoted;
@property (nonatomic, retain) NSSet *roomsOwned;
@property (nonatomic, retain) NSSet *roomsPlayed;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addPicturesMadeObject:(Picture *)value;
- (void)removePicturesMadeObject:(Picture *)value;
- (void)addPicturesMade:(NSSet *)values;
- (void)removePicturesMade:(NSSet *)values;

- (void)addPicturesSubscribedObject:(Picture *)value;
- (void)removePicturesSubscribedObject:(Picture *)value;
- (void)addPicturesSubscribed:(NSSet *)values;
- (void)removePicturesSubscribed:(NSSet *)values;

- (void)addPicturesVisitedObject:(Picture *)value;
- (void)removePicturesVisitedObject:(Picture *)value;
- (void)addPicturesVisited:(NSSet *)values;
- (void)removePicturesVisited:(NSSet *)values;

- (void)addPicturesVotedObject:(Picture *)value;
- (void)removePicturesVotedObject:(Picture *)value;
- (void)addPicturesVoted:(NSSet *)values;
- (void)removePicturesVoted:(NSSet *)values;

- (void)addRoomsOwnedObject:(Room *)value;
- (void)removeRoomsOwnedObject:(Room *)value;
- (void)addRoomsOwned:(NSSet *)values;
- (void)removeRoomsOwned:(NSSet *)values;

- (void)addRoomsPlayedObject:(Room *)value;
- (void)removeRoomsPlayedObject:(Room *)value;
- (void)addRoomsPlayed:(NSSet *)values;
- (void)removeRoomsPlayed:(NSSet *)values;

@end
