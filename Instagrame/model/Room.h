//
//  Room.h
//  Instagrame
//
//  Created by vpavkin on 28.07.14.
//  Copyright (c) 2014 instagrame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Picture, User;

@interface Room : NSManagedObject

@property (nonatomic, retain) NSNumber * limit;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * task;
@property (nonatomic, retain) NSDate * voteDate;
@property (nonatomic, retain) NSDate * finishDate;
@property (nonatomic, retain) NSSet *players;
@property (nonatomic, retain) User *owner;
@property (nonatomic, retain) NSSet *pictures;
@end

@interface Room (CoreDataGeneratedAccessors)

- (void)addPlayersObject:(User *)value;
- (void)removePlayersObject:(User *)value;
- (void)addPlayers:(NSSet *)values;
- (void)removePlayers:(NSSet *)values;

- (void)addPicturesObject:(Picture *)value;
- (void)removePicturesObject:(Picture *)value;
- (void)addPictures:(NSSet *)values;
- (void)removePictures:(NSSet *)values;

@end
